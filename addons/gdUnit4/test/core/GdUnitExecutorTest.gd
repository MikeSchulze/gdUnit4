# GdUnit generated TestSuite
class_name GdUnitExecutorTest
extends GdUnitTestSuite

signal test_execution_completed()

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitExecutor.gd'

var _executor :GdUnitExecutor
var _events :Array = Array()
var _stack : Array = []


func before():
	_executor = GdUnitExecutor.new(true)
	_executor.gdunit_event_test.connect(Callable(self, "_on_gdunit_event_test"))
	add_child(_executor)


func before_test():
	# clean the stack before every test run
	_stack.clear()


func resource(resource_path :String) -> GdUnitTestSuite:
	return GdUnitTestResourceLoader.load_test_suite(resource_path) as GdUnitTestSuite


func _on_gdunit_event_test(event :GdUnitEvent) -> void:
	_events.append(event)


func execute(test_suite :GdUnitTestSuite, enable_orphan_detection := true):
	add_child(test_suite)
	_events.clear()
	_executor._memory_pool.configure(enable_orphan_detection)
	_executor.execute(test_suite)
	await _executor.ExecutionCompleted
	return _events


func filter_failures(events :Array) -> Array:
	var filtered_events := Array()
	for e in events:
		var event :GdUnitEvent = e
		prints(event)
		if event.is_failed():
			filtered_events.append(event)
	return filtered_events


func flating_message(message :String) -> String:
	return GdUnitAssertImpl._normalize_bbcode(message)


func assert_event_reports(events :Array, reports1 :Array, reports2 :Array, reports3 :Array, reports4 :Array, reports5 :Array, reports6 :Array) -> void:
	var expected_reports := [reports1, reports2, reports3, reports4, reports5, reports6]
	for event_index in events.size():
		var current :Array = events[event_index].reports()
		var expected = expected_reports[event_index] if expected_reports.size() > event_index else []
		if expected.is_empty():
			for m in current.size():
				assert_str(flating_message(current[m].message())).is_empty()
		
		for m in expected.size():
			if m < current.size():
				assert_str(flating_message(current[m].message())).is_equal(expected[m])
			else:
				assert_str("<N/A>").is_equal(expected[m])


func assert_event_list(events :Array, suite_name :String, test_case_names = ["test_case1", "test_case2"]) -> void:
	var expected_events := Array()
	expected_events.append(tuple(GdUnitEvent.TESTSUITE_BEFORE, suite_name, "before", test_case_names.size()))
	for test_case in test_case_names:
		expected_events.append(tuple(GdUnitEvent.TESTCASE_BEFORE, suite_name, test_case, 0))
		expected_events.append(tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, test_case, 0))
	expected_events.append(tuple(GdUnitEvent.TESTSUITE_AFTER, suite_name, "after", 0))
	
	assert_array(events).has_size(6).extractv(
		extr("type"), extr("suite_name"), extr("test_name"), extr("total_count"))\
		.contains_exactly(expected_events)


func assert_event_counters(events :Array) -> GdUnitArrayAssert:
	return assert_array(events).extractv(extr("type"), extr("error_count"), extr("failed_count"), extr("orphan_nodes"))


func assert_event_states(events :Array) -> GdUnitArrayAssert:
	return assert_array(events).extractv(extr("test_name"), extr("is_success"), extr("is_warning"), extr("is_failed"), extr("is_error"))


func test_execute_success() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteAllStagesSuccess.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteAllStagesSuccess")
	# verify all counters are zero / no errors, failures, orphans
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		tuple("after", true, false, false, false),
	])
	# all success no reports expected
	assert_event_reports(events, [], [], [], [], [], [])


func test_execute_failure_on_stage_before() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailOnStageBefore.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailOnStageBefore")
	# we expect the testsuite is failing on stage 'before()' and commits one failure
	# reported finally at TESTSUITE_AFTER event
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		# report failure failed_count = 1
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 1, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		# report suite is not success, is failed
		tuple("after", false, false, true, false),
	])
	# one failure at before()
	assert_event_reports(events, 
		[], 
		[], 
		[], 
		[], 
		[], 
		["failed on before()"])


