## The test case shutdown hook implementation.[br]
## It executes the 'test_after()' block from the test-suite.
class_name GdUnitTestCaseAfterStage
extends IGdUnitExecutionStage


var _call_stage :bool


func _init(call_stage := true) -> void:
	_call_stage = call_stage


func _execute(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite
	var test_case := context.test_case

	if _call_stage:
		@warning_ignore("redundant_await")
		await test_suite.after_test()
	# unreference last used assert form the test to prevent memory leaks
	GdUnitThreadManager.get_current_context().set_assert(null)
	await context.gc()
	await context.error_monitor_stop()


	context.build_statistics()

	if context.test_case.is_skipped():
		fire_test_skipped(context)
	else:
		var reports := context.collect_reports()
		var orphans := context.collect_orphans(reports)
		fire_event(GdUnitEvent.new()\
			.test_after(test_suite.get_script().resource_path, context.get_test_suite_name(), context.get_test_case_name(), context.build_report_statistics(orphans), reports))


func fire_test_skipped(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite
	var test_case := context.test_case
	var test_case_name := context._test_case_name
	var statistics := {
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
		.test_after(test_suite.get_script().resource_path, test_suite.get_name(), test_case_name, statistics, [report]))
