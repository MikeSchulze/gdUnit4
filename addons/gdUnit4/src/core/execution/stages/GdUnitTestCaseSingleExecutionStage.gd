## The test case execution stage.[br]
class_name GdUnitTestCaseSingleExecutionStage
extends IGdUnitExecutionStage


## Executes a single test case 'test_<name>()'.[br]
## It executes synchronized following stages[br]
##  -> test_case() [br]
func execute(context :GdUnitExecutionContext) -> void:
	await context.test_case().execute()
	await context.dispose()
