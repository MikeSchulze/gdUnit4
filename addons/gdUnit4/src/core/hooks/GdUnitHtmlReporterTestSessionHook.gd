class_name GdUnitHtmlReporterTestSessionHook
extends GdUnitTestSessionHook

var _html_reporter: GdUnitHtmlTestReporter

func _init() -> void:
	super("GdUnitHtmlTestReporter", "The test result Html reporting hook.")


func startup(session: GdUnitTestSession) -> GdUnitResult:
	_html_reporter = GdUnitHtmlTestReporter.new(session)
	session.test_event.connect(_on_test_event)
	return GdUnitResult.success()


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	session.send_message("Open HTML Report at: file://%s" % _html_reporter.report_file())

	# TODO move to `GdUnitJUnitReporterTestSessionHook`
	JUnitXmlReport.new(session.report_path).write(_html_reporter._report)
	return GdUnitResult.success()


func _on_test_event(test_event: GdUnitEvent) -> void:
	_html_reporter.on_gdunit_event(test_event)
