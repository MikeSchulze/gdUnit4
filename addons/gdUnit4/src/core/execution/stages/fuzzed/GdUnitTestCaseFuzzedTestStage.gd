## The fuzzed test case execution stage.[br]
class_name GdUnitTestCaseFuzzedTestStage
extends IGdUnitExecutionStage


var _expression_runner := GdUnitExpressionRunner.new()


## Executes a test case with given fuzzers 'test_<name>(<fuzzer>)' iterative.[br]
## It executes synchronized following stages[br]
##  -> test_case() [br]
func _execute(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite()
	var test_case := context.test_case()
	var fuzzers := create_fuzzers(test_suite, test_case)
	
	for iteration in test_case.iterations():
		@warning_ignore("redundant_await")
		await test_suite.before_test()
		await test_case.execute(fuzzers, iteration)
		@warning_ignore("redundant_await")
		await test_suite.after_test()
		if test_case.is_interupted():
			break
		# interrupt at first failure
		var reports := context.reports()
		if not context.reports().is_empty():
			var report :GdUnitReport = reports.pop_front()
			reports.append(GdUnitReport.new() \
				.create(GdUnitReport.FAILURE, report.line_number(), GdAssertMessages.fuzzer_interuped(iteration, report.message())))
			break


func create_fuzzers(test_suite :GdUnitTestSuite, test_case :_TestCase) -> Array[Fuzzer]:
	if not test_case.is_fuzzed():
		return Array()
	test_case.generate_seed()
	var fuzzers :Array[Fuzzer] = []
	for fuzzer_arg in test_case.fuzzer_arguments():
		var fuzzer := _expression_runner.to_fuzzer(test_suite.get_script(), fuzzer_arg.value_as_string())
		fuzzer._iteration_index = 0
		fuzzer._iteration_limit = test_case.iterations()
		fuzzers.append(fuzzer)
	return fuzzers
