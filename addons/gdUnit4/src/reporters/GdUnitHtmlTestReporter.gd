@tool
class_name GdUnitHtmlTestReporter
extends GdUnitTestReporter

var _report: GdUnitHtmlReport


func _init(session: GdUnitTestSession) -> void:
	_report = GdUnitHtmlReport.new(session.report_path)
	test_session = session


func on_gdunit_event(event: GdUnitEvent) -> void:
	match event.type():
		GdUnitEvent.INIT:
			init_summary()
		GdUnitEvent.STOP:
			_report.write()
		GdUnitEvent.TESTSUITE_BEFORE:
			init_statistics()
			_report.add_testsuite_report(event.resource_path(), event.suite_name(), event.total_count())
		GdUnitEvent.TESTSUITE_AFTER:
			var statistics := build_test_suite_statisitcs(event)
			_report.update_testsuite_counters(
				event.resource_path(),
				error_count(statistics),
				failed_count(statistics),
				orphan_nodes(statistics),
				skipped_count(statistics),
				flaky_count(statistics),
				event.elapsed_time())
			_report.add_testsuite_reports(
				event.resource_path(),
				event.reports()
			)
		GdUnitEvent.TESTCASE_BEFORE:
			var test := test_session.find_test_by_id(event.guid())
			_report.add_testcase(test.source_file, test.suite_name, test.display_name)
		GdUnitEvent.TESTCASE_AFTER:
			update_statistics(event)
			var test := test_session.find_test_by_id(event.guid())
			_report.set_counters(test.source_file,
				test.display_name,
				event.error_count(),
				event.failed_count(),
				event.orphan_nodes(),
				event.is_skipped(),
				event.is_flaky(),
				event.elapsed_time())
			_report.add_reports(test.source_file, test.display_name, event.reports())


func report_file() -> String:
	return _report.report_file()
