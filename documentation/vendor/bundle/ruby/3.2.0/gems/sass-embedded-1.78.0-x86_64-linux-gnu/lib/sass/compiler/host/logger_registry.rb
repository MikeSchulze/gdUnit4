# frozen_string_literal: true

module Sass
  class Compiler
    class Host
      # The {LoggerRegistry} class.
      #
      # It stores logger and handles log events.
      class LoggerRegistry
        def initialize(logger)
          logger = Structifier.to_struct(logger, :debug, :warn)

          { debug: DebugContext, warn: WarnContext }.each do |symbol, context_class|
            next unless logger.respond_to?(symbol)

            define_singleton_method(symbol) do |event|
              logger.public_send(symbol, event.message, context_class.new(event))
            end
          end
        end

        def log(event)
          case event.type
          when :DEBUG
            debug(event)
          when :DEPRECATION_WARNING, :WARNING
            warn(event)
          else
            raise ArgumentError, "Unknown LogEvent.type #{event.type}"
          end
        end

        private

        def debug(event)
          Kernel.warn(event.formatted)
        end

        def warn(event)
          Kernel.warn(event.formatted)
        end

        # Contextual information passed to `debug`.
        class DebugContext
          # @return [Logger::SourceSpan, nil]
          attr_reader :span

          def initialize(event)
            @span = event.span.nil? ? nil : Logger::SourceSpan.new(event.span)
          end
        end

        private_constant :DebugContext

        # Contextual information passed to `warn`.
        class WarnContext < DebugContext
          # @return [Boolean]
          attr_reader :deprecation

          # @return [String, nil]
          attr_reader :deprecation_type

          # @return [String]
          attr_reader :stack

          def initialize(event)
            super
            @deprecation = event.type == :DEPRECATION_WARNING
            @deprecation_type = (event.deprecation_type if @deprecation)
            @stack = event.stack_trace
          end
        end

        private_constant :WarnContext
      end

      private_constant :LoggerRegistry
    end
  end
end
