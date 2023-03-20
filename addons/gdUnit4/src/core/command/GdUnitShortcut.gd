class_name GdUnitShortcut
extends RefCounted


enum ShortCut {
	RUN_TESTCASE,
	DEBUG_TESTCASE,
	RUN_TESTS_OVERALL,
	RERUN_TESTS,
	RERUN_TESTS_DEBUG,
	STOP_TEST_RUN,
	CREATE_TEST,
}


const CommandMapping = {
	ShortCut.RUN_TESTCASE: GdUnitCommandHandler.CMD_RUN_TESTCASE,
	ShortCut.DEBUG_TESTCASE: GdUnitCommandHandler.CMD_DEBUG_TESTCASE,
	ShortCut.RERUN_TESTS: GdUnitCommandHandler.CMD_RUN_TESTSUITE,
	ShortCut.RERUN_TESTS_DEBUG: GdUnitCommandHandler.CMD_DEBUG_TESTSUITE,
	ShortCut.RUN_TESTS_OVERALL: GdUnitCommandHandler.CMD_RUN_OVERALL,
	ShortCut.STOP_TEST_RUN: GdUnitCommandHandler.CMD_STOP_TEST_RUN,
	ShortCut.CREATE_TEST: GdUnitCommandHandler.CMD_CREATE_TESTCASE,
}


const DEFAULTS := {
	ShortCut.RUN_TESTCASE : [Key.KEY_ALT, Key.KEY_CTRL, Key.KEY_F5],
	ShortCut.DEBUG_TESTCASE : [Key.KEY_ALT, Key.KEY_CTRL, Key.KEY_F6],
	ShortCut.RERUN_TESTS : [Key.KEY_CTRL, Key.KEY_F5],
	ShortCut.RERUN_TESTS_DEBUG : [Key.KEY_CTRL, Key.KEY_F6],
	ShortCut.RUN_TESTS_OVERALL : [Key.KEY_CTRL, Key.KEY_F7],
	ShortCut.STOP_TEST_RUN : [Key.KEY_CTRL, Key.KEY_F8],
	ShortCut.CREATE_TEST : [Key.KEY_CTRL, Key.KEY_F10],
}
