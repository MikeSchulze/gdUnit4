class_name GdUnitHtmlReporterTestSessionHook
extends GdUnitBaseReporterTestSessionHook


func _init() -> void:
	super(GdUnitHtmlReportWriter.new(), "GdUnitHtmlTestReporter", "The Html test reporting hook.")
