class_name GdUnitShortcut
extends RefCounted


enum ShortCut {
	RUN_TESTCASE,
	RUN_TESTCASE_DEBUG,
	RUN_TESTS_OVERALL,
	RERUN_TESTS,
	RERUN_TESTS_DEBUG,
	STOP_TEST_RUN,
	CREATE_TEST,
}


const CommandMapping = {
	ShortCut.RUN_TESTCASE: GdUnitCommandHandler.CMD_RUN_TESTCASE,
	ShortCut.RUN_TESTCASE_DEBUG: GdUnitCommandHandler.CMD_RUN_TESTCASE_DEBUG,
	ShortCut.RERUN_TESTS: GdUnitCommandHandler.CMD_RERUN_TESTS,
	ShortCut.RERUN_TESTS_DEBUG: GdUnitCommandHandler.CMD_RERUN_TESTS_DEBUG,
	ShortCut.RUN_TESTS_OVERALL: GdUnitCommandHandler.CMD_RUN_OVERALL,
	ShortCut.STOP_TEST_RUN: GdUnitCommandHandler.CMD_STOP_TEST_RUN,
	ShortCut.CREATE_TEST: GdUnitCommandHandler.CMD_CREATE_TESTCASE,
}


const DEFAULTS := {
	ShortCut.RUN_TESTCASE : [Key.KEY_ALT, Key.KEY_CTRL, Key.KEY_F5],
	ShortCut.RUN_TESTCASE_DEBUG : [Key.KEY_ALT, Key.KEY_CTRL, Key.KEY_F6],
	ShortCut.RUN_TESTS_OVERALL : [Key.KEY_ALT, Key.KEY_F4],
	ShortCut.RERUN_TESTS : [Key.KEY_ALT, Key.KEY_F5],
	ShortCut.RERUN_TESTS_DEBUG : [Key.KEY_ALT, Key.KEY_F6],
	ShortCut.STOP_TEST_RUN : [Key.KEY_ALT, Key.KEY_F8],
	ShortCut.CREATE_TEST : [Key.KEY_ALT, Key.KEY_F10],
}
