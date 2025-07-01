class_name GdUnitHtmlReporterTestSessionHook
extends GdUnitTestSessionHook

var _html_reporter: GdUnitHtmlTestReporter

func _init(report_dir: String, max_reports: int) -> void:
	priority = -100
	_html_reporter = GdUnitHtmlTestReporter.new(report_dir, max_reports)


func startup(session: GdUnitTestSession) -> GdUnitResult:
	session.test_event.connect(_on_test_event.bind(session))
	return GdUnitResult.success()


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	session.send_message("Open HTML Report at: file://%s" % _html_reporter.report_file())

	# TODO move to `GdUnitJUnitReporterTestSessionHook`
	JUnitXmlReport.new(_html_reporter._report._report_path, _html_reporter._report.iteration()).write(_html_reporter._report)
	return GdUnitResult.success()


func _on_test_event(test_event: GdUnitEvent, session: GdUnitTestSession) -> void:
	_html_reporter.on_gdunit_event(test_event, session)
