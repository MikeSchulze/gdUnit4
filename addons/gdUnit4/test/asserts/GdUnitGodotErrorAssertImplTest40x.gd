# GdUnit generated TestSuite
### Workaround to https://github.com/godotengine/godot/issues/80292
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitGodotErrorAssertImpl.gd'

var _save_is_report_push_errors :bool
var _save_is_report_script_errors :bool


func before():
	_save_is_report_push_errors = GdUnitSettings.is_report_push_errors()
	_save_is_report_script_errors = GdUnitSettings.is_report_script_errors()
	# disable default error reporting for testing
	ProjectSettings.set_setting(GdUnitSettings.REPORT_PUSH_ERRORS, false)
	ProjectSettings.set_setting(GdUnitSettings.REPORT_SCRIPT_ERRORS, false)


func after():
	ProjectSettings.set_setting(GdUnitSettings.REPORT_PUSH_ERRORS, _save_is_report_push_errors)
	ProjectSettings.set_setting(GdUnitSettings.REPORT_SCRIPT_ERRORS, _save_is_report_script_errors)


func test_is_success() -> void:
	var assert_ := assert_error(func (): GdUnitGodotErrorAssertImplTest.GodotErrorTestClass.new().test(0))
	await assert_.is_success()


func test_is_assert_failed() -> void:
	var assert_ := assert_error(func (): GdUnitGodotErrorAssertImplTest.GodotErrorTestClass.new().test(1))
	await assert_.is_runtime_error('Assertion failed: this is an assert error')


func test_is_push_warning() -> void:
	var assert_ := assert_error(func (): GdUnitGodotErrorAssertImplTest.GodotErrorTestClass.new().test(2))
	await assert_.is_push_warning('this is an push_warning')


func test_is_push_error() -> void:
	var assert_ := assert_error(func (): GdUnitGodotErrorAssertImplTest.GodotErrorTestClass.new().test(3))
	await assert_.is_push_error('this is an push_error')


func test_is_runtime_error() -> void:
	var assert_ := assert_error(func (): GdUnitGodotErrorAssertImplTest.GodotErrorTestClass.new().test(4))
	await assert_.is_runtime_error("Division by zero error in operator '/'.")
