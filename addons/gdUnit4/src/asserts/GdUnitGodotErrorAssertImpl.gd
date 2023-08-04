class_name GdUnitGodotErrorAssertImpl
extends GdUnitGodotErrorAssert


const ErrorLogEntry = preload('res://addons/gdUnit4/src/monitor/ErrorLogEntry.gd')
var _gdunit_signals := GdUnitSignals.instance()

var _catched_failure_message :String = ""
var _is_godot_assert_failed := false
var _is_godot_push_warning := false
var _is_godot_push_error := false
var _monitor :GodotGdErrorMonitor


func _init(assertion :Callable):
	_monitor = GodotGdErrorMonitor.new(true)
	# execute the given code and monitor for runtime errors
	_monitor.start()
	assertion.call()
	_monitor.stop()


func _send_report(report :GdUnitReport)-> void:
	_gdunit_signals.gdunit_report.emit(report)


func _report_success() -> GdUnitAssert:
	GdAssertReports.set_last_error_line_number(-1)
	GdUnitSignals.instance().gdunit_set_test_failed.emit(false)
	return self


func _report_error(error_message :String, failure_line_number: int = -1) -> GdUnitAssert:
	var line_number := failure_line_number if failure_line_number != -1 else GdUnitAssertImpl._get_line_number()
	GdAssertReports.set_last_error_line_number(line_number)
	GdUnitSignals.instance().gdunit_set_test_failed.emit(true)
	_send_report(GdUnitReport.new().create(GdUnitReport.FAILURE, line_number, error_message))
	return self


func _has_log_entry(log_entries :Array[ErrorLogEntry], type :ErrorLogEntry.TYPE, error :String) -> bool:
	for entry in log_entries:
		if entry._type == type and entry._message == error:
			return true
	return false


func _to_list(log_entries :Array[ErrorLogEntry]) -> String:
	if log_entries.is_empty():
		return "no errors"
	var value := ""
	for entry in log_entries:
		value += "'%s'\n" % entry._message
	return value


func is_success() -> GdUnitGodotErrorAssert:
	var log_entries := await _monitor.scan()
	if log_entries.is_empty():
		return _report_success()
	return _report_error("""
		Expecting: no error's are ocured.
			but found: '%s'
		""".dedent().trim_prefix("\n") % _to_list(log_entries))


func is_runtime_error(expected_error :String) -> GdUnitGodotErrorAssert:
	var log_entries := await _monitor.scan()
	if _has_log_entry(log_entries, ErrorLogEntry.TYPE.SCRIPT_ERROR, expected_error):
		return _report_success()
	return _report_error("""
		Expecting: a runtime error is triggered.
			message: '%s'
			found: %s
		""".dedent().trim_prefix("\n") % [expected_error, _to_list(log_entries)])


func is_push_warning(expected_warning :String) -> GdUnitGodotErrorAssert:
	var log_entries := await _monitor.scan()
	if _has_log_entry(log_entries, ErrorLogEntry.TYPE.PUSH_WARNING, expected_warning):
		return _report_success()
	return _report_error("""
		Expecting: push_warning() is called.
			message: '%s'
			found: %s
		""".dedent().trim_prefix("\n") % [expected_warning, _to_list(log_entries)])


func is_push_error(expected_error :String) -> GdUnitGodotErrorAssert:
	var log_entries := await _monitor.scan()
	if _has_log_entry(log_entries, ErrorLogEntry.TYPE.PUSH_ERROR, expected_error):
		return _report_success()
	return _report_error("""
		Expecting: push_error() is called.
			message: '%s'
			found: %s
		""".dedent().trim_prefix("\n") % [expected_error, _to_list(log_entries)])
