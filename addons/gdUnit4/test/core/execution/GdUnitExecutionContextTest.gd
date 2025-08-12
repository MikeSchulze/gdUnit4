# GdUnit generated TestSuite
class_name GdUnitExecutionContextTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


var _flaky_settings: bool

func before() -> void:
	# register to receive test reports
	_flaky_settings = ProjectSettings.get_setting(GdUnitSettings.TEST_FLAKY_CHECK, false)
	ProjectSettings.set_setting(GdUnitSettings.TEST_FLAKY_CHECK, false)


func after() -> void:
	# Restore original project settings
	ProjectSettings.set_setting(GdUnitSettings.TEST_FLAKY_CHECK, _flaky_settings)


func test_report_collectors() -> void:
	# setup
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(create_test_case("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, tc)
	var ec3 := GdUnitExecutionContext.of(ec2)

	# add reports
	var failure11 := GdUnitReport.new().create(GdUnitReport.FAILURE, 1, "error_ec11")
	ec1.add_report(failure11)
	var failure21 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec21")
	var failure22 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec22")
	ec2.add_report(failure21)
	ec2.add_report(failure22)
	var failure31 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec31")
	var failure32 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec32")
	var failure33 := GdUnitReport.new().create(GdUnitReport.FAILURE, 3, "error_ec33")
	ec3.add_report(failure31)
	ec3.add_report(failure32)
	ec3.add_report(failure33)
	# verify
	assert_array(ec1.reports()).contains_exactly([failure11])
	assert_array(ec2.reports()).contains_exactly([failure21, failure22])
	assert_array(ec3.reports()).contains_exactly([failure31, failure32, failure33])
	ec1.dispose()


func test_has_and_count_failures() -> void:
	# setup
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(create_test_case("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, tc)
	var ec3 := GdUnitExecutionContext.of(ec2)

	# precheck
	assert_bool(has_failures(ec1)).is_false()
	assert_that(count_failures(ec1)).is_equal(0)
	assert_bool(has_failures(ec2)).is_false()
	assert_that(count_failures(ec2)).is_equal(0)
	assert_bool(has_failures(ec3)).is_false()
	assert_that(count_failures(ec3)).is_equal(0)

	# add four failure report to test
	ec3.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error_ec31"))
	ec3.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 43, "error_ec32"))
	ec3.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 44, "error_ec33"))
	ec3.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 45, "error_ec34"))
	# verify
	assert_bool(has_failures(ec1)).is_true()
	assert_that(count_failures(ec1)).is_equal(4)
	assert_bool(has_failures(ec2)).is_true()
	assert_that(count_failures(ec2)).is_equal(4)
	assert_bool(has_failures(ec3)).is_true()
	assert_that(count_failures(ec3)).is_equal(4)

	# add two failure report to test_case_stage
	ec2.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error_ec21"))
	ec2.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 43, "error_ec22"))
	# verify
	assert_bool(has_failures(ec1)).is_true()
	assert_that(count_failures(ec1)).is_equal(6)
	assert_bool(has_failures(ec2)).is_true()
	assert_that(count_failures(ec2)).is_equal(6)
	assert_bool(has_failures(ec3)).is_true()
	assert_that(count_failures(ec3)).is_equal(4)

	# add one failure report to test_suite_stage
	ec1.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error_ec1"))
	# verify
	assert_bool(has_failures(ec1)).is_true()
	assert_that(count_failures(ec1)).is_equal(7)
	assert_bool(has_failures(ec2)).is_true()
	assert_that(count_failures(ec2)).is_equal(6)
	assert_bool(has_failures(ec3)).is_true()
	assert_that(count_failures(ec3)).is_equal(4)
	ec1.dispose()


@warning_ignore("unused_parameter")
func test_simmulate_flaky_test(retry_count: int, is_failed: bool, is_flaky: bool, test_parameters := [
	[1, true, false],
	[2, true, false],
	[3, false, true],]) -> void:
	# setup
	var ts :GdUnitTestSuite = auto_free(GdUnitTestSuite.new())
	var tc :_TestCase = auto_free(create_test_case("test_case1", 0, ""))
	ts.add_child(tc)
	var ec1 := GdUnitExecutionContext.of_test_suite(ts)
	var ec2 := GdUnitExecutionContext.of_test_case(ec1, tc)
	for retry in range(0, retry_count):
		# before/after context
		var context := GdUnitExecutionContext.of(ec2)
		# test context
		var test_context := GdUnitExecutionContext.of(context)
		# let the first two retrys fail and the last retry succeeds
		if retry < 2:
			test_context.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 42, "error"))
			test_context.add_report(GdUnitReport.new().create(GdUnitReport.FAILURE, 43, "error"))

	var statistics := ec2.calculate_statistics()
	#for key: String in statistics.keys():
	#	prints("%13s: %s" % [key, statistics[key]])
	#prints()
	assert_bool(statistics[GdUnitEvent.FLAKY]).is_equal(is_flaky)
	assert_bool(statistics[GdUnitEvent.FAILED]).is_equal(is_failed)



static func create_test_case(p_name: String, p_line_number: int, p_script_path: String) -> _TestCase:
	var test_case := GdUnitTestCase.new()
	test_case.test_name = p_name
	test_case.line_number = p_line_number
	test_case.source_file = p_script_path
	var attribute := TestCaseAttribute.new()
	return _TestCase.new(test_case, attribute, null)


static func has_failures(context: GdUnitExecutionContext) -> bool:
	var statistics := context.calculate_statistics()

	return statistics[GdUnitEvent.FAILED]


static func count_failures(context: GdUnitExecutionContext) -> int:
	var statistics := context.calculate_statistics()

	return statistics[GdUnitEvent.FAILED_COUNT]
