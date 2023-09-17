## The test suite shutdown hook implementation.[br]
## It executes the 'after()' block from the test-suite.
class_name GdUnitTestSuiteAfterStage
extends IGdUnitExecutionStage


func execute(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite()
	
	await context.dispose()
	fire_event(GdUnitEvent.new().suite_after(test_suite.get_script().resource_path, test_suite.get_name(), context.build_report_statistics(), context.reports()))
	
	if is_instance_valid(test_suite):
		await Engine.get_main_loop().process_frame
		test_suite.free()