func test_execute_failure_on_stage_after() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailOnStageAfter.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailOnStageAfter")
	# we expect the testsuite is failing on stage 'before()' and commits one failure
	# reported finally at TESTSUITE_AFTER event
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		# report failure failed_count = 1
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 1, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		# report suite is not success, is failed
		tuple("after", false, false, true, false),
	])
	# one failure at after()
	assert_event_reports(events,
		[],
		[], 
		[],
		[], 
		[],
		["failed on after()"])


func test_execute_failure_on_stage_before_test() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailOnStageBeforeTest.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailOnStageBeforeTest")
	# we expect the testsuite is failing on stage 'before_test()' and commits one failure on each test case
	# because is in scope of test execution
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# failure is count to the test
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# failure is count to the test
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", false, false, true, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", false, false, true, false),
		# report suite is not success, is failed
		tuple("after", false, false, true, false),
	])
	# before_test() failure report is append to each test
	assert_event_reports(events,
		[],
		[], 
		# verify failure report is append to 'test_case1'
		["failed on before_test()"],
		[], 
		# verify failure report is append to 'test_case2'
		["failed on before_test()"],
		[])


func test_execute_failure_on_stage_after_test() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailOnStageAfterTest.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailOnStageAfterTest")
	# we expect the testsuite is failing on stage 'after_test()' and commits one failure on each test case
	# because is in scope of test execution
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# failure is count to the test
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# failure is count to the test
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", false, false, true, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", false, false, true, false),
		# report suite is not success, is failed
		tuple("after", false, false, true, false),
	])
	# 'after_test' failure report is append to each test
	assert_event_reports(events,
		[],
		[], 
		# verify failure report is append to 'test_case1'
		["failed on after_test()"],
		[], 
		# verify failure report is append to 'test_case2'
		["failed on after_test()"],
		[])


func test_execute_failure_on_stage_test_case1() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailOnStageTestCase1.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailOnStageTestCase1")
	# we expect the test case 'test_case1' is failing  and commits one failure
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# test has one failure
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", false, false, true, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		# report suite is not success, is failed
		tuple("after", false, false, true, false),
	])
	# only 'test_case1' reports a failure
	assert_event_reports(events,
		[],
		[], 
		# verify failure report is append to 'test_case1'
		["failed on test_case1()"], 
		[], 
		[], 
		[])


func test_execute_failure_on_multiple_stages() -> void:
	# this is a more complex failure state, we expect to find multipe failures on different stages
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailOnMultipeStages.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailOnMultipeStages")
	# we expect failing on multiple stages
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# the first test has two failures plus one from 'before_test'
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 3, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# the second test has no failures but one from 'before_test'
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		# and one failure is on stage 'after' found
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 1, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", false, false, true, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", false, false, true, false),
		# report suite is not success, is failed
		tuple("after", false, false, true, false),
	])
	# only 'test_case1' reports a 'real' failures plus test setup stage failures
	assert_event_reports(events,
		[],
		[],
		# verify failure reports to 'test_case1'
		["failed on before_test()", "failed 1 on test_case1()", "failed 2 on test_case1()"], 
		[],
		# verify failure reports to 'test_case2'
		["failed on before_test()"],
		# and one failure detected at stage 'after'
		["failed on after()"])


# GD-63
func test_execute_failure_and_orphans() -> void:
	# this is a more complex failure state, we expect to find multipe orphans on different stages
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailAndOrpahnsDetected.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailAndOrpahnsDetected")
	# we expect failing on multiple stages
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# the first test ends with a warning and in summ 5 orphans detected
		# 2 from stage 'before_test' + 3 from test itself
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 5),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# the second test ends with a one failure and in summ 6 orphans detected
		# 2 from stage 'before_test' + 4 from test itself
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 6),
		# and one orphan detected from stage 'before'
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 1),
	])
	# is_success, is_warning, is_failed, is_error
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		# test case has only warnings
		tuple("test_case1", false, true, false, false),
		tuple("test_case2", true, false, false, false),
		# test case has failures and warnings
		tuple("test_case2", false, true, true, false),
		# report suite is not success, has warnings and failures
		tuple("after", false, true, true, false),
	])
	# only 'test_case1' reports a 'real' failures plus test setup stage failures
	assert_event_reports(events,
		[],
		[],
		# ends with warnings
		["WARNING:\n Detected <3> orphan nodes during test execution!",
		"WARNING:\n Detected <2> orphan nodes during test setup! Check before_test() and after_test()!"],
		[],
		# ends with failure and warnings 
		["WARNING:\n Detected <4> orphan nodes during test execution!",
		"faild on test_case2()",
		"WARNING:\n Detected <2> orphan nodes during test setup! Check before_test() and after_test()!"],
		# and one failure detected at stage 'after'
		["WARNING:\n Detected <1> orphan nodes during test suite setup stage! Check before() and after()!"])


