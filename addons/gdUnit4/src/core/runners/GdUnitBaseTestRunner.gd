extends Node
## The base test runner implementation.[br]
## [br]
## This class provides the core functionality to execute test suites with following features:[br]
## - Loading and initialization of test suites[br]
## - Executing test suites and managing test states[br]
## - Event dispatching and test reporting[br]
## - Support for headless mode[br]
## - Plugin version verification[br]
## [br]
## Supported by specialized runners:[br]
## - [b]GdUnitTestRunner[/b]: Used in the editor, connects via tcp to report test results[br]
## - [b]GdUnitCLRunner[/b]: A command line interface runner, writes test reports to file[br]
## The test runner runs checked default in fail-fast mode, it stops checked first test failure.

## Overall test run status codes used by the runners
const RETURN_SUCCESS = 0
const RETURN_ERROR = 100
const RETURN_ERROR_HEADLESS_NOT_SUPPORTED = 103
const RETURN_ERROR_GODOT_VERSION_NOT_SUPPORTED = 104
const RETURN_WARNING = 101

## Specifies the Node name under which the runner is registered
const GDUNIT_RUNNER = "GdUnitRunner"
## The maximum number of report history files to store
const DEFAULT_REPORT_COUNT = 20

## The current runner configuration
@warning_ignore("unused_private_class_variable")
var _runner_config := GdUnitRunnerConfig.new()

## The test suite executor instance
var _executor: GdUnitTestSuiteExecutor
var _cs_executor: RefCounted

## Current runner state
var _state := READY

## Current test suites to be processed
var _test_suites_to_process: Array[Node] = []

## Runner state machine
enum {
	READY,
	INIT,
	RUN,
	STOP,
	EXIT
}


