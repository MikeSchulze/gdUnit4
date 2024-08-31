## The execution context
## It contains all the necessary information about the executed stage, such as memory observers, reports, orphan monitor
class_name GdUnitExecutionContext

var _parent_context :GdUnitExecutionContext
var _sub_context :Array[GdUnitExecutionContext] = []
var _orphan_monitor :GdUnitOrphanNodesMonitor
var _memory_observer :GdUnitMemoryObserver
var _report_collector :GdUnitTestReportCollector
var _timer :LocalTime
var _test_case_name: StringName
var _test_case_parameter_set: Array
var _name :String
var _test_execution_iteration: int = 0
var _flaky_test_check := GdUnitSettings.is_test_flaky_check_enabled()
var _flaky_test_retries := GdUnitSettings.get_flaky_max_retries()


var error_monitor : GodotGdErrorMonitor = null:
	set (value):
		error_monitor = value
	get:
		if _parent_context != null:
			return _parent_context.error_monitor
		return error_monitor


var test_suite : GdUnitTestSuite = null:
	set (value):
		test_suite = value
	get:
		if _parent_context != null:
			return _parent_context.test_suite
		return test_suite


var test_case : _TestCase = null:
	get:
		if _test_case_name.is_empty():
			return null
		return test_suite.find_child(_test_case_name, false, false)


func _init(name :String, parent_context :GdUnitExecutionContext = null) -> void:
	_name = name
	_parent_context = parent_context
	_timer = LocalTime.now()
	_orphan_monitor = GdUnitOrphanNodesMonitor.new(name)
	_orphan_monitor.start()
	_memory_observer = GdUnitMemoryObserver.new()
	error_monitor = GodotGdErrorMonitor.new()
	_report_collector = GdUnitTestReportCollector.new()
	if parent_context != null:
		parent_context._sub_context.append(self)


func dispose() -> void:
	_timer = null
	_orphan_monitor = null
	_report_collector = null
	_memory_observer = null
	_parent_context = null
	test_suite = null
	test_case = null
	for context in _sub_context:
		context.dispose()
	_sub_context.clear()


static func of_test_suite(test_suite_ :GdUnitTestSuite) -> GdUnitExecutionContext:
	assert(test_suite_, "test_suite is null")
	var context := GdUnitExecutionContext.new(test_suite_.get_name())
	context.test_suite = test_suite_
	return context


static func of_test_case(pe :GdUnitExecutionContext, test_case_name :StringName) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(test_case_name, pe)
	context._test_case_name = test_case_name
	return context


static func of_parameterized_test(pe :GdUnitExecutionContext, test_case_name: String, test_case_parameter_set: Array) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(pe._test_case_name, pe)
	context._test_case_name = test_case_name
	context._test_case_parameter_set = test_case_parameter_set
	return context


static func of(pe :GdUnitExecutionContext) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(pe._test_case_name, pe)
	context._test_case_name = pe._test_case_name
	return context


func error_monitor_start() -> void:
	error_monitor.start()


func error_monitor_stop() -> void:
	await error_monitor.scan()
	for error_report in error_monitor.to_reports():
		if error_report.is_error():
			_report_collector.push_back(error_report)


func orphan_monitor_start() -> void:
	_orphan_monitor.start()


func orphan_monitor_stop() -> void:
	_orphan_monitor.stop()


func add_report(report: GdUnitReport) -> void:
	_report_collector.push_back(report)


func reports() -> Array[GdUnitReport]:
	return _report_collector.reports()


func collect_reports() -> Array[GdUnitReport]:
	var reports := reports()
	if test_case.is_interupted() and not test_case.is_expect_interupted() and test_case.report() != null:
		reports.push_back(test_case.report())
	# we combine the reports of test_before(), test_after() and test() to be reported by `fire_test_ended`
	for sub_context in _sub_context:
		reports.append_array(sub_context.reports())
		# needs finally to clean the test reports to avoid counting twice
		sub_context.reports().clear()
	return reports


func collect_orphans(reports :Array[GdUnitReport]) -> int:
	var orphans := 0
	if not _sub_context.is_empty():
		orphans += add_orphan_report_test(_sub_context[0], reports)
	orphans += add_orphan_report_teststage(reports)
	return orphans


