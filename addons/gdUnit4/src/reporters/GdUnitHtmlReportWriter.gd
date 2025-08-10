class_name GdUnitHtmlReportWriter
extends GdUnitReportWriter


func output_format() -> String:
	return "HTML"


func write(report_path: String, report: GdUnitReportSummary) -> String:
	var template := GdUnitHtmlPatterns.load_template("res://addons/gdUnit4/src/reporters/html/template/index.html")
	var to_write := GdUnitHtmlPatterns.build(template, report, "")
	to_write = _apply_path_reports(report_path, to_write, report.get_reports())
	to_write = _apply_testsuite_reports(report_path, to_write, report.get_reports())
	# write report
	DirAccess.make_dir_recursive_absolute(report_path)
	var html_report_file := "%s/index.html" % report_path
	FileAccess.open(html_report_file, FileAccess.WRITE).store_string(to_write)
	@warning_ignore("return_value_discarded")
	GdUnitFileAccess.copy_directory("res://addons/gdUnit4/src/reporters/html/template/css/", report_path + "/css")
	return html_report_file


func _apply_path_reports(report_dir: String, template: String, report_summaries: Array) -> String:
	#Dictionary[String, Array[GdUnitReportSummary]]
	var path_report_mapping := GdUnitByPathReport.sort_reports_by_path(report_summaries)
	var table_records := PackedStringArray()
	var paths: Array[String] = []
	paths.append_array(path_report_mapping.keys())
	paths.sort()
	for report_at_path in paths:
		var reports: Array[GdUnitReportSummary] = path_report_mapping.get(report_at_path)
		var report := GdUnitByPathReport.new(report_at_path, reports)
		var report_link: String = report.write(report_dir).replace(report_dir, ".")
		@warning_ignore("return_value_discarded")
		table_records.append(report.create_record(report_link))
	return template.replace(GdUnitHtmlPatterns.TABLE_BY_PATHS, "\n".join(table_records))


func _apply_testsuite_reports(report_dir: String, template: String, test_suite_reports: Array[GdUnitReportSummary]) -> String:
	var table_records := PackedStringArray()
	for report: GdUnitTestSuiteReport in test_suite_reports:
		var report_link: String = report.write(report_dir).replace(report_dir, ".")
		@warning_ignore("return_value_discarded")
		table_records.append(report.create_record(report_link) as String)
	return template.replace(GdUnitHtmlPatterns.TABLE_BY_TESTSUITES, "\n".join(table_records))
