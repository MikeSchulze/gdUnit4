# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name GodotGdErrorMonitorTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/monitor/GodotGdErrorMonitor.gd'


const error_report = """
	**ERROR**: Error parsing JSON at line 0: 
   At: core/bind/core_bind.cpp:3293:parse() - Error parsing JSON at line 0: 
	"""
const script_error = """
	**SCRIPT ERROR**: Invalid call. Nonexistent function 'foo' in base 'RefCounted'.
   At: res://test_test/test_test.gd:14:TestTest.test_with_script_errors() - Invalid call. Nonexistent function 'foo' in base 'RefCounted'.
	"""

func test_parse_script_error_line_number() -> void:
	var line := GodotGdErrorMonitor.new()._parse_error_line_number(script_error)
	assert_int(line).is_equal(14)

func test_parse_push_error_line_number() -> void:
	var line := GodotGdErrorMonitor.new()._parse_error_line_number(error_report)
	assert_int(line).is_equal(-1)

func test_scan_for_push_errors() -> void:
	var monitor := mock(GodotGdErrorMonitor, CALL_REAL_FUNC) as GodotGdErrorMonitor
	monitor._report_enabled = true
	do_return(error_report).checked(monitor)._collect_seek_log()
	
	# with disabled push_error reporting
	do_return(false).checked(monitor)._is_report_push_errors()
	monitor._scan_for_errors()
	assert_array(monitor.reports()).is_empty()
	
	# with enabled push_error reporting
	do_return(true).checked(monitor)._is_report_push_errors()
	monitor._scan_for_errors()
	var error =\
"""	**ERROR**: Error parsing JSON at line 0: 
   At: core/bind/core_bind.cpp:3293:parse() - Error parsing JSON at line 0: """
	var expected_report = GdUnitReport.new().create(GdUnitReport.FAILURE, -1, error)
	assert_array(monitor.reports()).contains_exactly([expected_report])

func test_scan_for_script_errors() -> void:
	var monitor := mock(GodotGdErrorMonitor, CALL_REAL_FUNC) as GodotGdErrorMonitor
	monitor._report_enabled = true
	do_return(script_error).checked(monitor)._collect_seek_log()
	
	# with disabled push_error reporting
	do_return(false).checked(monitor)._is_report_script_errors()
	monitor._scan_for_errors()
	assert_array(monitor.reports()).is_empty()
	
	# with enabled push_error reporting
	do_return(true).checked(monitor)._is_report_script_errors()
	monitor._scan_for_errors()
	var error =\
"""	**SCRIPT ERROR**: Invalid call. Nonexistent function 'foo' in base 'RefCounted'.
   At: res://test_test/test_test.gd:14:TestTest.test_with_script_errors() - Invalid call. Nonexistent function 'foo' in base 'RefCounted'."""
	var expected_report = GdUnitReport.new().create(GdUnitReport.FAILURE, 14, error)
	assert_array(monitor.reports()).contains_exactly([expected_report])
