class_name GdUnitExecutionContext

var _memory_observer := GdUnitMemoryObserver.new()
var _orphan_node_monitor :GdUnitOrphanNodesMonitor
var _report_collector := GdUnitTestReportCollector.new()
var _parent_execution_context :GdUnitExecutionContext
var _thead_context :GdUnitThreadContext = null
var _time = LocalTime.now()
var _test_suite :GdUnitTestSuite = null
var _test_case: _TestCase = null


func _init(name :String, thead_context :GdUnitThreadContext, parent_execution_context :GdUnitExecutionContext = null) -> void:
	assert(thead_context, "missing thread context")
	_parent_execution_context = parent_execution_context
	_orphan_node_monitor = GdUnitOrphanNodesMonitor.new(name, null if parent_execution_context == null else parent_execution_context._orphan_node_monitor)
	_thead_context = thead_context
	memory_monitor_start()


func dispose() -> void:
	await memory_monitor_stop()


static func of_test_suite(test_suite :GdUnitTestSuite, thead_context :GdUnitThreadContext) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new("(+) test-suite", thead_context)
	context._test_suite = test_suite
	return context


static func of_test_case(parent_context :GdUnitExecutionContext, test_case :_TestCase) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(" |--> test-case", parent_context._thead_context, parent_context)
	context._test_case = test_case
	return context


static func of_test(parent_context :GdUnitExecutionContext) -> GdUnitExecutionContext:
	return GdUnitExecutionContext.new("   |--> %s()" % parent_context.test_case().get_name(), parent_context._thead_context, parent_context)


func test_suite() -> GdUnitTestSuite:
	return _test_suite if _test_suite != null else _parent_execution_context.test_suite()


func test_case() -> _TestCase:
	return _test_case if _test_case != null else _parent_execution_context.test_case()


func test_cases() -> Array[_TestCase]:
	# needs assing to typed array as workaround see https://github.com/godotengine/godot/issues/72566
	var tests : Array[_TestCase]
	tests.assign(_test_suite.get_children().filter(func(e): return e is _TestCase))
	return tests


func test_failed() -> bool:
	# TODO handle failure detection
	return false


func memory_monitor_start() -> void:
	_orphan_node_monitor.start()


func memory_monitor_stop() -> void:
	await gc()
	_orphan_node_monitor.stop()


func reports() -> Array[GdUnitReport]:
	return _report_collector.reports()


func build_report_statistics() -> Dictionary:
	return {}


func register_auto_free(obj :Variant) -> Variant:
	return _memory_observer.register_auto_free(obj)


## Runs the gdunit garbage collector to free registered object
func gc() -> void:
	await _memory_observer.gc()
