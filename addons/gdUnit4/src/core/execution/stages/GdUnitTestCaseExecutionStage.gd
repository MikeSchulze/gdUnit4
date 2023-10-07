## The test case execution stage.[br]
class_name GdUnitTestCaseExecutionStage
extends IGdUnitExecutionStage


var _stage_single_test :IGdUnitExecutionStage = GdUnitTestCaseSingleExecutionStage.new()
var _stage_fuzzer_test :IGdUnitExecutionStage = GdUnitTestCaseFuzzedExecutionStage.new()
var _stage_parameterized_test :IGdUnitExecutionStage= GdUnitTestCaseParameterizedExecutionStage.new()


## Executes a single test case 'test_<name>()'.[br]
## It executes synchronized following stages[br]
##  -> test_before() [br]
##  -> test_case() [br]
##  -> test_after() [br]
@warning_ignore("redundant_await")
func _execute(context :GdUnitExecutionContext) -> void:
	var test_case := context.test_case()
	if test_case.is_parameterized():
		await _stage_parameterized_test.execute(context)
	elif test_case.is_fuzzed():
		await _stage_fuzzer_test.execute(context)
	else:
		await _stage_single_test.execute(context)
