## The test case execution stage.[br]
class_name GdUnitTestCaseExecutionStage
extends IGdUnitExecutionStage


var _stage_single_test :IGdUnitExecutionStage = GdUnitTestCaseSingleExecutionStage.new()
var _stage_fuzzer_test :IGdUnitExecutionStage = GdUnitTestCaseFuzzedExecutionStage.new()
var _stage_parameterized_test :IGdUnitExecutionStage= GdUnitTestCaseParameterizedExecutionStage.new()


## Executes the test case 'test_<name>()'.[br]
## It executes synchronized following stages[br]
##  -> test_before() [br]
##  -> test_case() [br]
##  -> test_after() [br]
@warning_ignore("redundant_await")
func _execute(context :GdUnitExecutionContext) -> void:
	var test_case := context.test_case
	var test_suite := context.test_suite


	fire_event(GdUnitEvent.new()\
		.test_before(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name()))
	if test_case.is_parameterized():
		await _stage_parameterized_test.execute(context)
	elif test_case.is_fuzzed():
		await _stage_fuzzer_test.execute(context)
	else:
		await _stage_single_test.execute(context)

	context.build_statistics()

	if context.test_case.is_skipped():
		fire_test_skipped(context)
	else:
		var reports := context.collect_reports()
		var orphans := context.collect_orphans(reports)
		fire_event(GdUnitEvent.new()\
			.test_after(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name(), context.build_report_statistics(orphans), reports))


	# finally free the test instance
	if is_instance_valid(context.test_case):
		context.test_case.dispose()


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



func set_debug_mode(debug_mode :bool = false) -> void:
	super.set_debug_mode(debug_mode)
	_stage_single_test.set_debug_mode(debug_mode)
	_stage_fuzzer_test.set_debug_mode(debug_mode)
	_stage_parameterized_test.set_debug_mode(debug_mode)
