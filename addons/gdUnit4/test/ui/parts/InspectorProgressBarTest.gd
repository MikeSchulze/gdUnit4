extends GdUnitTestSuite


var _runner: GdUnitSceneRunner
var _progress: ProgressBar
var _status: Label
var _style: StyleBoxFlat


func before_test() -> void:
	_runner = scene_runner('res://addons/gdUnit4/src/ui/parts/InspectorProgressBar.tscn')
	_progress = _runner.scene()
	_status = _runner.get_property("status")
	_style = _runner.get_property("style")


func test_progress_init() -> void:
	assert_that(_progress.value).is_equal(0.000000)
	assert_that(_progress.max_value).is_equal(0.000000)
	assert_that(_status.text).is_equal("0:0")


func test_progress_update_by_discovery() -> void:
	# verify the InspectorProgressBar is connected to gdunit_test_discovered signal
	assert_bool(GdUnitSignals.instance().gdunit_test_discovered.is_connected(_progress.on_test_case_discovered))\
		.override_failure_message("The 'InspectorProgressBar' must be connected to signal 'gdunit_test_discovered'")\
		.is_true()

	var test_a := GdUnitTestCase.new()
	test_a.guid = GdUnitGUID.new()
	test_a.test_name = "test_a"

	# using the sink to update the
	@warning_ignore("unsafe_method_access")
	_progress.on_test_case_discovered(test_a)
	assert_that(_progress.value).is_equal(0.000000)
	assert_that(_progress.max_value).is_equal(1.000000)
	assert_that(_status.text).is_equal("0:1")
	assert_that(_style.bg_color).is_equal(Color.DARK_GREEN)

	# Just discover 10 more tests
	for n in 10:
		var test := GdUnitTestCase.new()
		test.guid = GdUnitGUID.new()
		test.test_name = "test_%d" % n
		@warning_ignore("unsafe_method_access")
		_progress.on_test_case_discovered(test)
	assert_that(_progress.value).is_equal(0.000000)
	assert_that(_progress.max_value).is_equal(11.000000)
	assert_that(_status.text).is_equal("0:11")
	assert_that(_style.bg_color).is_equal(Color.DARK_GREEN)


## @deprecated
func test_progress_init_old() -> void:
	_runner.invoke("_on_gdunit_event", GdUnitInit.new(10, 230))
	assert_that(_progress.value).is_equal(0.000000)
	assert_that(_progress.max_value).is_equal(230.000000)
	assert_that(_status.text).is_equal("0:230")
	assert_that(_style.bg_color).is_equal(Color.DARK_GREEN)


func test_progress_success() -> void:
	_runner.invoke("_on_gdunit_event", GdUnitInit.new(10, 42))
	var expected_progess_index :float = 0
	# simulate execution of 20 success test runs
	for index in 20:
		_runner.invoke("_on_gdunit_event", GdUnitEvent.new().test_statistics("res://test/testA.gd", "TestSuiteA", "test_a%d" % index, {}))
		expected_progess_index += 1
		assert_that(_progress.value).is_equal(expected_progess_index)
		assert_that(_status.text).is_equal("%d:42" % expected_progess_index)
		assert_that(_style.bg_color).is_equal(Color.DARK_GREEN)

	# simulate execution of parameterized test with 10 iterations
	for index in 10:
		_runner.invoke("_on_gdunit_event", GdUnitEvent.new().test_after("res://test/testA.gd", "TestSuiteA", "test_parameterized:%d (params)" % index, {}))
		assert_that(_progress.value).is_equal(expected_progess_index)
	# final test end event
	_runner.invoke("_on_gdunit_event", GdUnitEvent.new().test_statistics("res://test/testA.gd", "TestSuiteA", "test_parameterized", {}))
	# we expect only one progress step after a parameterized test has been executed, regardless of the iterations
	expected_progess_index += 1
	assert_that(_progress.value).is_equal(expected_progess_index)
	assert_that(_status.text).is_equal("%d:42" % expected_progess_index)
	assert_that(_style.bg_color).is_equal(Color.DARK_GREEN)

	# verify the max progress state is not affected
	assert_that(_progress.max_value).is_equal(42.000000)


@warning_ignore("unused_parameter")
func test_progress_failed(test_name :String, is_failed :bool, is_error :bool, expected_color :Color, test_parameters := [
	["test_a", false, false, Color.DARK_GREEN],
	["test_b", false, false, Color.DARK_GREEN],
	["test_c", false, false, Color.DARK_GREEN],
	["test_d", true, false, Color.DARK_RED],
	["test_e", true, false, Color.DARK_RED],
]) -> void:
	var statistics := {
		GdUnitEvent.ORPHAN_NODES: 0,
		GdUnitEvent.ELAPSED_TIME: 100,
		GdUnitEvent.WARNINGS: false,
		GdUnitEvent.ERRORS: is_error,
		GdUnitEvent.ERROR_COUNT:  1 if is_error else 0,
		GdUnitEvent.FAILED: is_failed,
		GdUnitEvent.FAILED_COUNT: 1 if is_failed else 0,
		GdUnitEvent.SKIPPED: false,
		GdUnitEvent.SKIPPED_COUNT: 0,
	}

	_runner.invoke("_on_gdunit_event", GdUnitEvent.new().test_statistics("res://test/testA.gd", "TestSuiteA", test_name, statistics))
	assert_that(_style.bg_color).is_equal(expected_color)
