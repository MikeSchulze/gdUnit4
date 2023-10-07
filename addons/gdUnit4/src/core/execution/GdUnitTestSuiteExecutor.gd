## The executor to run a test-suite
class_name GdUnitTestSuiteExecutor

var _executeStage :IGdUnitExecutionStage = GdUnitTestSuiteExecutionStage.new()


func execute(test_suite :GdUnitTestSuite) -> void:
	var orphan_detection_enabled = GdUnitSettings.is_verbose_orphans()
	if not orphan_detection_enabled:
		prints("!!! Reporting orphan nodes is disabled. Please check GdUnit settings.")
	
	Engine.get_main_loop().root.add_child(test_suite)
	
	GdUnitThreadManager.get_current_context().init()
	await _executeStage.execute(GdUnitExecutionContext.of_test_suite(test_suite))
	GdUnitThreadManager.get_current_context().clear()
