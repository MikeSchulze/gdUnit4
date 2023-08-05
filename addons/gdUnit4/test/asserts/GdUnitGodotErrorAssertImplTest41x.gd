# GdUnit generated TestSuite
class_name GdUnitGodotErrorAssertImplTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitGodotErrorAssertImpl.gd'


class GodotErrorTestClass:
	
	func test(value :int) -> void:
		match value:
			0:
				@warning_ignore("assert_always_true")
				assert(true, "no error" )
			1: # failing assert
				if OS.is_debug_build():
					# do not break the debug session we simmulate a assert by writing the error manually
					prints("""
						USER SCRIPT ERROR: Assertion failed: this is an assert error
						   at: GodotErrorTestClass.test (res://addons/gdUnit4/test/asserts/GdUnitGodotErrorAssertImplTest.gd:18)
					""".dedent())
				else:
					assert(false, "this is an assert error" )
			2: # push_warning
				push_warning('this is an push_warning')
			3: # push_error
				push_error('this is an push_error')
				pass
			4: # runtime error
				if OS.is_debug_build():
					# do not break the debug session we simmulate a assert by writing the error manually
					prints("""
						USER SCRIPT ERROR: Division by zero error in operator '/'.
						   at: GodotErrorTestClass.test (res://addons/gdUnit4/test/asserts/GdUnitGodotErrorAssertImplTest.gd:32)
					""".dedent())
				else:
					var a = 0
					@warning_ignore("integer_division")
					@warning_ignore("unused_variable")
					var x = 1/a


var _save_is_report_push_errors :bool
var _save_is_report_script_errors :bool


func before():
	# we need to exclude this test suite for Godot versions >= 4.1.x
	# see https://github.com/godotengine/godot/issues/80292
	# we cover test for older versions by `res://addons/gdUnit4/test/asserts/GdUnitGodotErrorAssertImplTest40x.gd`
	skip(Engine.get_version_info().hex < 0x40100)
	_save_is_report_push_errors = GdUnitSettings.is_report_push_errors()
	_save_is_report_script_errors = GdUnitSettings.is_report_script_errors()
	# disable default error reporting for testing
	ProjectSettings.set_setting(GdUnitSettings.REPORT_PUSH_ERRORS, false)
	ProjectSettings.set_setting(GdUnitSettings.REPORT_SCRIPT_ERRORS, false)


func after():
	ProjectSettings.set_setting(GdUnitSettings.REPORT_PUSH_ERRORS, _save_is_report_push_errors)
	ProjectSettings.set_setting(GdUnitSettings.REPORT_SCRIPT_ERRORS, _save_is_report_script_errors)


func test_is_success() -> void:
	await assert_error(func (): GodotErrorTestClass.new().test(0)).is_success()


func test_is_assert_failed() -> void:
	await assert_error(func (): GodotErrorTestClass.new().test(1))\
		.is_runtime_error('Assertion failed: this is an assert error')



func test_is_push_warning() -> void:
	await assert_error(func (): GodotErrorTestClass.new().test(2))\
		.is_push_warning('this is an push_warning')


func test_is_push_error() -> void:
	await assert_error(func (): GodotErrorTestClass.new().test(3))\
		.is_push_error('this is an push_error')


func test_is_runtime_error() -> void:
	await assert_error(func (): GodotErrorTestClass.new().test(4))\
		.is_runtime_error("Division by zero error in operator '/'.")
