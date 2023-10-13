## The execution context
## It contains all the necessary information about the executed stage, such as memory observers, reports, orphan monitor
class_name GdUnitExecutionContext

var _sub_context :Array[GdUnitExecutionContext] = []
var _orphan_monitor :GdUnitOrphanNodesMonitor
var _memory_observer := GdUnitMemoryObserver.new()
var _report_collector :GdUnitTestReportCollector
var _timer := LocalTime.now()
var _test_suite :GdUnitTestSuite = null
var _test_case: _TestCase = null


func _init(name :String, test_suite_ :GdUnitTestSuite, pe :GdUnitExecutionContext = null) -> void:
	assert(test_suite_, "test_suite is null")
	_orphan_monitor = GdUnitOrphanNodesMonitor.new(name)
	_orphan_monitor.start()
	_report_collector = GdUnitTestReportCollector.new(get_instance_id())
	_test_suite = test_suite_
	if pe != null:
		_test_case = pe.test_case()
	set_active()
	if pe != null:
		pe._sub_context.append(self)


func dispose() -> void:
	_sub_context.clear()
	_orphan_monitor = null
	_memory_observer = null
	_report_collector = null
	if is_instance_valid(_test_suite):
		await Engine.get_main_loop().process_frame
		_test_suite.free()
		_test_suite = null
	_test_case = null
	for context in _sub_context:
		context.dispose()
	_sub_context.clear()


func set_active() -> void:
	_test_suite.__execution_context = self
	GdUnitThreadManager.get_current_context().set_execution_context(self)


static func of_test_suite(test_suite_ :GdUnitTestSuite) -> GdUnitExecutionContext:
	return GdUnitExecutionContext.new(test_suite_.get_name(), test_suite_)


static func of_test_case(pe :GdUnitExecutionContext, test_case_ :_TestCase) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(test_case_.get_name(), pe.test_suite(), pe)
	context._test_case = test_case_
	return context


static func of(pe :GdUnitExecutionContext) -> GdUnitExecutionContext:
	return GdUnitExecutionContext.new(pe.test_case().get_name(), pe.test_suite(), pe)


func test_suite() -> GdUnitTestSuite:
	return _test_suite


func test_case() -> _TestCase:
	return _test_case


func test_failed() -> bool:
	return has_failures() or has_errors()


func orphan_monitor_start() -> void:
	_orphan_monitor.start()


func orphan_monitor_stop() -> void:
	_orphan_monitor.stop()


func reports() -> Array[GdUnitReport]:
	return _report_collector.reports()


func build_report_statistics(orphans :int, recursive := true) -> Dictionary:
	return {
		GdUnitEvent.ORPHAN_NODES: orphans,
		GdUnitEvent.ELAPSED_TIME: _timer.elapsed_since_ms(),
		GdUnitEvent.FAILED: has_failures(),
		GdUnitEvent.ERRORS: has_errors(),
		GdUnitEvent.WARNINGS: has_warnings(),
		GdUnitEvent.SKIPPED: has_skipped(),
		GdUnitEvent.FAILED_COUNT: count_failures(recursive),
		GdUnitEvent.ERROR_COUNT: count_errors(recursive),
		GdUnitEvent.SKIPPED_COUNT: count_skipped(recursive)
	}


func has_failures() -> bool:
	return _sub_context.any(func(c): return c.has_failures()) or _report_collector.has_failures()


func has_errors() -> bool:
	return _sub_context.any(func(c): return c.has_errors()) or _report_collector.has_errors()


func has_warnings() -> bool:
	return _sub_context.any(func(c): return c.has_warnings()) or _report_collector.has_warnings()


func has_skipped() -> bool:
	return _sub_context.any(func(c): return c.has_skipped()) or _report_collector.has_skipped()


func count_failures(recursive :bool) -> int:
	if not recursive:
		return _report_collector.count_failures()
	return _sub_context\
		.map(func(c): return c.count_failures(recursive))\
		.reduce(sum, _report_collector.count_failures()) 


func count_errors(recursive :bool) -> int:
	if not recursive:
		return _report_collector.count_errors()
	return _sub_context\
		.map(func(c): return c.count_errors(recursive))\
		.reduce(sum, _report_collector.count_errors()) 


func count_skipped(recursive :bool) -> int:
	if not recursive:
		return _report_collector.count_skipped()
	return _sub_context\
		.map(func(c): return c.count_skipped(recursive))\
		.reduce(sum, _report_collector.count_skipped()) 


func count_orphans() -> int:
	var orphans := 0
	for c in _sub_context:
		orphans += c._orphan_monitor.orphan_nodes()
	return _orphan_monitor.orphan_nodes() - orphans


func sum(accum :int, number :int) -> int:
	return accum + number


func register_auto_free(obj :Variant) -> Variant:
	return _memory_observer.register_auto_free(obj)


## Runs the gdunit garbage collector to free registered object
func gc() -> void:
	await _memory_observer.gc()
	orphan_monitor_stop()
