class_name GdUnitXMLReporterTestSessionHook
extends GdUnitTestSessionHook


var test_session: GdUnitTestSession:
	get:
		return test_session
	set(value):
		test_session = value
		test_session.test_event.connect(_on_test_event)


var _report_summary: GdUnitReportSummary
var _reporter: GdUnitTestReporter


func _init() -> void:
	super("GdUnitXMLTestReporter", "The JUnit XML test reporting hook.")
	_reporter = GdUnitTestReporter.new()


func startup(session: GdUnitTestSession) -> GdUnitResult:
	test_session = session
	_report_summary = GdUnitReportSummary.new()
	_reporter.init_summary()

	return GdUnitResult.success()


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	var report_path := JUnitXmlReport.new(session.report_path).write(_report_summary)
	session.send_message("Open XML Report at: file://{0}".format([report_path]))

	return GdUnitResult.success()


func _on_test_event(event: GdUnitEvent) -> void:
	match event.type():
		GdUnitEvent.TESTSUITE_BEFORE:
			_reporter.init_statistics()
			_report_summary.add_testsuite_report(event.resource_path(), event.suite_name(), event.total_count())
		GdUnitEvent.TESTSUITE_AFTER:
			var statistics := _reporter.build_test_suite_statisitcs(event)
			_report_summary.update_testsuite_counters(
				event.resource_path(),
				_reporter.error_count(statistics),
				_reporter.failed_count(statistics),
				_reporter.orphan_nodes(statistics),
				_reporter.skipped_count(statistics),
				_reporter.flaky_count(statistics),
				event.elapsed_time())
			_report_summary.add_testsuite_reports(
				event.resource_path(),
				event.reports()
			)
		GdUnitEvent.TESTCASE_BEFORE:
			var test := test_session.find_test_by_id(event.guid())
			_report_summary.add_testcase(test.source_file, test.suite_name, test.display_name)
		GdUnitEvent.TESTCASE_AFTER:
			_reporter.update_statistics(event)
			var test := test_session.find_test_by_id(event.guid())
			_report_summary.set_counters(test.source_file,
				test.display_name,
				event.error_count(),
				event.failed_count(),
				event.orphan_nodes(),
				event.is_skipped(),
				event.is_flaky(),
				event.elapsed_time())
			_report_summary.add_reports(test.source_file, test.display_name, event.reports())
