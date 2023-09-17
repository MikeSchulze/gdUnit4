## The test case execution stage for paramaterized tests.[br]
class_name GdUnitTestCaseParameterizedExecutionStage
extends IGdUnitExecutionStage


## Executes a paramaterized test case.[br]
## It executes synchronized following stages[br]
##  -> test_case( <test_parameters> ) [br]
func execute(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite()
	var test_case := context.test_case()
	
	fire_event(GdUnitEvent.new()\
		.test_before(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name()))
	
	var test_case_parameters := test_case.test_parameters()
	var test_parameter_index := test_case.test_parameter_index()
	var test_case_names := test_case.test_case_names()
	for test_case_index in test_case.test_parameters().size():
		# is test_parameter_index is set, we run this parameterized test only
		if test_parameter_index != -1 and test_parameter_index != test_case_index:
			continue
		var parameters = test_case_parameters[test_case_index]
		await test_case.execute(parameters)
		if test_case.is_interupted():
			break
	
	fire_event(GdUnitEvent.new()\
		.test_after(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name(), context.build_report_statistics(), []))
	await context.dispose()
