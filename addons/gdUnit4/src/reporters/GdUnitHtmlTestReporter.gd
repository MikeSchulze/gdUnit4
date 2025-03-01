class_name GdUnitHtmlTestReporter
extends GdUnitTestReporter

var _report: GdUnitHtmlReport


func _init(report_dir: String, max_reports: int) -> void:
	_report = GdUnitHtmlReport.new(report_dir, max_reports)


func on_gdunit_event(event: GdUnitEvent) -> void:

	match event.type():
		GdUnitEvent.STOP:
			_report.delete_history()
		GdUnitEvent.TESTSUITE_BEFORE:
			_report.add_testsuite_report(event.resource_path(), event.suite_name(), event.total_count())
		GdUnitEvent.TESTSUITE_AFTER:
			_report.add_testsuite_reports(
				event.resource_path(),
				event.error_count(),
				event.failed_count(),
				event.orphan_nodes(),
				event.elapsed_time(),
				event.reports()
			)
		GdUnitEvent.TESTCASE_BEFORE:
			_report.add_testcase(event.resource_path(), event.suite_name(), event.test_name())
		GdUnitEvent.TESTCASE_AFTER:
			_report.set_testcase_counters(event.resource_path(),
				event.test_name(),
				event.is_error(),
				event.failed_count(),
				event.orphan_nodes(),
				event.is_skipped(),
				event.is_flaky(),
				event.elapsed_time())
			_report.add_testcase_reports(event.resource_path(), event.test_name(), event.reports())


func report_file() -> String:
	return _report.report_file()
