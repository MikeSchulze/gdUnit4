## The executor to run a test-suite
class_name GdUnitTestSuiteExecutor
extends RefCounted


func execute(test_suite :GdUnitTestSuite) -> void:
	# adds the test suite to the main tree
	await Engine.get_main_loop().process_frame
	Engine.get_main_loop().root.add_child(test_suite)
	await GdUnitTestSuiteExecutionStage.new().execute(GdUnitExecutionContext.of_test_suite(test_suite, GdUnitThreadManager.get_current_context()))
