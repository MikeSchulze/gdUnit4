# frozen_string_literal: true

module Sass
  # The {ELF} class.
  #
  # It parses ELF header to extract interpreter.
  # @see https://github.com/torvalds/linux/blob/HEAD/include/uapi/linux/elf.h
  # @see https://github.com/torvalds/linux/blob/HEAD/kernel/kexec_elf.c
  class ELF
    module PackInfo
      PACK_MAP = {
        Elf32_Ehdr: 'S<2L<5S<6',
        Elf64_Ehdr: 'S<2L<Q<3L<S<6',
        Elf32_Phdr: 'L<8',
        Elf64_Phdr: 'L<2Q<6'
      }.freeze

      SIZE_MAP = {
        Elf32_Ehdr: 36,
        Elf64_Ehdr: 48,
        Elf32_Phdr: 32,
        Elf64_Phdr: 56
      }.freeze

      STRUCT_MAP = {
        Elf32_Ehdr: %i[
          e_type
          e_machine
          e_version
          e_entry
          e_phoff
          e_shoff
          e_flags
          e_ehsize
          e_phentsize
          e_phnum
          e_shentsize
          e_shnum
          e_shstrndx
        ].freeze,
        Elf64_Ehdr: %i[
          e_type
          e_machine
          e_version
          e_entry
          e_phoff
          e_shoff
          e_flags
          e_ehsize
          e_phentsize
          e_phnum
          e_shentsize
          e_shnum
          e_shstrndx
        ].freeze,
        Elf32_Phdr: %i[
          p_type
          p_offset
          p_vaddr
          p_paddr
          p_filesz
          p_memsz
          p_flags
          p_align
        ].freeze,
        Elf64_Phdr: %i[
          p_type
          p_flags
          p_offset
          p_vaddr
          p_paddr
          p_filesz
          p_memsz
          p_align
        ].freeze
      }.freeze
    end

    private_constant :PackInfo

    # These constants are for the segment types stored in the image headers
    PT_NULL         = 0
    PT_LOAD         = 1
    PT_DYNAMIC      = 2
    PT_INTERP       = 3
    PT_NOTE         = 4
    PT_SHLIB        = 5
    PT_PHDR         = 6
    PT_TLS          = 7
    PT_LOOS         = 0x60000000
    PT_HIOS         = 0x6fffffff
    PT_LOPROC       = 0x70000000
    PT_HIPROC       = 0x7fffffff

    # These constants define the different elf file types
    ET_NONE   = 0
    ET_REL    = 1
    ET_EXEC   = 2
    ET_DYN    = 3
    ET_CORE   = 4
    ET_LOPROC = 0xff00
    ET_HIPROC = 0xffff

    EI_NIDENT = 16

    # e_ident[] indexes
    EI_MAG0    = 0
    EI_MAG1    = 1
    EI_MAG2    = 2
    EI_MAG3    = 3
    EI_CLASS   = 4
    EI_DATA    = 5
    EI_VERSION = 6
    EI_OSABI   = 7
    EI_PAD     = 8

    # EI_MAG
    ELFMAG0 = 0x7f
    ELFMAG1 = 0x45
    ELFMAG2 = 0x4c
    ELFMAG3 = 0x46
    ELFMAG  = [ELFMAG0, ELFMAG1, ELFMAG2, ELFMAG3].pack('C*')
    SELFMAG = 4

    # e_ident[EI_CLASS]
    ELFCLASSNONE = 0
    ELFCLASS32   = 1
    ELFCLASS64   = 2
    ELFCLASSNUM  = 3

    # e_ident[EI_DATA]
    ELFDATANONE = 0
    ELFDATA2LSB = 1
    ELFDATA2MSB = 2

    def initialize(buffer)
      @buffer = buffer

      @ehdr = { e_ident: @buffer.read(EI_NIDENT).unpack('C*') }
      raise ArgumentError unless @ehdr[:e_ident].slice(EI_MAG0, SELFMAG).pack('C*') == ELFMAG

      case @ehdr[:e_ident][EI_CLASS]
      when ELFCLASS32
        elf_ehdr = :Elf32_Ehdr
        elf_phdr = :Elf32_Phdr
      when ELFCLASS64
        elf_ehdr = :Elf64_Ehdr
        elf_phdr = :Elf64_Phdr
      else
        raise ArgumentError
      end

      case @ehdr[:e_ident][EI_DATA]
      when ELFDATA2LSB
        little_endian = true
      when ELFDATA2MSB
        little_endian = false
      else
        raise ArgumentError
      end

      @ehdr.merge!(read(elf_ehdr, little_endian))

      @buffer.seek(@ehdr[:e_phoff], IO::SEEK_SET)
      @proghdrs = Array.new(@ehdr[:e_phnum]) do
        read(elf_phdr, little_endian)
      end
    end

    def relocatable?
      @ehdr[:e_type] == ET_REL
    end

    def executable?
      @ehdr[:e_type] == ET_EXEC
    end

    def shared_object?
      @ehdr[:e_type] == ET_DYN
    end

    def core?
      @ehdr[:e_type] == ET_CORE
    end

    def interpreter
      phdr = @proghdrs.find { |p| p[:p_type] == PT_INTERP }
      return if phdr.nil?

      @buffer.seek(phdr[:p_offset], IO::SEEK_SET)
      interpreter = @buffer.read(phdr[:p_filesz])
      raise ArgumentError unless interpreter.end_with?("\0")

      interpreter.chomp!("\0")
    end

    private

    def read(type, little_endian)
      size = PackInfo::SIZE_MAP[type]
      format = little_endian ? PackInfo::PACK_MAP[type] : PackInfo::PACK_MAP[type].tr('<', '>')
      [PackInfo::STRUCT_MAP[type], @buffer.read(size).unpack(format)].transpose.to_h
    end

    INTERPRETER = begin
      proc_self_exe = '/proc/self/exe'
      if File.exist?(proc_self_exe)
        File.open(proc_self_exe, 'rb') do |file|
          elf = ELF.new(file)
          interpreter = elf.interpreter
          if interpreter.nil? && elf.shared_object?
            File.readlink(proc_self_exe)
          else
            interpreter
          end
        end
      end
    end
  end

  private_constant :ELF
end
