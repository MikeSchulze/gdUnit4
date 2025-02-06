#warning-ignore-all:return_value_discarded
class_name GdUnitTestCLRunner
extends "res://addons/gdUnit4/src/core/runners/GdUnitBaseTestRunner.gd"
## Command line test runner implementation.[br]
## [br]
## This runner is designed for CI/CD pipelines and command line test execution.[br]
## Features:[br]
## - Command line options for test configuration[br]
## - HTML and JUnit report generation[br]
## - Console output with colored formatting[br]
## - Progress and error reporting[br]
## - Test history management[br]
## [br]
## Example usage:[br]
## [codeblock]
## # Run all tests in a directory
## runtest -a <directory>
##
## # Run specific test suite with ignored tests
## runtest -a <directory> -i <testsuite:test_name>
## [/codeblock]

const GdUnitTools := preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")

## HTML report writer instance
var _report: GdUnitHtmlReport
var _console := GdUnitCSIMessageWriter.new()
var _test_reporter: GdUnitTestResultReporter
var _report_dir: String
var _report_max: int = DEFAULT_REPORT_COUNT
var _headless_mode_ignore := false
var _runner_config_file := ""
var _debug_cmd_args: = PackedStringArray()

## Command line options configuration
var _cmd_options := CmdOptions.new([
		CmdOption.new(
			"-a, --add",
			"-a <directory|path of testsuite>",
			"Adds the given test suite or directory to the execution pipeline.",
			TYPE_STRING
		),
		CmdOption.new(
			"-i, --ignore",
			"-i <testsuite_name|testsuite_name:test-name>",
			"Adds the given test suite or test case to the ignore list.",
			TYPE_STRING
		),
		CmdOption.new(
				"-c, --continue",
				"",
				"""By default GdUnit will abort checked first test failure to be fail fast,
				instead of stop after first failure you can use this option to run the complete test set.""".dedent()
		),
		CmdOption.new(
			"-conf, --config",
			"-conf [testconfiguration.cfg]",
			"Run all tests by given test configuration. Default is 'GdUnitRunner.cfg'",
			TYPE_STRING,
			true
		),
		CmdOption.new(
			"-help", "",
			"Shows this help message."
		),
		CmdOption.new("--help-advanced", "",
			"Shows advanced options."
		)
	],
	[
		# advanced options
		CmdOption.new(
			"-rd, --report-directory",
			"-rd <directory>",
			"Specifies the output directory in which the reports are to be written. The default is res://reports/.",
			TYPE_STRING,
			true
		),
		CmdOption.new(
			"-rc, --report-count",
			"-rc <count>",
			"Specifies how many reports are saved before they are deleted. The default is %s." % str(DEFAULT_REPORT_COUNT),
			TYPE_INT,
			true
		),
		#CmdOption.new("--list-suites", "--list-suites [directory]", "Lists all test suites located in the given directory.", TYPE_STRING),
		#CmdOption.new("--describe-suite", "--describe-suite <suite name>", "Shows the description of selected test suite.", TYPE_STRING),
		CmdOption.new(
			"--info", "",
			"Shows the GdUnit version info"
		),
		CmdOption.new(
			"--selftest", "",
			"Runs the GdUnit self test"
		),
		CmdOption.new(
			"--ignoreHeadlessMode",
			"--ignoreHeadlessMode",
			"By default, running GdUnit4 in headless mode is not allowed. You can switch off the headless mode check by set this property."
		),
	])


func _init() -> void:
	super()


func _ready() -> void:
	super()
	_test_reporter = GdUnitTestResultReporter.new(_console, true)
	_report_dir = GdUnitFileAccess.current_dir() + "reports"
	# stop checked first test failure to fail fast
	_executor.fail_fast(true)


func _notification(what: int) -> void:
	super(what)
	if what == NOTIFICATION_PREDELETE:
		prints("Finallize .. done")


func init_runner() -> void:
	init_gd_unit()


## Returns the exit code based on test results.[br]
## Maps test report status to process exit codes.
func get_exit_code() -> int:
	return report_exit_code(_report)


## Cleanup and quit the runner.[br]
## [br]
## [param code] The exit code to return.
func quit(code: int) -> void:
	if code != RETURN_SUCCESS:
		_state = EXIT
	_cs_executor = null
	GdUnitTools.dispose_all()
	await GdUnitMemoryObserver.gc_on_guarded_instances()
	await super(code)


## Prints info message to console.[br]
## [br]
## [param message] The message to print.[br]
## [param color] Optional color for the message.
func console_info(message: String, color: Color = Color.WHITE) -> void:
	_console.color(color).println_message(message)


## Prints error message to console.[br]
## [br]
## [param message] The error message to print.
func console_error(message: String) -> void:
	_console.prints_error(message)