func add_orphan_report_test(context :GdUnitExecutionContext, reports :Array[GdUnitReport]) -> int:
	var orphans := context.count_orphans()
	if orphans > 0:
		reports.push_front(GdUnitReport.new()\
			.create(GdUnitReport.WARN, context.test_case.line_number(), GdAssertMessages.orphan_detected_on_test(orphans)))
	return orphans


func add_orphan_report_teststage( reports :Array[GdUnitReport]) -> int:
	var orphans := count_orphans()
	if orphans > 0:
		reports.push_front(GdUnitReport.new()\
			.create(GdUnitReport.WARN, test_case.line_number(), GdAssertMessages.orphan_detected_on_test_setup(orphans)))
	return orphans



var calculated := false
var _is_success: bool

func build_statistics() -> void:

	_is_success = is_success()
	var is_flaky := is_flaky()
	var has_errors := has_errors()
	var has_warnings := has_warnings()
	#prints()
	#prints("test_case", test_case.name, _test_execution_iteration)
	#prints("is_success", _is_success)
	#prints("is_flaky", is_flaky)
	#prints("has_errors", has_errors)
	#prints("has_warnings", has_warnings)
	calculated = true



func build_report_statistics(orphans :int, recursive := true) -> Dictionary:

	return {
		GdUnitEvent.RETRY_COUNT: _test_execution_iteration,
		GdUnitEvent.ORPHAN_NODES: orphans,
		GdUnitEvent.ELAPSED_TIME: _timer.elapsed_since_ms(),
		GdUnitEvent.FAILED: !_is_success,
		GdUnitEvent.ERRORS: has_errors(),
		GdUnitEvent.WARNINGS: has_warnings(),
		GdUnitEvent.FLAKY: is_flaky(),
		GdUnitEvent.SKIPPED: has_skipped(),
		GdUnitEvent.FAILED_COUNT: 0 if _is_success else count_failures(recursive),
		GdUnitEvent.ERROR_COUNT: count_errors(recursive),
		GdUnitEvent.SKIPPED_COUNT: count_skipped(recursive)
	}


func has_failures() -> bool:
	return (
		#_sub_context.any(func(c :GdUnitExecutionContext) -> bool: return c.has_failures())
		_report_collector.has_failures()
	)


func has_errors() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool: return c.has_errors())
		or _report_collector.has_errors()
	)


func has_warnings() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool: return c.has_warnings())
		or _report_collector.has_warnings()
	)


func is_flaky() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool: return c.is_flaky())
		or _test_execution_iteration > 1
	)


func is_success() -> bool:
	if _sub_context.is_empty():
		return not has_failures()

	var failed_context := _sub_context.filter(func(c :GdUnitExecutionContext) -> bool:
			return !c._is_success if c.calculated else !c.is_success())
	var sub_context_has_faild := failed_context.is_empty() or failed_context.size() < _test_execution_iteration
	return sub_context_has_faild and not has_failures()


func has_skipped() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool: return c.has_skipped())
		or _report_collector.has_skipped()
	)


func count_failures(recursive :bool) -> int:
	if not recursive:
		return _report_collector.count_failures()
	return _sub_context\
		.map(func(c :GdUnitExecutionContext) -> int:
				return c.count_failures(recursive)).reduce(sum, _report_collector.count_failures())


func count_errors(recursive :bool) -> int:
	if not recursive:
		return _report_collector.count_errors()
	return _sub_context\
		.map(func(c :GdUnitExecutionContext) -> int:
				return c.count_errors(recursive)).reduce(sum, _report_collector.count_errors())


func count_skipped(recursive :bool) -> int:
	if not recursive:
		return _report_collector.count_skipped()
	return _sub_context\
		.map(func(c :GdUnitExecutionContext) -> int:
				return c.count_skipped(recursive)).reduce(sum, _report_collector.count_skipped())


func count_orphans() -> int:
	var orphans := 0
	for c in _sub_context:
		orphans += c._orphan_monitor.orphan_nodes()
	return _orphan_monitor.orphan_nodes() - orphans


func sum(accum :int, number :int) -> int:
	return accum + number


func retry_execution() -> bool:
	var retry :=  _test_execution_iteration < 1 if not _flaky_test_check else _test_execution_iteration < _flaky_test_retries
	if retry:
		_test_execution_iteration += 1
	return retry


func register_auto_free(obj :Variant) -> Variant:
	return _memory_observer.register_auto_free(obj)


## Runs the gdunit garbage collector to free registered object
func gc() -> void:
	await _memory_observer.gc()
	orphan_monitor_stop()
