## The test case execution stage.[br]
class_name GdUnitTestCaseSingleExecutionStage
extends IGdUnitExecutionStage


var _stage_before :IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new()
var _stage_after :IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new()
var _stage_test :IGdUnitExecutionStage = GdUnitTestCaseSingleTestStage.new()


func _execute(context :GdUnitExecutionContext) -> void:
	while context.retry_execution():
		await _stage_before.execute(context)
		if not context.test_case.is_skipped():
			await _stage_test.execute(GdUnitExecutionContext.of(context))
		await _stage_after.execute(context)
		if context.is_success() or context.test_case.is_skipped():
			break


func set_debug_mode(debug_mode :bool = false) -> void:
	super.set_debug_mode(debug_mode)
	_stage_before.set_debug_mode(debug_mode)
	_stage_after.set_debug_mode(debug_mode)
	_stage_test.set_debug_mode(debug_mode)