## Prints warning message to console.[br]
## [br]
## [param message] The warning message to print.
func console_warning(message: String) -> void:
	_console.prints_warning(message)


## Sets the directory for test reports.[br]
## [br]
## [param path] The path where reports should be written.
func set_report_dir(path: String) -> void:
	_report_dir = ProjectSettings.globalize_path(GdUnitFileAccess.make_qualified_path(path))
	console_info(
		"Set write reports to %s" % _report_dir,
		Color.DEEP_SKY_BLUE
	)


## Sets how many report files to keep.[br]
## [br]
## [param count] The number of reports to keep.
func set_report_count(count: String) -> void:
	var report_count := count.to_int()
	if report_count < 1:
		console_error(
			"Invalid report history count '%s' set back to default %d"
			% [count, DEFAULT_REPORT_COUNT]
		)
		_report_max = DEFAULT_REPORT_COUNT
	else:
		console_info(
			"Set report history count to %s" % count,
			Color.DEEP_SKY_BLUE
		)
		_report_max = report_count


## Disables fail-fast mode to run all tests.[br]
## By default tests stop on first failure.
func disable_fail_fast() -> void:
	console_info(
		"Disabled fail fast!",
		Color.DEEP_SKY_BLUE
	)
	@warning_ignore("unsafe_method_access")
	_executor.fail_fast(false)


func run_self_test() -> void:
	console_info(
		"Run GdUnit4 self tests.",
		Color.DEEP_SKY_BLUE
	)
	disable_fail_fast()
	_runner_config.self_test()


## Shows GdUnit and Godot version information.
func show_version() -> void:
	console_info(
		"Godot %s" % Engine.get_version_info().get("string") as String,
		Color.DARK_SALMON
	)
	var config := ConfigFile.new()
	config.load("addons/gdUnit4/plugin.cfg")
	console_info(
		"GdUnit4 %s" % config.get_value("plugin", "version") as String,
		Color.DARK_SALMON
	)
	quit(RETURN_SUCCESS)


## Ignores headless mode restrictions.[br]
## Allows tests to run in headless mode despite limitations.
func check_headless_mode() -> void:
	_headless_mode_ignore = true


## Shows available command line options.[br]
## [br]
## [param show_advanced] Whether to show advanced options.
func show_options(show_advanced: bool = false) -> void:
	console_info(
		"""
		Usage:
			runtest -a <directory|path of testsuite>
			runtest -a <directory> -i <path of testsuite|testsuite_name|testsuite_name:test_name>
			""".dedent(),
		Color.DARK_SALMON
	)
	console_info(
		"-- Options ---------------------------------------------------------------------------------------",
		Color.DARK_SALMON
	)
	for option in _cmd_options.default_options():
		descripe_option(option)
	if show_advanced:
		console_info(
			"-- Advanced options --------------------------------------------------------------------------",
			Color.DARK_SALMON
		)
		for option in _cmd_options.advanced_options():
			descripe_option(option)


## Describes a single command line option.[br]
## [br]
## [param cmd_option] The option to describe.
func descripe_option(cmd_option: CmdOption) -> void:
	console_info(
		"  %-40s" % str(cmd_option.commands()),
		Color.CORNFLOWER_BLUE
	)
	console_info(
		cmd_option.description(),
		Color.LIGHT_GREEN
	)
	if not cmd_option.help().is_empty():
		console_info(
			"%-4s %s" % ["", cmd_option.help()],
			Color.DARK_TURQUOISE
		)
	console_info("")


## Loads test configuration from file.[br]
## [br]
## [param path] Path to the configuration file.
func load_test_config(path := GdUnitRunnerConfig.CONFIG_FILE) -> void:
	console_info(
		"Loading test configuration %s\n" % path,
		Color.CORNFLOWER_BLUE
	)
	_runner_config_file = path
	_runner_config.load_config(path)


## Shows basic help and exits.
func show_help() -> void:
	show_options()
	quit(RETURN_SUCCESS)


## Shows advanced help and exits.
func show_advanced_help() -> void:
	show_options(true)
	quit(RETURN_SUCCESS)


## Gets command line arguments.[br]
## Returns debug args if set, otherwise actual command line args.
func get_cmdline_args() -> PackedStringArray:
	if _debug_cmd_args.is_empty():
		return OS.get_cmdline_args()
	return _debug_cmd_args


