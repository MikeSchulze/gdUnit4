## The test case execution stage.[br]
class_name GdUnitTestCaseSingleExecutionStage
extends IGdUnitExecutionStage


## Executes a single test case 'test_<name>()'.[br]
## It executes synchronized following stages[br]
##  -> test_case() [br]
func execute(context :GdUnitExecutionContext) -> void:
	print_verbose("-> test: %s" % context.test_case().get_name())
	await context.test_case().execute()
	await context.gc()
	context.orphan_monitor_stop()
	print_verbose("orphans detected: ", context.calculate_orphan_nodes())
