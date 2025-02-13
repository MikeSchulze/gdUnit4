## The executor to run a test-suite
class_name GdUnitTestSuiteExecutor


# preload all asserts here
@warning_ignore("unused_private_class_variable")
var _assertions := GdUnitAssertions.new()
var _executeStage := GdUnitTestSuiteExecutionStage.new()


func _init(debug_mode :bool = false) -> void:
	_executeStage.set_debug_mode(debug_mode)


func execute(test_suite :GdUnitTestSuite) -> void:
	var orphan_detection_enabled := GdUnitSettings.is_verbose_orphans()
	if not orphan_detection_enabled:
		prints("!!! Reporting orphan nodes is disabled. Please check GdUnit settings.")

	(Engine.get_main_loop() as SceneTree).root.call_deferred("add_child", test_suite)
	await (Engine.get_main_loop() as SceneTree).process_frame
	await _executeStage.execute(GdUnitExecutionContext.of_test_suite(test_suite))


func run_and_wait(tests: Array[GdUnitTestCase]) -> void:
	# first we group all tests by his parent suite
	var grouped_by_suites := GdArrayTools.group_by(tests, func(test: GdUnitTestCase) -> String:
		return test.source_file
	)
	var scanner := GdUnitTestSuiteScanner.new()
	for suite: String in grouped_by_suites.keys():
		@warning_ignore("unsafe_call_argument")
		var tests_by_suite: Array[GdUnitTestCase] = Array(grouped_by_suites[suite], TYPE_OBJECT, "RefCounted", GdUnitTestCase)
		var test_names: Array = tests_by_suite.map(func(item: GdUnitTestCase) -> String:
			return item.test_name
		)

		var script := GdUnitTestSuiteScanner.load_with_disabled_warnings(suite)
		var test_suite: GdUnitTestSuite = script.new()
		scanner._parse_and_add_test_cases(test_suite, script, test_names)
		_apply_test_attribute_index(test_suite, tests_by_suite)
		await execute(test_suite)


func _apply_test_attribute_index(test_suite: Node, tests: Array[GdUnitTestCase]) -> void:
	# We need to group first all parameterized tests together
	var grouped_by_test := GdArrayTools.group_by(tests, func(test: GdUnitTestCase) -> String:
		return test.test_name
	)
	# If a single parameterized test exists we need to assign the attribute index to the test case
	for test_name: String in grouped_by_test.keys():
		var t: Array = grouped_by_test[test_name]
		if t.size() > 1:
			continue
		var test: GdUnitTestCase = t[0]
		var test_case: _TestCase = test_suite.find_child(test_name, false, false)
		if test_case:
			test_case.set_test_parameter_index(test.attribute_index)


func fail_fast(enabled :bool) -> void:
	_executeStage.fail_fast(enabled)