# GD-62
func test_execute_failure_and_orphans_report_orphan_disabled() -> void:
	# this is a more complex failure state, we expect to find multipe orphans on different stages
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailAndOrpahnsDetected.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution whit disabled orphan detection
	var events = await execute(test_suite, false)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailAndOrpahnsDetected")
	# we expect failing on multiple stages, no orphans reported
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# one failure
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	# is_success, is_warning, is_failed, is_error
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		# test case has success
		tuple("test_case1", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		# test case has a failure
		tuple("test_case2", false, false, true, false),
		# report suite is not success, has warnings and failures
		tuple("after", false, false, true, false),
	])
	# only 'test_case1' reports a failure, orphans are not reported
	assert_event_reports(events,
		[],
		[],
		[],
		[],
		# ends with a failure
		["faild on test_case2()"],
		[])


# GD-66
func test_execute_error_on_test_timeout() -> void:
	# this tests a timeout on a test case reported as error
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteErrorOnTestTimeout.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteErrorOnTestTimeout")
	# we expect failing on multiple stages
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# the first test has two failures plus one from 'before_test'
		tuple(GdUnitEvent.TESTCASE_AFTER, 1, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# the second test has no failures but one from 'before_test'
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		# and one failure is on stage 'after' found
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		# testcase ends with a timeout error
		tuple("test_case1", false, false, false, true),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		# report suite is not success, is error
		tuple("after", false, false, false, true),
	])
	# 'test_case1' reports a error triggered by test timeout
	assert_event_reports(events,
		[],
		[],
		# verify error reports to 'test_case1'
		["Timeout !\n 'Test timed out after 2s 0ms'"],
		[],
		[],
		[])


func test_execute_failure_fuzzer_iteration() -> void:
	# this tests a timeout on a test case reported as error
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/GdUnitFuzzerTest.resource")
	# verify all test cases loaded
	var expected_test_cases := ["test_multi_yielding_with_fuzzer", "test_multi_yielding_with_fuzzer_fail_after_3_iterations"]
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(expected_test_cases)
	# simulate test suite execution
	var events = await execute(test_suite)
	
	# verify basis infos
	assert_event_list(events, "GdUnitFuzzerTest", expected_test_cases)
	# we expect failing on multiple stages
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		# test failed after 3 iterations
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 1, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	# is_success, is_warning, is_failed, is_error
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_multi_yielding_with_fuzzer", true, false, false, false),
		tuple("test_multi_yielding_with_fuzzer", true, false, false, false),
		tuple("test_multi_yielding_with_fuzzer_fail_after_3_iterations", true, false, false, false),
		tuple("test_multi_yielding_with_fuzzer_fail_after_3_iterations", false, false, true, false),
		tuple("after", false, false, true, false),
	])
	# 'test_case1' reports a error triggered by test timeout
	assert_event_reports(events,
		[],
		[],
		[],
		[],
		# must fail after three iterations
		["Found an error after '3' test iterations\n Expecting: 'false' but is 'true'"],
		[])


