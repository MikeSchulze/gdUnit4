class_name GdUnitHtmlReporterTestSessionHook
extends GdUnitTestSessionHook

var _html_reporter: GdUnitHtmlTestReporter


var report_dir: String = GdUnitFileAccess.current_dir() + "reports":
	get:
		return report_dir
	set(value):
		report_dir = value
		_html_reporter._report.report_path = value


var report_max: int = 1:
	get:
		return report_max
	set(value):
		report_max = value
		_html_reporter._report.max_reports = value


func _init() -> void:
	super("GdUnitHtmlTestReporter", "The test result Html reporting hook.")
	_html_reporter = GdUnitHtmlTestReporter.new(report_dir, report_max)


func startup(session: GdUnitTestSession) -> GdUnitResult:
	session.test_event.connect(_on_test_event.bind(session))
	return GdUnitResult.success()


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	session.send_message("Open HTML Report at: file://%s" % _html_reporter.report_file())

	# TODO move to `GdUnitJUnitReporterTestSessionHook`
	JUnitXmlReport.new(_html_reporter._report.report_path, _html_reporter._report.iteration()).write(_html_reporter._report)
	return GdUnitResult.success()


func _on_test_event(test_event: GdUnitEvent, session: GdUnitTestSession) -> void:
	_html_reporter.on_gdunit_event(test_event, session)
