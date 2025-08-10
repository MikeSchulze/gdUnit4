class_name GdUnitXMLReporterTestSessionHook
extends GdUnitBaseReporterTestSessionHook


func _init() -> void:
	super("GdUnitXMLTestReporter", "The JUnit XML test reporting hook.")


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	var report_path := JUnitXmlReport.new(session.report_path).write(_report_summary)
	session.send_message("Open XML Report at: file://{0}".format([report_path]))

	return GdUnitResult.success()
