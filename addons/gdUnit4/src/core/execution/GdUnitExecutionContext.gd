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
		if test_case != null:
			return test_case
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
		test_case = parent_context.test_case


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


static func of(pe :GdUnitExecutionContext, execution_iteration: int = 0) -> GdUnitExecutionContext:
	var context := GdUnitExecutionContext.new(pe._test_case_name, pe)
	context._test_case_name = pe._test_case_name
	context._test_execution_iteration = execution_iteration
	return context


func get_test_suite_name() -> String:
	return test_suite.get_name()


func get_test_case_name() -> String:
	if not _test_case_name.is_empty():
		return _test_case_name
	return test_case.get_name()


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


func collect_reports(recursive: bool) -> Array[GdUnitReport]:
	if not recursive:
		return reports()
	var current_reports := reports()
	# we combine the reports of test_before(), test_after() and test() to be reported by `fire_test_ended`
	for sub_context in _sub_context:
		current_reports.append_array(sub_context.reports())
		# needs finally to clean the test reports to avoid counting twice
		sub_context.reports().clear()
	return current_reports


func collect_orphans(p_reports :Array[GdUnitReport]) -> int:
	var orphans := 0
	if not _sub_context.is_empty():
		orphans += add_orphan_report_test(_sub_context[0], p_reports)
	orphans += add_orphan_report_teststage(p_reports)
	return orphans


func add_orphan_report_test(context :GdUnitExecutionContext, p_reports :Array[GdUnitReport]) -> int:
	var orphans := context.count_orphans()
	if orphans > 0:
		p_reports.push_front(GdUnitReport.new()\
			.create(GdUnitReport.WARN, context.test_case.line_number(), GdAssertMessages.orphan_detected_on_test(orphans)))
	return orphans


func add_orphan_report_teststage(p_reports :Array[GdUnitReport]) -> int:
	var orphans := count_orphans()
	if orphans > 0:
		p_reports.push_front(GdUnitReport.new()\
			.create(GdUnitReport.WARN, test_case.line_number(), GdAssertMessages.orphan_detected_on_test_setup(orphans)))
	return orphans



var calculated := false
var _is_success: bool
var _is_flaky: bool
var _is_skipped: bool
var _has_warnings: bool
var _has_failures: bool
var _has_errors: bool
var _failure_count := 0
var _orphan_count := 0
var _error_count := 0



func build_reports(recursive := true) -> Array[GdUnitReport]:
	var collected_reports: Array[GdUnitReport] = collect_reports(recursive)
	if recursive:
		_orphan_count = collect_orphans(collected_reports)
	else:
		_orphan_count = count_orphans()
		if _orphan_count > 0:
			collected_reports.push_front(GdUnitReport.new() \
				.create(GdUnitReport.WARN, 1, GdAssertMessages.orphan_detected_on_suite_setup(_orphan_count)))
	_is_skipped = is_skipped()
	_is_success = is_success()
	_is_flaky = is_flaky()
	_has_warnings = has_warnings()
	_has_errors = has_errors()
	_error_count = count_errors(recursive)
	if !_is_success:
		_has_failures = has_failures()
		_failure_count = count_failures(recursive)
	return collected_reports


func evaluate_test_retry_status() -> bool:
	# get last test retry status
	var last_test_status :GdUnitExecutionContext = _sub_context.back()
	_is_skipped = last_test_status.is_skipped()
	_is_success = last_test_status.is_success()
	# if we have more than one sub contexts the test was rerurn and marked as flaky
	_is_flaky = _is_success and _sub_context.size() > 1
	_has_warnings = last_test_status.has_warnings()
	_has_errors = last_test_status.has_errors()
	_error_count = last_test_status.count_errors(false)
	# we not report failures on success tests (could contain failures from retry tests before)
	if !_is_success:
		_has_failures = last_test_status.has_failures()
		_failure_count = last_test_status.count_failures(false)
	_orphan_count = last_test_status.collect_orphans(collect_reports(false))
	calculated = true
	# finally cleanup the retry sub executions
	_sub_context.clear()
	return _is_success


# Evaluates the actual test case status by validate the sub context contains a success state
# If more than one state available the test case is executed multipe times and marked as flaky
func evaluate_test_case_status() -> bool:
	if calculated:
		return _is_success
	_is_skipped = is_skipped()
	_is_success = is_success()
	_is_flaky = is_flaky()
	_has_warnings = has_warnings()
	_has_errors = has_errors()
	_error_count = count_errors(true)
	if !_is_success:
		_has_failures = has_failures()
		_failure_count = count_failures(true)
	_orphan_count = collect_orphans(collect_reports(false))
	calculated = true

	#prints(_test_case_name, "success" if _is_success else "failed", "	flaky:", _is_flaky, "	retries:", _test_execution_iteration, "_has_errors", _has_errors)
	#_sub_context.clear()
	return _is_success



func build_report_statistics(recursive := true) -> Dictionary:

	return {
		GdUnitEvent.RETRY_COUNT: _test_execution_iteration,
		GdUnitEvent.ORPHAN_NODES: _orphan_count,
		GdUnitEvent.ELAPSED_TIME: _timer.elapsed_since_ms(),
		GdUnitEvent.FAILED: !_is_success,
		GdUnitEvent.ERRORS: _has_errors,
		GdUnitEvent.WARNINGS: _has_warnings,
		GdUnitEvent.FLAKY: _is_flaky,
		GdUnitEvent.SKIPPED: _is_skipped,
		GdUnitEvent.FAILED_COUNT: _failure_count,
		GdUnitEvent.ERROR_COUNT: _error_count,
		GdUnitEvent.SKIPPED_COUNT: count_skipped(recursive)
	}


func has_failures() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool:
			return c._has_failures if c.calculated else c.has_failures())
		or _report_collector.has_failures()
	)


func has_errors() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool:
			return c._has_errors if c.calculated else c.has_errors())
		or _report_collector.has_errors()
	)


func has_warnings() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool: return c.has_warnings())
		or _report_collector.has_warnings()
	)


func is_flaky() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool:
			return c._is_flaky if c.calculated else c.is_flaky())
		or _test_execution_iteration > 1
	)


func is_success() -> bool:
	if not calculated:
		_is_success = evaluate_is_success()
		_is_flaky = is_flaky()
		_has_errors = has_errors()
		_has_failures = has_failures()
		calculated = true
	return _is_success


func is_skipped() -> bool:
	return (
		_sub_context.any(func(c :GdUnitExecutionContext) -> bool:
			return c._is_skipped if c.calculated else c.is_skipped())
		or test_case.is_skipped() if test_case != null else false
	)



func is_interupted() -> bool:
	if test_case != null:
		return test_case.is_interupted()
	return false


func evaluate_is_success() -> bool:
	if _sub_context.is_empty():
		return not has_failures()# and not has_errors()

	var failed_context := _sub_context.filter(func(c :GdUnitExecutionContext) -> bool:
			return !c.is_success())
	return failed_context.is_empty() and not has_failures()# and not has_errors()


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
