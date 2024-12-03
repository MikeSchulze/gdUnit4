
# GdUnit generated TestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/command/GdUnitCommandHandler.gd'

var _handler :GdUnitCommandHandler


func before() -> void:
	_handler = GdUnitCommandHandler.new()


func after() -> void:
	_handler.free()


@warning_ignore('unused_parameter')
func test_create_shortcuts_defaults(shortcut :GdUnitShortcut.ShortCut, expected :String, test_parameters := [
	[GdUnitShortcut.ShortCut.RUN_TESTCASE, "GdUnitShortcutAction: RUN_TESTCASE (Ctrl+Alt+F5) -> Run TestCases"],
	[GdUnitShortcut.ShortCut.RUN_TESTCASE_DEBUG, "GdUnitShortcutAction: RUN_TESTCASE_DEBUG (Ctrl+Alt+F6) -> Run TestCases (Debug)"],
	[GdUnitShortcut.ShortCut.RERUN_TESTS, "GdUnitShortcutAction: RERUN_TESTS (Ctrl+F5) -> ReRun Tests"],
	[GdUnitShortcut.ShortCut.RERUN_TESTS_DEBUG, "GdUnitShortcutAction: RERUN_TESTS_DEBUG (Ctrl+F6) -> ReRun Tests (Debug)"],
	[GdUnitShortcut.ShortCut.RUN_TESTS_OVERALL, "GdUnitShortcutAction: RUN_TESTS_OVERALL (Ctrl+F7) -> Debug Overall TestSuites"],
	[GdUnitShortcut.ShortCut.STOP_TEST_RUN, "GdUnitShortcutAction: STOP_TEST_RUN (Ctrl+F8) -> Stop Test Run"],
	[GdUnitShortcut.ShortCut.CREATE_TEST, "GdUnitShortcutAction: CREATE_TEST (Ctrl+Alt+F10) -> Create TestCase"],]) -> void:

	if OS.get_name().to_lower() == "macos":
		expected.replace("Ctrl", "Command")

	var action := _handler.get_shortcut_action(shortcut)
	assert_that(str(action)).is_equal(expected)


## actually needs to comment out, it produces a lot of leaked instances
func _test__check_test_run_stopped_manually() -> void:
	var inspector :GdUnitCommandHandler = mock(GdUnitCommandHandler, CALL_REAL_FUNC)
	inspector._client_id = 1

	# simulate no test is running
	do_return(false).on(inspector).is_test_running_but_stop_pressed()
	inspector.check_test_run_stopped_manually()
	verify(inspector, 0).cmd_stop(any_int())

	# simulate the test runner was manually stopped by the editor
	do_return(true).on(inspector).is_test_running_but_stop_pressed()
	inspector.check_test_run_stopped_manually()
	verify(inspector, 1).cmd_stop(inspector._client_id)


func test_scan_test_directories() -> void:
	assert_array(GdUnitCommandHandler.scan_test_directories("res://", "test", [])).contains_exactly([
		"res://addons/gdUnit4/test"
	])
	# for root folders
	assert_array(GdUnitCommandHandler.scan_test_directories("res://", "", [])).contains_exactly([
		"res://addons", "res://assets", "res://gdUnit3-examples"
	])
	assert_array(GdUnitCommandHandler.scan_test_directories("res://", "/", [])).contains_exactly([
		"res://addons", "res://assets", "res://gdUnit3-examples"
	])
	assert_array(GdUnitCommandHandler.scan_test_directories("res://", "res://", [])).contains_exactly([
		"res://addons", "res://assets", "res://gdUnit3-examples"
	])
	# a test folder not exists
	assert_array(GdUnitCommandHandler.scan_test_directories("res://", "notest", [])).is_empty()


func test_scan_all_test_directories() -> void:
	var original_test_root_folder := GdUnitSettings.test_root_folder()
	var test_root_folder_property := GdUnitSettings.get_property(GdUnitSettings.TEST_LOOKUP_FOLDER)

	# Test when test_root_folder is blank
	test_root_folder_property.set_value("")
	GdUnitSettings.update_property(test_root_folder_property)
	assert_array(GdUnitCommandHandler.scan_all_test_directories()).contains_exactly(["res://"])

	# Test when test_root_folder is "/"
	test_root_folder_property.set_value("/")
	GdUnitSettings.update_property(test_root_folder_property)
	assert_array(GdUnitCommandHandler.scan_all_test_directories()).contains_exactly(["res://"])

	# Test when test_root_folder is "res://"
	test_root_folder_property.set_value("res://")
	GdUnitSettings.update_property(test_root_folder_property)
	assert_array(GdUnitCommandHandler.scan_all_test_directories()).contains_exactly(["res://"])

	# Test when test_root_folder is set to a specific folder
	test_root_folder_property.set_value("test")
	GdUnitSettings.update_property(test_root_folder_property)
	assert_array(GdUnitCommandHandler.scan_all_test_directories()).contains_exactly(["res://addons/gdUnit4/test"])

	# Test when test_root_folder is set to something which doesn't exist
	test_root_folder_property.set_value("notest")
	GdUnitSettings.update_property(test_root_folder_property)
	assert_array(GdUnitCommandHandler.scan_all_test_directories()).is_empty()

	# Restore the original test_root_folder
	test_root_folder_property.set_value(original_test_root_folder)
	GdUnitSettings.update_property(test_root_folder_property)