func _init() -> void:
	# minimize scene window checked debug mode
	if OS.get_cmdline_args().size() == 1:
		DisplayServer.window_set_title("GdUnit4 Runner (Debug Mode)")
	else:
		DisplayServer.window_set_title("GdUnit4 Runner (Release Mode)")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	# store current runner instance to engine meta data to can be access in as a singleton
	Engine.set_meta(GDUNIT_RUNNER, self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.get_version_info().hex < 0x40300:
		printerr("The GdUnit4 plugin requires Godot version 4.3 or higher to run.")
		quit(RETURN_ERROR_GODOT_VERSION_NOT_SUPPORTED)
		return
	_executor = GdUnitTestSuiteExecutor.new()
	_cs_executor = GdUnit4CSharpApiLoader.create_executor(self)

	GdUnitSignals.instance().gdunit_event.connect(_on_gdunit_event)
	_state = INIT


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		Engine.remove_meta(GDUNIT_RUNNER)


## Main test runner loop. Is called every frame to manage the test execution.
func _process(_delta: float) -> void:
	match _state:
		INIT:
			init_runner()
		RUN:
			# all test suites executed
			if _test_suites_to_process.is_empty():
				_state = STOP
			else:
				# process next test suite
				set_process(false)
				var test_suite :Node = _test_suites_to_process.pop_front()
				@warning_ignore("unsafe_method_access")
				if _cs_executor != null and _cs_executor.IsExecutable(test_suite):
					@warning_ignore("unsafe_method_access")
					_cs_executor.Execute(test_suite)
					@warning_ignore("unsafe_property_access")
					await _cs_executor.ExecutionCompleted
				else:
					await _executor.execute(test_suite as GdUnitTestSuite)
				set_process(true)
		STOP:
			_state = EXIT
			# give the engine small amount time to finish the rpc
			_on_gdunit_event(GdUnitStop.new())
			await get_tree().create_timer(0.1).timeout
			await quit(get_exit_code())


## Used by the inheriting runners to initialize test execution
func init_runner() -> void:
	pass


## Returns the exit code when the test run is finished.[br]
## Abstract method to be implemented by the inheriting runners.
func get_exit_code() -> int:
	return RETURN_SUCCESS


## Quits the test runner with given exit code.
func quit(code: int) -> void:
	await get_tree().process_frame
	await get_tree().physics_frame
	get_tree().quit(code)


## Loads all test suites based on configured criteria.
func load_test_suites(config: GdUnitRunnerConfig) -> Array[Node]:
	var test_suites_to_process: Array[Node] = []
	# Dictionary[String, Dictionary[String, PackedStringArray]]
	var to_execute := config.to_execute()
	if to_execute.is_empty():
		prints("No tests selected to execute!")
		_state = EXIT
		return []

	# scan for the requested test suites
	var ts_scanner := GdUnitTestSuiteScanner.new()
	for as_resource_path in to_execute.keys() as Array[String]:
		var selected_tests: PackedStringArray = to_execute.get(as_resource_path)
		var scanned_suites := ts_scanner.scan(as_resource_path)
		skip_test_case(scanned_suites, selected_tests)
		test_suites_to_process.append_array(scanned_suites)
	skip_suites(test_suites_to_process, config)
	return test_suites_to_process


## Removes all not selected test cases from test suites.
func skip_test_case(test_suites: Array[Node], test_case_names: Array[String]) -> void:
	if test_case_names.is_empty():
		return
	for test_suite in test_suites:
		for test_case in test_suite.get_children():
			if not test_case_names.has(test_case.get_name()):
				test_suite.remove_child(test_case)
				test_case.free()


## Skips test suites configured to be excluded from test execution.[br]
## Excludes test suites defined in skip configuration.
func skip_suites(test_suites: Array[Node], config: GdUnitRunnerConfig) -> void:
	var skipped := config.skipped()
	if skipped.is_empty():
		return

	for test_suite in test_suites:
		# skipp c# testsuites for now
		if test_suite.get_script() == null:
			continue
		skip_suite(test_suite, skipped)


# Dictionary[String, PackedStringArray]
func skip_suite(test_suite: Node, skipped: Dictionary) -> void:
	var skipped_suites: Array = skipped.keys()
	var suite_name := test_suite.get_name()
	var test_suite_path: String = (
		test_suite.get_meta("ResourcePath") if test_suite.get_script() == null
		else test_suite.get_script().resource_path
	)
	for suite_to_skip: String in skipped_suites:
		# if suite skipped by path or name
		if (
			suite_to_skip == test_suite_path
			or (suite_to_skip.is_valid_filename() and suite_to_skip == suite_name)
		):
			var skipped_tests: PackedStringArray = skipped.get(suite_to_skip)
			var skip_reason := "Excluded by configuration"
			# if no tests skipped test the complete suite is skipped
			if skipped_tests.is_empty():
				prints_warning("Mark the entire test suite '%s' as skipped!" % test_suite_path)
				@warning_ignore("unsafe_property_access")
				test_suite.__is_skipped = true
				@warning_ignore("unsafe_property_access")
				test_suite.__skip_reason = skip_reason
			else:
				# skip tests
				for test_to_skip in skipped_tests:
					var test_case: _TestCase = test_suite.find_child(test_to_skip, true, false)
					if test_case:
						test_case.skip(true, skip_reason)
						prints_warning("Mark test case '%s':%s as skipped" % [suite_to_skip, test_to_skip])
					else:
						printerr(
							"Can't skip test '%s' checked test suite '%s', no test with given name exists!"
							% [test_to_skip, suite_to_skip]
						)


func prints_warning(message: String) -> void:
	prints(message)


## Default event handler to process test events.[br]
## Should be overridden by concrete runner implementation.
@warning_ignore("unused_parameter")
func _on_gdunit_event(event: GdUnitEvent) -> void:
	pass


## Event bridge from C# GdUnit4.ITestEventListener.cs[br]
## Used to handle test events from C# tests.
# gdlint: disable=function-name
func PublishEvent(data: Dictionary) -> void:
	_on_gdunit_event(GdUnitEvent.new().deserialize(data))
