## The test suite main execution stage.[br]
class_name GdUnitTestSuiteExecutionStage
extends IGdUnitExecutionStage

const GdUnitTools := preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")

static var _stage_before :IGdUnitExecutionStage = GdUnitTestSuiteBeforeStage.new()
static var _stage_after :IGdUnitExecutionStage = GdUnitTestSuiteAfterStage.new()
static var _stage_test_case :IGdUnitExecutionStage = GdUnitTestCaseExecutionStage.new()
static var _fail_fast := false


## Executes all tests of test suite.[br]
## It executes synchronized following stages[br]
##  -> before() [br]
##  -> run overall test cases [br]
##  -> after() [br]
func execute(context :GdUnitExecutionContext) -> void:
	await _stage_before.execute(context)
	for test_case in context.test_cases():
		print_verbose()
		await _stage_test_case.execute(GdUnitExecutionContext.of_test_case(context, test_case))
		# stop checked first error if fail fast enabled
		if _fail_fast and context.test_failed():
			break
		if test_case.is_interupted():
			# it needs to go this hard way to kill the outstanding yields of a test case when the test timed out
			# we delete the current test suite where is execute the current test case to kill the function state
			# and replace it by a clone without function state
			context._test_suite = await clone_test_suite(context.test_suite())
	print_verbose()
	await _stage_after.execute(context)


# clones a test suite and moves the test cases to new instance
func clone_test_suite(test_suite :GdUnitTestSuite) -> GdUnitTestSuite:
	dispose_timers(test_suite)
	var parent := test_suite.get_parent()
	var _test_suite = test_suite.duplicate()
	copy_properties(test_suite, _test_suite)
	for child in test_suite.get_children():
		copy_properties(child, _test_suite.find_child(child.get_name(), true, false))
	# finally free current test suite instance
	parent.remove_child(test_suite)
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

