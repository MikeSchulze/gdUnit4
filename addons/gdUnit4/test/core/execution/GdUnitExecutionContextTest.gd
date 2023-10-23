# GdUnit generated TestSuite
class_name GdUnitExecutionContextTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/execution/GdUnitExecutionContext.gd'


func add_report(ec :GdUnitExecutionContext, report :GdUnitReport) -> void:
	ec._report_collector.on_reports(ec.get_instance_id(), report)


func assert_statistics(ec :GdUnitExecutionContext):
	assert_that(ec.has_failures()).is_false()
	assert_that(ec.has_errors()).is_false()
	assert_that(ec.has_warnings()).is_false()
	assert_that(ec.has_skipped()).is_false()
	assert_that(ec.count_failures(true)).is_equal(0)
	assert_that(ec.count_errors(true)).is_equal(0)
	assert_that(ec.count_skipped(true)).is_equal(0)
	assert_that(ec.count_orphans()).is_equal(0)
	assert_dict(ec.build_report_statistics(0))\
		.contains_key_value(GdUnitEvent.FAILED, false)\
		.contains_key_value(GdUnitEvent.ERRORS, false)\
		.contains_key_value(GdUnitEvent.WARNINGS, false)\
		.contains_key_value(GdUnitEvent.SKIPPED, false)\
		.contains_key_value(GdUnitEvent.ORPHAN_NODES, 0)\
		.contains_key_value(GdUnitEvent.FAILED_COUNT, 0)\
		.contains_key_value(GdUnitEvent.ERROR_COUNT, 0)\
		.contains_key_value(GdUnitEvent.SKIPPED_COUNT, 0)\
		.contains_keys([GdUnitEvent.ELAPSED_TIME])


func test_create_context_of_test_suite() -> void:
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var ec := GdUnitExecutionContext.of_test_suite(ts)
	# verify the current context is not affected by this test itself
	assert_object(__execution_context).is_not_same(ec)
	
	# verify the execution context is assigned to the test suite
	assert_object(ts.__execution_context).is_same(ec)
	
	# verify execution context is fully initialized
	assert_that(ec).is_not_null()
	assert_object(ec.test_suite).is_same(ts)
	assert_object(ec.test_case).is_null()
	assert_array(ec._sub_context).is_empty()
	assert_object(ec._orphan_monitor).is_not_null()
	assert_object(ec._memory_observer).is_not_null()
	assert_object(ec._report_collector).is_not_null()
	assert_statistics(ec)
	ec.dispose()


