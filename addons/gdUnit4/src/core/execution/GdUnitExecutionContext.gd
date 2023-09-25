class_name GdUnitExecutionContext

var _sub_context :Array[GdUnitExecutionContext] = []
var _orphan_monitor :GdUnitOrphanNodesMonitor
var _memory_observer := GdUnitMemoryObserver.new()
var _report_collector := GdUnitTestReportCollector.new()
var _thead_context :GdUnitThreadContext = null
var _time = LocalTime.now()
var _test_suite :GdUnitTestSuite = null
var _test_case: _TestCase = null


func _init(name :String, test_suite :GdUnitTestSuite, pe :GdUnitExecutionContext = null) -> void:
	assert(test_suite, "test_suite is null")
	_orphan_monitor = GdUnitOrphanNodesMonitor.new(name)
	_orphan_monitor.start()
	_thead_context = GdUnitThreadManager.get_current_context()
	_test_suite = test_suite
	set_active_execution_context(self)
	if pe != null:
		pe._sub_context.append(self)


static func of_test_suite(test_suite :GdUnitTestSuite) -> GdUnitExecutionContext:
	return GdUnitExecutionContext.new("(+) test-suite", test_suite)


static func of_test_case(pe :GdUnitExecutionContext, test_case :_TestCase) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(" |--> test-case", pe.test_suite(), pe)
	context._test_case = test_case
	return context


static func of_test(pe :GdUnitExecutionContext) -> GdUnitExecutionContext:
	var context :=  GdUnitExecutionContext.new("   |--> %s()" % pe.test_case().get_name(), pe.test_suite(), pe)
	context._test_case = pe.test_case()
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


func orphan_monitor_start() -> void:
	_orphan_monitor.start()


func orphan_monitor_stop() -> void:
	_orphan_monitor.stop()


func calculate_orphan_nodes() -> int:
	var child_orphans := _calculate_orpans_from_sub_contexts()
	return _orphan_monitor.orphan_nodes() - child_orphans


func _calculate_orpans_from_sub_contexts() -> int:
	var orphans := 0
	for c in _sub_context:
		orphans += c.orphan_nodes()
	prints("_calculate_orpans_from_sub_contexts", orphans)
	return orphans


func orphan_nodes() -> int:
	return _orphan_monitor.orphan_nodes()


func reports() -> Array[GdUnitReport]:
	return _report_collector.reports()


func build_report_statistics() -> Dictionary:
	return {}


func register_auto_free(obj :Variant) -> Variant:
	return _memory_observer.register_auto_free(obj)


## Runs the gdunit garbage collector to free registered object
func gc() -> void:
	await _memory_observer.gc()
