class_name GdUnitHtmlReport
extends GdUnitReportSummary

var _report_path: String


func _init(report_path: String) -> void:
	_report_path = report_path


func write() -> void:
	var template := GdUnitHtmlPatterns.load_template("res://addons/gdUnit4/src/reporters/html/template/index.html")
	var to_write := GdUnitHtmlPatterns.build(template, self, "")
	to_write = apply_path_reports(_report_path, to_write, _reports)
	to_write = apply_testsuite_reports(_report_path, to_write, _reports)
	# write report
	FileAccess.open(report_file(), FileAccess.WRITE).store_string(to_write)
	@warning_ignore("return_value_discarded")
	GdUnitFileAccess.copy_directory("res://addons/gdUnit4/src/reporters/html/template/css/", _report_path + "/css")


func report_file() -> String:
	return "%s/index.html" % _report_path


func apply_path_reports(report_dir :String, template :String, report_summaries :Array) -> String:
	#Dictionary[String, Array[GdUnitReportSummary]]
	var path_report_mapping := GdUnitByPathReport.sort_reports_by_path(report_summaries)
	var table_records := PackedStringArray()
	var paths :Array[String] = []
	paths.append_array(path_report_mapping.keys())
	paths.sort()
	for report_at_path in paths:
		var reports: Array[GdUnitReportSummary] = path_report_mapping.get(report_at_path)
		var report := GdUnitByPathReport.new(report_at_path, reports)
		var report_link :String = report.write(report_dir).replace(report_dir, ".")
		@warning_ignore("return_value_discarded")
		table_records.append(report.create_record(report_link))
	return template.replace(GdUnitHtmlPatterns.TABLE_BY_PATHS, "\n".join(table_records))


func apply_testsuite_reports(report_dir: String, template: String, test_suite_reports: Array[GdUnitReportSummary]) -> String:
	var table_records := PackedStringArray()
	for report: GdUnitTestSuiteReport in test_suite_reports:
		var report_link :String = report.write(report_dir).replace(report_dir, ".")
		@warning_ignore("return_value_discarded")
		table_records.append(report.create_record(report_link) as String)
	return template.replace(GdUnitHtmlPatterns.TABLE_BY_TESTSUITES, "\n".join(table_records))
