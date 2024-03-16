# GdUnit generated TestSuite
class_name CmdCommandHandlerTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/cmd/CmdCommandHandler.gd'

var _cmd_options: CmdOptions
var _cmd_instance: TestCommands


# small example of command class
class TestCommands:
	func cmd_a() -> String:
		return "cmd_a"

	func cmd_foo() -> String:
		return "cmd_foo"

	func cmd_bar(value :String) -> String:
		return value

	func cmd_bar2(value_a: String, value_b: String) -> Array:
		return [value_a, value_b]

	func cmd_x() -> String:
		return "cmd_x"


func before() -> void:
	# setup command options
	_cmd_options = CmdOptions.new([
		CmdOption.new("-a", "some help text a", "some description a"),
		CmdOption.new("-f, --foo", "some help text foo", "some description foo"),
		CmdOption.new("-b, --bar", "some help text bar", "some description bar"),
		CmdOption.new("-b2, --bar2", "some help text bar", "some description bar"),
	],
	# advnaced options
	[
		CmdOption.new("-x", "some help text x", "some description x"),
	])
	_cmd_instance = TestCommands.new()


func test__validate_no_registerd_commands() -> void:
	var cmd_handler := CmdCommandHandler.new(_cmd_options)

	assert_result(cmd_handler._validate()).is_success()


func test__validate_registerd_commands() -> void:
	var cmd_handler: = CmdCommandHandler.new(_cmd_options)
	cmd_handler.register_cb("-a", Callable(_cmd_instance, "cmd_a"))
	cmd_handler.register_cb("-f", Callable(_cmd_instance, "cmd_foo"))
	cmd_handler.register_cb("-b", Callable(_cmd_instance, "cmd_bar"))

	assert_result(cmd_handler._validate()).is_success()


func test__validate_registerd_unknown_commands() -> void:
	var cmd_handler: = CmdCommandHandler.new(_cmd_options)
	cmd_handler.register_cb("-a", Callable(_cmd_instance, "cmd_a"))
	cmd_handler.register_cb("-d", Callable(_cmd_instance, "cmd_foo"))
	cmd_handler.register_cb("-b", Callable(_cmd_instance, "cmd_bar"))
	cmd_handler.register_cb("-y", Callable(_cmd_instance, "cmd_x"))

	assert_result(cmd_handler._validate())\
		.is_error()\
		.contains_message("The command '-d' is unknown, verify your CmdOptions!\nThe command '-y' is unknown, verify your CmdOptions!")


func test__validate_registerd_invalid_callbacks() -> void:
	var cmd_handler := CmdCommandHandler.new(_cmd_options)
	cmd_handler.register_cb("-a", Callable(_cmd_instance, "cmd_a"))
	cmd_handler.register_cb("-f")
	cmd_handler.register_cb("-b", Callable(_cmd_instance, "cmd_not_exists"))

	assert_result(cmd_handler._validate())\
		.is_error()\
		.contains_message("Invalid function reference for command '-b', Check the function reference!")


func test__validate_registerd_register_same_callback_twice() -> void:
	var cmd_handler: = CmdCommandHandler.new(_cmd_options)
	cmd_handler.register_cb("-a", Callable(_cmd_instance, "cmd_a"))
	cmd_handler.register_cb("-b", Callable(_cmd_instance, "cmd_a"))
	if cmd_handler._enhanced_fr_test:
		assert_result(cmd_handler._validate())\
			.is_error()\
			.contains_message("The function reference 'cmd_a' already registerd for command '-a'!")


func test_execute_no_commands() -> void:
	var cmd_handler: = CmdCommandHandler.new(_cmd_options)
	assert_result(cmd_handler.execute([])).is_success()


func test_execute_commands_no_cb_registered() -> void:
	var cmd_handler: = CmdCommandHandler.new(_cmd_options)
	assert_result(cmd_handler.execute([CmdCommand.new("-a")])).is_success()


func test_execute_commands_with_cb_registered() -> void:
	var cmd_handler: = CmdCommandHandler.new(_cmd_options)
	var cmd_spy = spy(_cmd_instance)

	cmd_handler.register_cb("-a", Callable(cmd_spy, "cmd_a"))
	cmd_handler.register_cb("-b", Callable(cmd_spy, "cmd_bar"))
	cmd_handler.register_cbv("-b2", Callable(cmd_spy, "cmd_bar2"))

	assert_result(cmd_handler.execute([CmdCommand.new("-a")])).is_success()
	verify(cmd_spy).cmd_a()
	verify_no_more_interactions(cmd_spy)

	reset(cmd_spy)
	assert_result(cmd_handler.execute([
		CmdCommand.new("-a"),
		CmdCommand.new("-b", ["some_value"]),
		CmdCommand.new("-b2", ["value1", "value2"])])).is_success()
	verify(cmd_spy).cmd_a()
	verify(cmd_spy).cmd_bar("some_value")
	verify(cmd_spy).cmd_bar2("value1", "value2")
	verify_no_more_interactions(cmd_spy)
