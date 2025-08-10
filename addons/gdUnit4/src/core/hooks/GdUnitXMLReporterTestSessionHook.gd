class_name GdUnitXMLReporterTestSessionHook
extends GdUnitBaseReporterTestSessionHook


func _init() -> void:
	super(JUnitXmlReportWriter.new(), "GdUnitXMLTestReporter", "The JUnit XML test reporting hook.")
