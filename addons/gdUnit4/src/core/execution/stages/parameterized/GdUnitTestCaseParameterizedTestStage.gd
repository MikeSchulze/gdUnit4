## The parameterized test case execution stage.[br]
class_name GdUnitTestCaseParamaterizedTestStage
extends IGdUnitExecutionStage


var _stage_before :IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new()
var _stage_after :IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new()


## Executes a parameterized test case.[br]
## It executes synchronized following stages[br]
##  -> test_case( <test_parameters> ) [br]
func _execute(context :GdUnitExecutionContext) -> void:
	var test_case := context.test_case
	var test_parameter_index := test_case.test_parameter_index()
	var is_fail := false
	var is_error := false
	var failing_index := 0
	var parameters :Array = []
	var test_names := test_case.test_case_names()
	for test_case_index in test_names.size():
		# is test_parameter_index is set, we run this parameterized test only
		if test_parameter_index != -1 and test_parameter_index != test_case_index:
			continue
		var test_case_name = test_names[test_case_index]
		_stage_before.set_test_name(test_case_name)
		_stage_after.set_test_name(test_case_name)
		
		var test_context := GdUnitExecutionContext.of(context)
		await _stage_before.execute(test_context)
		# we need to resolve initial the test parameters  after the `before_test` stage
		if parameters.is_empty():
			parameters = _resolve_test_parameters(context)
		if not test_case.is_interupted():
			await test_case.execute_paramaterized(parameters[test_case_index])
		await _stage_after.execute(test_context)
		# we need to clean up the reports here so they are not reported twice
		is_fail = is_fail or test_context.count_failures(false) > 0
		is_error = is_error or test_context.count_errors(false) > 0
		failing_index = test_case_index - 1
		test_context.reports().clear()
		if test_case.is_interupted():
			break
	# add report to parent execution context if failed or an error is found
	if is_fail:
		context.reports().append(GdUnitReport.new().create(GdUnitReport.FAILURE, test_case.line_number(), "Test failed at parameterized index %d." % failing_index))
	if is_error:
		context.reports().append(GdUnitReport.new().create(GdUnitReport.ABORT, test_case.line_number(), "Test aborted at parameterized index %d." % failing_index))
	await context.gc()


func _resolve_test_parameters(context :GdUnitExecutionContext) -> Array:
	var test_case := context.test_case
	var test_suite := context.test_suite
	# we need to exchange temporary for parameter resolving the execution context
	# this is necessary because of possible usage of `auto_free` and needs to run in the parent execution context 
	var save_execution_context :GdUnitExecutionContext = test_suite.__execution_context
	context.set_active()
	var parameters := GdTestParameterSet.extract_test_parameters(test_suite, test_case._fd)
	# restore the original execution context and restart the orphan monitor to get new instances into account
	save_execution_context.set_active()
	save_execution_context.orphan_monitor_start()
	
	var error := GdTestParameterSet.validate(test_case._fd.args(), parameters)
	if not error.is_empty():
		test_case.skip(true, error)
		test_case._interupted = true
	if parameters.size() != test_case.test_case_names().size():
		test_case._interupted = true
		push_error("Internal Error: The resolved test_case names has invalid size!")
		context.reports().append(GdUnitReport.new().create(GdUnitReport.FAILURE, test_case.line_number(),
		"""
		%s:
			The resolved test_case names has invalid size!
			%s
		""".dedent().trim_prefix("\n")
		% [GdAssertMessages._error("Internal Error"), GdAssertMessages._error("Please report this issue as a bug!")]))
	return parameters


func set_debug_mode(debug_mode :bool = false):
	super.set_debug_mode(debug_mode)
	_stage_before.set_debug_mode(debug_mode)
	_stage_after.set_debug_mode(debug_mode)
