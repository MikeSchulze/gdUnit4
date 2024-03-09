class_name _TestCase
extends Node

signal completed()

# default timeout 5min
const DEFAULT_TIMEOUT := -1
const ARGUMENT_TIMEOUT := "timeout"
const ARGUMENT_SKIP := "do_skip"
const ARGUMENT_SKIP_REASON := "skip_reason"

var _iterations: int = 1
var _current_iteration :int = -1
var _seed: int
var _fuzzers: Array[GdFunctionArgument] = []
var _test_param_index := -1
var _line_number: int = -1
var _script_path: String
var _skipped := false
var _skip_reason := ""
var _expect_to_interupt := false
var _timer : Timer
var _interupted :bool = false
var _failed := false
var _report :GdUnitReport = null
var _fd :GdFunctionDescriptor
var _test_case_names := PackedStringArray()


var timeout : int = DEFAULT_TIMEOUT:
	set (value):
		timeout = value
	get:
		if timeout == DEFAULT_TIMEOUT:
			timeout = GdUnitSettings.test_timeout()
		return timeout


@warning_ignore("shadowed_variable_base_class")
func configure(p_name: String, p_line_number: int, p_script_path: String, p_timeout :int = DEFAULT_TIMEOUT, p_fuzzers :Array[GdFunctionArgument] = [], p_iterations: int = 1, p_seed :int = -1) -> _TestCase:
	set_name(p_name)
	_line_number = p_line_number
	_fuzzers = p_fuzzers
	_iterations = p_iterations
	_seed = p_seed
	_script_path = p_script_path
	timeout = p_timeout
	return self


func execute(p_test_parameter := Array(), p_iteration := 0):
	_failure_received(false)
	_current_iteration = p_iteration - 1
	if _current_iteration == -1:
		_set_failure_handler()
		set_timeout()
	if not p_test_parameter.is_empty():
		update_fuzzers(p_test_parameter, p_iteration)
		_execute_test_case(name, p_test_parameter) 
	else:
		_execute_test_case(name, [])
	await completed


func execute_paramaterized(p_test_parameter :Array):
	_failure_received(false)
	set_timeout()
	_execute_test_case(name, p_test_parameter)
	await completed


var _is_disposed := false

func dispose():
	if _is_disposed:
		return
	_is_disposed = true
	Engine.remove_meta("GD_TEST_FAILURE")
	stop_timer()
	_remove_failure_handler()
	_fuzzers.clear()
	_report = null


@warning_ignore("shadowed_variable_base_class", "redundant_await")
func _execute_test_case(name :String, test_parameter :Array):
	# needs at least on await otherwise it breaks the awaiting chain
	await get_parent().callv(name, test_parameter)
	await Engine.get_main_loop().process_frame
	completed.emit()


func update_fuzzers(input_values :Array, iteration :int):
	for fuzzer in input_values:
		if fuzzer is Fuzzer:
			fuzzer._iteration_index = iteration + 1


func set_timeout():
	if is_instance_valid(_timer):
		return
	var time :float = timeout / 1000.0
	_timer = Timer.new()
	add_child(_timer)
	_timer.set_name("gdunit_test_case_timer_%d" % _timer.get_instance_id())
	_timer.timeout.connect(func do_interrupt():
		if is_fuzzed():
			_report = GdUnitReport.new().create(GdUnitReport.INTERUPTED, line_number(), GdAssertMessages.fuzzer_interuped(_current_iteration, "timedout"))
		else:
			_report = GdUnitReport.new().create(GdUnitReport.INTERUPTED, line_number(), GdAssertMessages.test_timeout(timeout))
		_interupted = true
		completed.emit()
		, CONNECT_DEFERRED)
	_timer.set_one_shot(true)
	_timer.set_wait_time(time)
	_timer.set_autostart(false)
	_timer.start()


