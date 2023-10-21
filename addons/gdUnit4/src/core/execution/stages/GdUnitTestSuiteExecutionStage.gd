## The test suite main execution stage.[br]
class_name GdUnitTestSuiteExecutionStage
extends IGdUnitExecutionStage

const GdUnitTools := preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")

var _stage_before :IGdUnitExecutionStage = GdUnitTestSuiteBeforeStage.new()
var _stage_after :IGdUnitExecutionStage = GdUnitTestSuiteAfterStage.new()
var _stage_test :IGdUnitExecutionStage = GdUnitTestCaseExecutionStage.new()
var _fail_fast := false


## Executes all tests of an test suite.[br]
## It executes synchronized following stages[br]
##  -> before() [br]
##  -> run all test cases [br]
##  -> after() [br]
func _execute(context :GdUnitExecutionContext) -> void:
	if context.test_suite().__is_skipped:
		await fire_test_suite_skipped(context)
		await context.dispose()
		return
	
	await _stage_before.execute(context)
	for test_case_index in context.test_suite().get_child_count():
		# only iterate over test cases
		var test_case := context.test_suite().get_child(test_case_index) as _TestCase
		if not is_instance_valid(test_case):
			continue
		
		context.test_suite().set_active_test_case(test_case.get_name())
		await _stage_test.execute(GdUnitExecutionContext.of_test_case(context, test_case))
		# stop checked first error if fail fast enabled
		if _fail_fast and context.test_failed():
			break
		if test_case.is_interupted():
			# it needs to go this hard way to kill the outstanding yields of a test case when the test timed out
			# we delete the current test suite where is execute the current test case to kill the function state
			# and replace it by a clone without function state
			await Engine.get_main_loop().process_frame
			context._test_suite = await clone_test_suite(context.test_suite())
	await _stage_after.execute(context)
	await context.dispose()


# clones a test suite and moves the test cases to new instance
func clone_test_suite(test_suite :GdUnitTestSuite) -> GdUnitTestSuite:
	dispose_timers(test_suite)
	var parent := test_suite.get_parent()
	var _test_suite = test_suite.duplicate()
	parent.remove_child(test_suite)
	copy_properties(test_suite, _test_suite)
	for child in test_suite.get_children():
		copy_properties(child, _test_suite.find_child(child.get_name(), true, false))
	# finally free current test suite instance
	test_suite.free()
	await Engine.get_main_loop().process_frame
	parent.add_child(_test_suite)
	return _test_suite


func dispose_timers(test_suite :GdUnitTestSuite):
	GdUnitTools.release_timers()
	for child in test_suite.get_children():
		if child is Timer:
			child.stop()
			test_suite.remove_child(child)
			child.free()


func copy_properties(source :Object, target :Object):
	if not source is _TestCase and not source is GdUnitTestSuite:
		return
	for property in source.get_property_list():
		var property_name = property["name"]
		target.set(property_name, source.get(property_name))


func fire_test_suite_skipped(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite()
	var skip_count := test_suite.get_child_count()
	fire_event(GdUnitEvent.new()\
		.suite_before(test_suite.get_script().resource_path, test_suite.get_name(), skip_count))
	var statistics = {
		GdUnitEvent.ORPHAN_NODES: 0,
		GdUnitEvent.ELAPSED_TIME: 0,
		GdUnitEvent.WARNINGS: false,
		GdUnitEvent.ERRORS: false,
		GdUnitEvent.ERROR_COUNT: 0,
		GdUnitEvent.FAILED: false,
		GdUnitEvent.FAILED_COUNT: 0,
		GdUnitEvent.SKIPPED_COUNT: skip_count,
		GdUnitEvent.SKIPPED: true
	}
	var report := GdUnitReport.new().create(GdUnitReport.SKIPPED, -1, GdAssertMessages.test_suite_skipped(test_suite.__skip_reason, skip_count))
	fire_event(GdUnitEvent.new().suite_after(test_suite.get_script().resource_path, test_suite.get_name(), statistics, [report]))
	await Engine.get_main_loop().process_frame


func set_debug_mode(debug_mode :bool = false):
	super.set_debug_mode(debug_mode)
	_stage_before.set_debug_mode(debug_mode)
	_stage_after.set_debug_mode(debug_mode)
	_stage_test.set_debug_mode(debug_mode)


func fail_fast(enabled :bool) -> void:
	_fail_fast = enabled
