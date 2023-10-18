extends GdUnitTestSuite

@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


class TestCaseStatistics:
	var _testcase_before_called := 0
	var _testcase_after_called := 0
	var _test_called := 0
	var _expected_calls :int
	
	func _init(expected_calls :int):
		_expected_calls = expected_calls
	
	func count_test_before_test():
		_testcase_before_called +=1
	
	func count_test_after_test():
		_testcase_after_called +=1
	
	func count_test():
		_test_called += 1


var _metrics = {
	"test_parameterized_2times" : TestCaseStatistics.new(2),
	"test_parameterized_5times" : TestCaseStatistics.new(5)
}

var _before_called := 0
var _after_called := 0


func before():
	_before_called += 1


func after():
	_after_called += 1
	assert_that(_before_called)\
		.override_failure_message("Expecting 'before' is called only one times")\
		.is_equal(1)
	assert_that(_after_called)\
		.override_failure_message("Expecting 'after' is called only one times")\
		.is_equal(1)
	
	for test_case in _metrics.keys():
		var statistics := _metrics[test_case] as TestCaseStatistics
		assert_int(statistics._testcase_before_called)\
			.override_failure_message("Expect before_test called %s times but is %s for test case %s" % [statistics._expected_calls, statistics._testcase_before_called, test_case])\
			.is_equal(statistics._expected_calls)
		assert_int(statistics._test_called)\
			.override_failure_message("Expect test called %s times but is %s for test case %s" % [statistics._expected_calls, statistics._test_called, test_case])\
			.is_equal(statistics._expected_calls)
		assert_int(statistics._testcase_after_called)\
			.override_failure_message("Expect after_test called %s times but is %s for test case %s" % [statistics._expected_calls, statistics._testcase_after_called, test_case])\
			.is_equal(statistics._expected_calls)


func before_test():
	_metrics[__active_test_case].count_test_before_test()


func after_test():
	_metrics[__active_test_case].count_test_after_test()


@warning_ignore('unused_parameter')
func test_parameterized_2times(a: int, expected :bool, test_parameters := [
	[0, false],
	[1, true]]):
	
	_metrics[__active_test_case].count_test()


@warning_ignore('unused_parameter')
func test_parameterized_5times(a: int, expected :bool, test_parameters := [
	[0, false],
	[1, true],
	[0, false],
	[1, true],
	[1, true]]):
	
	_metrics[__active_test_case].count_test()