func _set_failure_handler() -> void:
	if not GdUnitSignals.instance().gdunit_set_test_failed.is_connected(_failure_received):
		GdUnitSignals.instance().gdunit_set_test_failed.connect(_failure_received)


func _remove_failure_handler() -> void:
	if GdUnitSignals.instance().gdunit_set_test_failed.is_connected(_failure_received):
		GdUnitSignals.instance().gdunit_set_test_failed.disconnect(_failure_received)
	

func _failure_received(is_failed :bool) -> void:
	# is already failed?
	if _failed:
		return
	_failed = is_failed
	Engine.set_meta("GD_TEST_FAILURE", is_failed)


func stop_timer() :
	# finish outstanding timeouts
	if is_instance_valid(_timer):
		_timer.stop()
		_timer.call_deferred("free")
		_timer = null


func expect_to_interupt() -> void:
	_expect_to_interupt = true


func is_interupted() -> bool:
	return _interupted


func is_expect_interupted() -> bool:
	return _expect_to_interupt


func is_parameterized() -> bool:
	return _fd.is_parameterized()


func is_skipped() -> bool:
	return _skipped


func report() -> GdUnitReport:
	return _report


func skip_info() -> String:
	return _skip_reason


func line_number() -> int:
	return _line_number


func iterations() -> int:
	return _iterations


func seed_value() -> int:
	return _seed


func is_fuzzed() -> bool:
	return not _fuzzers.is_empty()


func fuzzer_arguments() -> Array[GdFunctionArgument]:
	return _fuzzers


func script_path() -> String:
	return _script_path


func ResourcePath() -> String:
	return _script_path


func generate_seed() -> void:
	if _seed != -1:
		seed(_seed)


func skip(skipped :bool, reason :String = "") -> void:
	_skipped = skipped
	_skip_reason = reason


func set_function_descriptor(fd :GdFunctionDescriptor) -> void:
	_fd = fd


func set_test_parameter_index(index :int) -> void:
	_test_param_index = index


func test_parameter_index() -> int:
	return _test_param_index


func test_case_names() -> PackedStringArray:
	if not is_parameterized():
		return _test_case_names
	# if test names already resolved?
	if not _test_case_names.is_empty():
		return _test_case_names
	# Collect test case names by iterating over the test parameters
	var parameters := GdFunctionArgument.get_parameter_set(_fd.args())
	var test_parameter_expresion := parameters.value_as_string()
	# test parameters are referenced externaly?
	if not test_parameter_expresion.begins_with("["):
		return _extract_test_names_from_expression()
	# parse the parameters and build the test names
	var regex := RegEx.new()
	var s = "(?m)\\[(\\s*|((?:.|\n)*?)\\s*)\\]"
	regex.compile(s)
	# remove start of array before parsing
	var matches = regex.search_all(test_parameter_expresion)
	if matches.size() == 0:
		push_error("Internal Error: Can't parse the parameterized test arguments!")
	for index in matches.size():
		var parameter = matches[index].get_string(0)
		# cleanup parameter by remove newlines and tabs
		parameter = parameter.replace("[\n", "").replace("\n", "").replace("\t", "")
		_test_case_names.append(_build_test_case_name(parameter, index))
	return _test_case_names


func _extract_test_names_from_expression() -> PackedStringArray:
	var parameters := GdTestParameterSet.extract_test_parameters(get_parent(), _fd)
	for index in parameters.size():
		_test_case_names.append(_build_test_case_name(str(parameters[index]), index))
	return _test_case_names


func _build_test_case_name(test_parameter :String, parameter_index :int) -> String:
	if not test_parameter.begins_with("["):
		test_parameter = "[" + test_parameter
	var test_name = "%s:%d %s" % [get_name(), parameter_index, test_parameter.replace('"', "'").replace("&'", "'")]
	if test_name.length() > 96:
		return test_name.substr(0, 96) + " ..."
	return test_name


func _to_string():
	return "%s :%d (%dms)" % [get_name(), _line_number, timeout]
