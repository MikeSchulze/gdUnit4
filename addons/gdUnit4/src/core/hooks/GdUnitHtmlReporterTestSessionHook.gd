class_name GdUnitHtmlReporterTestSessionHook
extends GdUnitBaseReporterTestSessionHook


func _init() -> void:
	super("GdUnitHtmlTestReporter", "The Html test reporting hook.")


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	var report_path := GdUnitHtmlReport.new(session.report_path).write(_report_summary)
	session.send_message("Open HTML Report at: file://{0}".format([report_path]))

	return GdUnitResult.success()
