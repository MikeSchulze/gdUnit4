## The test case execution stage.[br]
class_name GdUnitTestCaseSingleExecutionStage
extends IGdUnitExecutionStage


var _stage_before :IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new()
var _stage_after :IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new()
var _stage_test :IGdUnitExecutionStage = GdUnitTestCaseSingleTestStage.new()


func _execute(context :GdUnitExecutionContext) -> void:
	await _stage_before.execute(context)
	await _stage_test.execute(GdUnitExecutionContext.of_test(context))
	await _stage_after.execute(context)