func test_execute_add_child_on_before_GD_106() -> void:
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailAddChildStageBefore.resource")
	# verify all test cases loaded
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(["test_case1", "test_case2"])
	# simulate test suite execution
	var events = await execute(test_suite)
	# verify basis infos
	assert_event_list(events, "TestSuiteFailAddChildStageBefore")
	# verify all counters are zero / no errors, failures, orphans
	assert_event_counters(events).contains_exactly([
		tuple(GdUnitEvent.TESTSUITE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_BEFORE, 0, 0, 0),
		tuple(GdUnitEvent.TESTCASE_AFTER, 0, 0, 0),
		tuple(GdUnitEvent.TESTSUITE_AFTER, 0, 0, 0),
	])
	assert_event_states(events).contains_exactly([
		tuple("before", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case1", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		tuple("test_case2", true, false, false, false),
		tuple("after", true, false, false, false),
	])
	# all success no reports expected
	assert_event_reports(events, [], [], [], [], [], [])


func test_fuzzer_before_before(fuzzer := Fuzzers.rangei(0, 1000), fuzzer_iterations = 1000):
	# verify the used stack is cleaned by 'before_test'
	assert_array(_stack).is_empty()
	_stack.push_back(1)


func test_execute_parameterizied_tests() -> void:
	# this is a more complex failure state, we expect to find multipe failures on different stages
	var test_suite := resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteParameterizedTests.resource")
	# verify all test cases loaded
	var expected_test_cases = [
		"test_parameterized_bool_value",
		"test_parameterized_int_values",
		"test_parameterized_int_values_fail",
		"test_parameterized_float_values",
		"test_parameterized_string_values",
		"test_parameterized_Vector2_values",
		"test_parameterized_Vector3_values",
		"test_parameterized_obj_values",
		"test_dictionary_div_number_types"]
	assert_array(test_suite.get_children()).extract("get_name").contains_exactly(expected_test_cases)
	# simulate test suite execution
	# run the tests with to compare type save
	ProjectSettings.set_setting(GdUnitSettings.REPORT_ASSERT_STRICT_NUMBER_TYPE_COMPARE, true)
	var events = await execute(test_suite)
	var suite_name = "TestSuiteParameterizedTests"
	
	# the test is partial failing because of diverent type in the dictionary
	assert_array(events).extractv(
		extr("type"), extr("suite_name"), extr("test_name"), extr("is_error"), extr("is_failed"), extr("orphan_nodes"))\
		.contains([
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 0, [
				{ top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}, { top = 50, bottom = 50, left = 50, right = 50}
			]), false, true, 0),
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 1, [
				{ top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}, { top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}
			]), false, false, 0),
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 2, [
				{ top = 50, bottom = 50, left = 50, right = 50}, { top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}
			]), false, true, 0),
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 3, [
				{ top = 50, bottom = 50, left = 50, right = 50}, { top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}
			]), false, false, 0)
		])
	
	# rerun the same tests again with allow to compare type unsave
	ProjectSettings.set_setting(GdUnitSettings.REPORT_ASSERT_STRICT_NUMBER_TYPE_COMPARE, false)
	# simulate test suite execution
	test_suite = resource("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteParameterizedTests.resource")
	events = await execute(test_suite)
	
	# the test should now be successful
	assert_array(events).extractv(
		extr("type"), extr("suite_name"), extr("test_name"), extr("is_error"), extr("is_failed"), extr("orphan_nodes"))\
		.contains([
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 0, [
				{ top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}, { top = 50, bottom = 50, left = 50, right = 50}
			]), false, false, 0),
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 1, [
				{ top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}, { top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}
			]), false, false, 0),
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 2, [
				{ top = 50, bottom = 50, left = 50, right = 50}, { top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}
			]), false, false, 0),
			tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, buld_test_case_name("test_dictionary_div_number_types", 3, [
				{ top = 50, bottom = 50, left = 50, right = 50}, { top = 50.0, bottom = 50.0, left = 50.0, right = 50.0}
			]), false, false, 0)
		])
	# restore default settings
	ProjectSettings.set_setting(GdUnitSettings.REPORT_ASSERT_STRICT_NUMBER_TYPE_COMPARE, true)


func add_expected_test_case_events(suite_name :String, test_name :String, parameters :Array = []) -> Array:
	var expected_events := Array()
	expected_events.append(tuple(GdUnitEvent.TESTCASE_BEFORE, suite_name, test_name, 0))
	for index in parameters.size():
		var test_case_name := buld_test_case_name(test_name, index, parameters[index])
		expected_events.append(tuple(GdUnitEvent.TESTCASE_BEFORE, suite_name, test_case_name, 0))
		expected_events.append(tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, test_case_name, 0))
	expected_events.append(tuple(GdUnitEvent.TESTCASE_AFTER, suite_name, test_name, 0))
	return expected_events


func buld_test_case_name(test_name :String, index :int, parameter :Array) -> String:
	return "%s:%d %s" % [test_name, index, str(parameter)]