func test_create_context_of_test_case() -> void:
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(_TestCase.new().configure("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, "test_case1")
	# verify the current context is not affected by this test itself
	assert_object(__execution_context).is_not_same(ec1)
	assert_object(__execution_context).is_not_same(ec2)
	
	# verify current execution contest is assigned to the test suite
	assert_object(ts.__execution_context).is_same(ec2)
	# verify execution context is fully initialized
	assert_that(ec2).is_not_null()
	assert_object(ec2.test_suite).is_same(ts)
	assert_object(ec2.test_case).is_same(tc)
	assert_array(ec2._sub_context).is_empty()
	assert_object(ec2._orphan_monitor).is_not_null().is_not_same(ec1._orphan_monitor)
	assert_object(ec2._memory_observer).is_not_null().is_not_same(ec1._memory_observer)
	assert_object(ec2._report_collector).is_not_null().is_not_same(ec1._report_collector)
	assert_statistics(ec2)
	# check parent context ec1 is still valid
	assert_that(ec1).is_not_null()
	assert_object(ec1.test_suite).is_same(ts)
	assert_object(ec1.test_case).is_null()
	assert_array(ec1._sub_context).contains_exactly([ec2])
	assert_object(ec1._orphan_monitor).is_not_null()
	assert_object(ec1._memory_observer).is_not_null()
	assert_object(ec1._report_collector).is_not_null()
	assert_statistics(ec1)
	ec1.dispose()


func test_create_context_of_test() -> void:
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(_TestCase.new().configure("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, "test_case1")
	var ec3 := GdUnitExecutionContext.of(ec2)
	# verify the current context is not affected by this test itself
	assert_object(__execution_context).is_not_same(ec1)
	assert_object(__execution_context).is_not_same(ec2)
	assert_object(__execution_context).is_not_same(ec3)
	
	# verify current execution contest is assigned to the test suite
	assert_object(ts.__execution_context).is_same(ec3)
	# verify execution context is fully initialized
	assert_that(ec3).is_not_null()
	assert_object(ec3.test_suite).is_same(ts)
	assert_object(ec3.test_case).is_same(tc)
	assert_array(ec3._sub_context).is_empty()
	assert_object(ec3._orphan_monitor).is_not_null()\
		.is_not_same(ec1._orphan_monitor)\
		.is_not_same(ec2._orphan_monitor)
	assert_object(ec3._memory_observer).is_not_null()\
		.is_not_same(ec1._memory_observer)\
		.is_not_same(ec2._memory_observer)
	assert_object(ec3._report_collector).is_not_null()\
		.is_not_same(ec1._report_collector)\
		.is_not_same(ec2._report_collector)
	assert_statistics(ec3)
	# check parent context ec2 is still valid
	assert_that(ec2).is_not_null()
	assert_object(ec2.test_suite).is_same(ts)
	assert_object(ec2.test_case).is_same(tc)
	assert_array(ec2._sub_context).contains_exactly([ec3])
	assert_object(ec2._orphan_monitor).is_not_null()\
		.is_not_same(ec1._orphan_monitor)
	assert_object(ec2._memory_observer).is_not_null()\
		.is_not_same(ec1._memory_observer)
	assert_object(ec2._report_collector).is_not_null()\
		.is_not_same(ec1._report_collector)
	assert_statistics(ec2)
	# check parent context ec1 is still valid
	assert_that(ec1).is_not_null()
	assert_object(ec1.test_suite).is_same(ts)
	assert_object(ec1.test_case).is_null()
	assert_array(ec1._sub_context).contains_exactly([ec2])
	assert_object(ec1._orphan_monitor).is_not_null()
	assert_object(ec1._memory_observer).is_not_null()
	assert_object(ec1._report_collector).is_not_null()
	assert_statistics(ec1)
	ec1.dispose()


func test_report_collectors() -> void:
	# setup
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(_TestCase.new().configure("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, "test_case1")
	var ec3 := GdUnitExecutionContext.of(ec2)
	
	# add reports
	var failure11 := GdUnitReport.new().create(GdUnitReport.FAILURE, 1, "error_ec11")
	add_report(ec1, failure11)
	var failure21 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec21")
	var failure22 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec22")
	add_report(ec2, failure21)
	add_report(ec2, failure22)
	var failure31 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec31")
	var failure32 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec32")
	var failure33 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec33")
	add_report(ec3, failure31)
	add_report(ec3, failure32)
	add_report(ec3, failure33)
	# verify
	assert_array(ec1.reports()).contains_exactly([failure11])
	assert_array(ec2.reports()).contains_exactly([failure21, failure22])
	assert_array(ec3.reports()).contains_exactly([failure31, failure32, failure33])
	ec1.dispose()


func test_has_and_count_failures() -> void:
	# setup
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(_TestCase.new().configure("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, "test_case1")
	var ec3 := GdUnitExecutionContext.of(ec2)
	
	# precheck
	assert_that(ec1.has_failures()).is_false()
	assert_that(ec1.count_failures(true)).is_equal(0)
	assert_that(ec2.has_failures()).is_false()
	assert_that(ec2.count_failures(true)).is_equal(0)
	assert_that(ec3.has_failures()).is_false()
	assert_that(ec3.count_failures(true)).is_equal(0)
	
	# add four failure report to test
	add_report(ec3, GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error_ec31"))
	add_report(ec3, GdUnitReport.new().create(GdUnitReport.FAILURE, 43, "error_ec32"))
	add_report(ec3, GdUnitReport.new().create(GdUnitReport.FAILURE, 44, "error_ec33"))
	add_report(ec3, GdUnitReport.new().create(GdUnitReport.FAILURE, 45, "error_ec34"))
	# verify
	assert_that(ec1.has_failures()).is_true()
	assert_that(ec1.count_failures(true)).is_equal(4)
	assert_that(ec2.has_failures()).is_true()
	assert_that(ec2.count_failures(true)).is_equal(4)
	assert_that(ec3.has_failures()).is_true()
	assert_that(ec3.count_failures(true)).is_equal(4)
	
	# add two failure report to test_case_stage
	add_report(ec2, GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error_ec21"))
	add_report(ec2, GdUnitReport.new().create(GdUnitReport.FAILURE, 43, "error_ec22"))
	# verify
	assert_that(ec1.has_failures()).is_true()
	assert_that(ec1.count_failures(true)).is_equal(6)
	assert_that(ec2.has_failures()).is_true()
	assert_that(ec2.count_failures(true)).is_equal(6)
	assert_that(ec3.has_failures()).is_true()
	assert_that(ec3.count_failures(true)).is_equal(4)
	
	# add one failure report to test_suite_stage
	add_report(ec1, GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error_ec1"))
	# verify
	assert_that(ec1.has_failures()).is_true()
	assert_that(ec1.count_failures(true)).is_equal(7)
	assert_that(ec2.has_failures()).is_true()
	assert_that(ec2.count_failures(true)).is_equal(6)
	assert_that(ec3.has_failures()).is_true()
	assert_that(ec3.count_failures(true)).is_equal(4)
	ec1.dispose()