## Initializes the test runner and processes command line arguments.
func init_gd_unit() -> void:
	console_info(
		"""
		--------------------------------------------------------------------------------------------------
		GdUnit4 Comandline Tool
		--------------------------------------------------------------------------------------------------""".dedent(),
		Color.DARK_SALMON
	)

	var cmd_parser := CmdArgumentParser.new(_cmd_options, "GdUnitCmdTool.gd")
	var result := cmd_parser.parse(get_cmdline_args())
	if result.is_error():
		console_error(result.error_message())
		show_options()
		console_error("Abnormal exit with %d" % RETURN_ERROR)
		quit(RETURN_ERROR)
		return
	if result.is_empty():
		show_help()
		return
	# build runner config by given commands
	var commands :Array[CmdCommand] = []
	@warning_ignore("unsafe_cast")
	commands.append_array(result.value() as Array)
	result = (
		CmdCommandHandler.new(_cmd_options)
			.register_cb("-help", show_help)
			.register_cb("--help-advanced", show_advanced_help)
			.register_cb("-a", _runner_config.add_test_suite)
			.register_cbv("-a", _runner_config.add_test_suites)
			.register_cb("-i", _runner_config.skip_test_suite)
			.register_cbv("-i", _runner_config.skip_test_suites)
			.register_cb("-rd", set_report_dir)
			.register_cb("-rc", set_report_count)
			.register_cb("--selftest", run_self_test)
			.register_cb("-c", disable_fail_fast)
			.register_cb("-conf", load_test_config)
			.register_cb("--info", show_version)
			.register_cb("--ignoreHeadlessMode", check_headless_mode)
			.execute(commands)
	)
	if result.is_error():
		console_error(result.error_message())
		quit(RETURN_ERROR)
		return

	if DisplayServer.get_name() == "headless":
		if _headless_mode_ignore:
			console_warning("""
				Headless mode is ignored by option '--ignoreHeadlessMode'"

				Please note that tests that use UI interaction do not work correctly in headless mode.
				Godot 'InputEvents' are not transported by the Godot engine in headless mode and therefore
				have no effect in the test!
				""".dedent()
			)
		else:
			console_error("""
				Headless mode is not supported!

				Please note that tests that use UI interaction do not work correctly in headless mode.
				Godot 'InputEvents' are not transported by the Godot engine in headless mode and therefore
				have no effect in the test!

				You can run with '--ignoreHeadlessMode' to swtich off this check.
				""".dedent()
			)
			console_error(
				"Abnormal exit with %d" % RETURN_ERROR_HEADLESS_NOT_SUPPORTED
			)
			quit(RETURN_ERROR_HEADLESS_NOT_SUPPORTED)
			return

	_test_suites_to_process = load_test_suites(_runner_config)
	if _test_suites_to_process.is_empty():
		console_info("No test suites found, abort test run!", Color.YELLOW)
		console_info("Exit code: %d" % RETURN_SUCCESS, Color.DARK_SALMON)
		quit(RETURN_SUCCESS)
	_on_gdunit_event(GdUnitInit.new())
	_state = RUN


func _on_gdunit_event(event: GdUnitEvent) -> void:
	_test_reporter._on_gdunit_event(event)

	## TODO extract to HtmlReport writer
	match event.type():
		GdUnitEvent.INIT:
			_report = GdUnitHtmlReport.new(_report_dir, _report_max)
		GdUnitEvent.STOP:
			var report_path := _report.write()
			_report.delete_history(_report_max)
			JUnitXmlReport.new(_report._report_path, _report.iteration()).write(_report)
			console_info(
				"Open Report at: file://%s" % report_path,
				Color.CORNFLOWER_BLUE
			)
		GdUnitEvent.TESTSUITE_BEFORE:
			_report.add_testsuite_report(event.resource_path(), event.suite_name(), event.total_count())
		GdUnitEvent.TESTSUITE_AFTER:
			_report.add_testsuite_reports(
				event.resource_path(),
				event.error_count(),
				event.failed_count(),
				event.orphan_nodes(),
				event.elapsed_time(),
				event.reports()
			)
		GdUnitEvent.TESTCASE_BEFORE:
			_report.add_testcase(event.resource_path(), event.suite_name(), event.test_name())
		GdUnitEvent.TESTCASE_AFTER:
			_report.set_testcase_counters(event.resource_path(),
				event.test_name(),
				event.is_error(),
				event.failed_count(),
				event.orphan_nodes(),
				event.is_skipped(),
				event.is_flaky(),
				event.elapsed_time())
			_report.add_testcase_reports(event.resource_path(), event.test_name(), event.reports())


func report_exit_code(report: GdUnitHtmlReport) -> int:
	if report.error_count() + report.failure_count() > 0:
		console_info("Exit code: %d" % RETURN_ERROR, Color.FIREBRICK)
		return RETURN_ERROR
	if report.orphan_count() > 0:
		console_info("Exit code: %d" % RETURN_WARNING, Color.GOLDENROD)
		return RETURN_WARNING
	console_info("Exit code: %d" % RETURN_SUCCESS, Color.DARK_SALMON)
	return RETURN_SUCCESS
