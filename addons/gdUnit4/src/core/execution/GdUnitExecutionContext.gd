class_name GdUnitExecutionContext

var _orphan_node_monitor :GdUnitOrphanNodesMonitor
var _memory_observer := GdUnitMemoryObserver.new()
var _report_collector := GdUnitTestReportCollector.new()
var _thead_context :GdUnitThreadContext = null
var _time = LocalTime.now()
var _test_suite :GdUnitTestSuite = null
var _test_case: _TestCase = null


func _init(name :String, test_suite :GdUnitTestSuite, thead_context :GdUnitThreadContext) -> void:
	assert(test_suite, "test_suite is null")
	assert(thead_context, "thead_context is null")
	_orphan_node_monitor = GdUnitOrphanNodesMonitor.new(name)
	_thead_context = thead_context
	_test_suite = test_suite
	set_active_execution_context(self)


static func of_test_suite(test_suite :GdUnitTestSuite, thead_context :GdUnitThreadContext) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new("(+) test-suite", test_suite, thead_context)
	return context


static func of_test_case(parent_context :GdUnitExecutionContext, test_case :_TestCase) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(" |--> test-case", parent_context.test_suite(), parent_context._thead_context)
	context._test_case = test_case
	return context


static func of_test(parent_context :GdUnitExecutionContext) -> GdUnitExecutionContext:
	var context :=  GdUnitExecutionContext.new("   |--> %s()" % parent_context.test_case().get_name(), parent_context.test_suite(), parent_context._thead_context)
	context._test_case = parent_context.test_case()
	return context


static func set_active_execution_context(context :GdUnitExecutionContext):
	context.test_suite()._execution_context = context


func test_suite() -> GdUnitTestSuite:
	return _test_suite


func test_case() -> _TestCase:
	return _test_case


func test_cases() -> Array[_TestCase]:
	# needs assing to typed array as workaround see https://github.com/godotengine/godot/issues/72566
	var tests : Array[_TestCase]
	tests.assign(_test_suite.get_children().filter(func(e): return e is _TestCase))
	return tests


func test_failed() -> bool:
	# TODO handle failure detection
	return false


func orphan_monitor_start(reset := false) -> void:
	_orphan_node_monitor.start(reset)


func orphan_monitor_stop() -> void:
	_orphan_node_monitor.stop()


func orphan_nodes() -> int:
	return _orphan_node_monitor.orphan_nodes()


func reports() -> Array[GdUnitReport]:
	return _report_collector.reports()


func build_report_statistics() -> Dictionary:
	return {}


func register_auto_free(obj :Variant) -> Variant:
	return _memory_observer.register_auto_free(obj)


## Runs the gdunit garbage collector to free registered object
func gc() -> void:
	await _memory_observer.gc()
