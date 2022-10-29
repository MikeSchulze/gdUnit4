# GdUnit generated TestSuite
class_name CmdConsoleTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/cmd/CmdConsole.gd'

func test_print_color_default() -> void:
	var console :CmdConsole = spy(CmdConsole.new())
	
	console.print_color("test message", Color.RED)
	verify(console).color(Color.RED)
	verify(console).end_color()
	verify(console).printl("test message")
	verify(console).bold(false)
	verify(console).italic(false)
	verify(console).underline(false)
	verify(console, 0).new_line()
	
	reset(console)
	console.print_color("test message2", Color.BLUE)
	verify(console).color(Color.BLUE)
	verify(console).end_color()
	verify(console).printl("test message2")
	verify(console).bold(false)
	verify(console).italic(false)
	verify(console).underline(false)
	verify(console, 0).new_line()

func test_print_color_with_flags() -> void:
	var console :CmdConsole = spy(CmdConsole.new())
	
	# bold
	console.print_color("test message", Color.RED, CmdConsole.BOLD)
	verify(console).bold(true)
	verify(console).italic(false)
	verify(console).underline(false)
	reset(console)
	
	# italic
	console.print_color("test message", Color.RED, CmdConsole.ITALIC)
	verify(console).bold(false)
	verify(console).italic(true)
	verify(console).underline(false)
	reset(console)
	
	# underline
	console.print_color("test message", Color.RED, CmdConsole.UNDERLINE)
	verify(console).bold(false)
	verify(console).italic(false)
	verify(console).underline(true)
	reset(console)
	
	# combile italic & underline
	console.print_color("test message", Color.RED, CmdConsole.ITALIC|CmdConsole.UNDERLINE)
	verify(console).bold(false)
	verify(console).italic(true)
	verify(console).underline(true)
	reset(console)
	
	# combile bold & italic
	console.print_color("test message", Color.RED, CmdConsole.BOLD|CmdConsole.ITALIC)
	verify(console).bold(true)
	verify(console).italic(true)
	verify(console).underline(false)
	reset(console)
	
	# combile all
	console.print_color("test message", Color.RED, CmdConsole.BOLD|CmdConsole.ITALIC|CmdConsole.UNDERLINE)
	verify(console).bold(true)
	verify(console).italic(true)
	verify(console).underline(true)
	reset(console)

func test_prints_color() -> void:
	var console :CmdConsole = spy(CmdConsole.new())
	
	console.prints_color("test message", Color.RED, CmdConsole.BOLD|CmdConsole.ITALIC)
	# verify prints delegates to print_color
	verify(console).print_color("test message", Color.RED, CmdConsole.BOLD|CmdConsole.ITALIC)
	# and adds a new line
	verify(console).new_line()
