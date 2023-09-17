## The test case main execution stage.[br]
class_name GdUnitTestCaseExecutionStage
extends IGdUnitExecutionStage


var _stage_test_before :IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new()
var _stage_test_after :IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new()
var _stage_single_test :IGdUnitExecutionStage = GdUnitTestCaseSingleExecutionStage.new()
var _stage_paramaterized_test :IGdUnitExecutionStage = GdUnitTestCaseParameterizedExecutionStage.new()
var _stage_fuzzer_test :IGdUnitExecutionStage = null


## Executes a single test case 'test_<name>()'.[br]
## It executes synchronized following stages[br]
##  -> test_before() [br]
##  -> test_case() [br]
##  -> test_after() [br]
func execute(context :GdUnitExecutionContext) -> void:
	await _stage_test_before.execute(context)
	await _stage_test_case(GdUnitExecutionContext.of_test(context))
	await _stage_test_after.execute(context)


func _stage_test_case(context :GdUnitExecutionContext):
	if context.test_case().is_parameterized():
		await _stage_paramaterized_test.execute(context)
	elif context.test_case().has_fuzzer():
		await _stage_fuzzer_test.execute(context)
	else:
		await _stage_single_test.execute(context)
	context = null
