## The test case shutdown hook implementation.[br]
## It executes the 'test_after()' block from the test-suite.
class_name GdUnitTestCaseAfterStage
extends IGdUnitExecutionStage


var _call_stage :bool


func _init(call_stage := true) -> void:
	_call_stage = call_stage


func _execute(context :GdUnitExecutionContext) -> void:
	if _call_stage:
		@warning_ignore("redundant_await")
		await context.test_suite.after_test()
	# unreference last used assert form the test to prevent memory leaks
	GdUnitThreadManager.get_current_context().set_assert(null)
	await context.gc()
	await context.error_monitor_stop()
