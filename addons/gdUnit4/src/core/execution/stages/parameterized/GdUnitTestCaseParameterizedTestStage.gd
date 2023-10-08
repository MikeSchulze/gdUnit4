## The parameterized test case execution stage.[br]
class_name GdUnitTestCaseParamaterizedTestStage
extends IGdUnitExecutionStage


var _stage_before :IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new()
var _stage_after :IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new()


## Executes a paramaterized test case.[br]
## It executes synchronized following stages[br]
##  -> test_case( <test_parameters> ) [br]
func _execute(context :GdUnitExecutionContext) -> void:
	var test_case := context.test_case()
	var test_case_parameters := test_case.test_parameters()
	var test_parameter_index := test_case.test_parameter_index()
	var test_case_names := test_case.test_case_names()
	
	for test_case_index in test_case.test_parameters().size():
		# is test_parameter_index is set, we run this parameterized test only
		if test_parameter_index != -1 and test_parameter_index != test_case_index:
			continue
		
		_stage_before.set_test_name(test_case_names[test_case_index])
		_stage_after.set_test_name(test_case_names[test_case_index])
		
		await _stage_before.execute(context)
		await test_case.execute_paramaterized(test_case_parameters[test_case_index])
		await _stage_after.execute(context)
		context.reports().clear()
		if test_case.is_interupted():
			break
	await context.gc()


func set_debug_mode(debug_mode :bool = false):
	super.set_debug_mode(debug_mode)
	_stage_before.set_debug_mode(debug_mode)
	_stage_after.set_debug_mode(debug_mode)
