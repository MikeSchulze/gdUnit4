
# GdUnit generated TestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/command/GdUnitCommandHandler.gd'


var _handler := GdUnitCommandHandler.instance()


@warning_ignore('unused_parameter')
func test_create_shortcuts_defaults(shortcut :GdUnitShortcut.ShortCut, expected :String, test_parameters := [
	[GdUnitShortcut.ShortCut.RUN_TESTS_OVERALL, "GdUnitShortcutAction: RUN_TESTS_OVERALL (Ctrl+F7) -> Debug Overall TestSuites"],
	[GdUnitShortcut.ShortCut.RERUN_TESTS, "GdUnitShortcutAction: RERUN_TESTS (Ctrl+F5) -> Run TestSuites"],
	[GdUnitShortcut.ShortCut.RERUN_TESTS_DEBUG, "GdUnitShortcutAction: RERUN_TESTS_DEBUG (Ctrl+F6) -> Debug TestSuites"],
	[GdUnitShortcut.ShortCut.STOP_TEST_RUN, "GdUnitShortcutAction: STOP_TEST_RUN (Ctrl+F8) -> Stop Test Run"],
	[GdUnitShortcut.ShortCut.CREATE_TEST, "GdUnitShortcutAction: CREATE_TEST (Ctrl+F10) -> Create TestCase"],]) -> void:
	
	var action := _handler.get_shortcut_action(shortcut)
	assert_that(str(action)).is_equal(expected)

