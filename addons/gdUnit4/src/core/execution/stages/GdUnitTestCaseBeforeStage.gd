## The test case startup hook implementation.[br]
## It executes the 'test_before()' block from the test-suite.
class_name GdUnitTestCaseBeforeStage
extends IGdUnitExecutionStage


func execute(context :GdUnitExecutionContext) -> void:
	var test_suite := context.test_suite()
	var test_case := context.test_case()
	
	fire_event(GdUnitEvent.new()\
		.test_before(test_suite.get_script().resource_path, test_suite.get_name(), test_case.get_name()))
	
	print_verbose("-> before_test")
	@warning_ignore("redundant_await")
	await test_suite.before_test()
