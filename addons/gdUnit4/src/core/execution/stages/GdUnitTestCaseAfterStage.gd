## The test case shutdown hook implementation.[br]
## It executes the 'test_after()' block from the test-suite.
class_name GdUnitTestCaseAfterStage
extends IGdUnitExecutionStage


func execute(context :GdUnitExecutionContext) -> void:
	await context.dispose()
	
	if context.test_case().is_skipped():
		fire_test_skipped(context)
	else:
		fire_test_ended(context)
	
	if is_instance_valid(context.test_case()):
		context.test_case().dispose()


func fire_test_ended(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite()
	var test_case := context.test_case()
	fire_event(GdUnitEvent.new()\
		.test_after(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name(), context.build_report_statistics(), context.reports()))

func fire_test_skipped(context :GdUnitExecutionContext):
	var test_suite := context.test_suite()
	var test_case := context.test_case()
	var statistics = {
		GdUnitEvent.ORPHAN_NODES: 0,
		GdUnitEvent.ELAPSED_TIME: 0,
		GdUnitEvent.WARNINGS: false,
		GdUnitEvent.ERRORS: false,
		GdUnitEvent.ERROR_COUNT: 0,
		GdUnitEvent.FAILED: false,
		GdUnitEvent.FAILED_COUNT: 0,
		GdUnitEvent.SKIPPED: true,
		GdUnitEvent.SKIPPED_COUNT: 1,
	}
	var report := GdUnitReport.new().create(GdUnitReport.SKIPPED, test_case.line_number(), GdAssertMessages.test_skipped(test_case.skip_info()))
	fire_event(GdUnitEvent.new()\
		.test_after(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name(), statistics, [report]))
