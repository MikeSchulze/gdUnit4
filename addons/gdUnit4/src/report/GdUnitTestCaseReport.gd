class_name GdUnitTestCaseReport
extends GdUnitReportSummary

var _suite_name :String
var _failure_reports :Array[GdUnitReport]


@warning_ignore("shadowed_variable")
func _init(
		p_resource_path :String,
		p_suite_name :String,
		test_name :String,
		is_error := false,
		_is_failed := false,
		failed_count :int = 0,
		orphan_count :int = 0,
		is_skipped := false,
		is_flaky := false,
		failure_reports :Array[GdUnitReport] = [],
		p_duration :int = 0) -> void:
	_resource_path = p_resource_path
	_suite_name = p_suite_name
	_name = test_name
	_error_count = is_error
	_failure_count = failed_count
	_orphan_count = orphan_count
	_skipped_count = is_skipped
	_flaky_count = is_flaky
	_failure_reports = failure_reports
	_duration = p_duration


func suite_name() -> String:
	return _suite_name


func failure_report() -> String:
	var html_report := ""
	for report in get_test_reports():
		html_report += convert_rtf_to_html(str(report))
	return html_report


func create_record(_report_dir :String) -> String:
	return GdUnitHtmlPatterns.TABLE_RECORD_TESTCASE\
		.replace(GdUnitHtmlPatterns.REPORT_STATE, report_state())\
		.replace(GdUnitHtmlPatterns.TESTCASE_NAME, name())\
		.replace(GdUnitHtmlPatterns.SKIPPED_COUNT, str(skipped_count()))\
		.replace(GdUnitHtmlPatterns.ORPHAN_COUNT, str(orphan_count()))\
		.replace(GdUnitHtmlPatterns.DURATION, LocalTime.elapsed(_duration))\
		.replace(GdUnitHtmlPatterns.FAILURE_REPORT, failure_report())


func add_testcase_reports(reports: Array[GdUnitReport]) -> void:
	_failure_reports.append_array(reports)


func get_test_reports() -> Array[GdUnitReport]:
	return _failure_reports
