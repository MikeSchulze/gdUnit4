extends GdUnitFuncAssert

signal value_provided(value)

const GdUnitTools := preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")

const DEFAULT_TIMEOUT := 2000

var _current_value_provider :ValueProvider
var _current_error_message :String = ""
var _custom_failure_message :String = ""
var _line_number := -1
var _timeout := DEFAULT_TIMEOUT
var _interrupted := false
var _sleep_timer :Timer = null


func _init(instance :Object, func_name :String, args := Array()):
	_line_number = GdUnitAssert._get_line_number()
	GdAssertReports.reset_last_error_line_number()
	# save the actual assert instance on the current thread context
	GdUnitThreadManager.get_current_context().set_assert(self)
	# verify at first the function name exists
	if not instance.has_method(func_name):
		report_error("The function '%s' do not exists checked instance '%s'." % [func_name, instance])
		_interrupted = true
	else:
		_current_value_provider = CallBackValueProvider.new(instance, func_name, args)


func _notification(_what):
	if is_instance_valid(self):
		dispose()


func report_success() -> GdUnitFuncAssert:
	GdAssertReports.report_success()
	return self


func report_error(error_message :String) -> GdUnitFuncAssert:
	_current_error_message = error_message if _custom_failure_message == "" else _custom_failure_message
	GdAssertReports.report_error(_current_error_message, _line_number)
	return self


func _failure_message() -> String:
	return _current_error_message


func send_report(report :GdUnitReport)-> void:
	GdUnitSignals.instance().gdunit_report.emit(report)


func override_failure_message(message :String) -> GdUnitFuncAssert:
	_custom_failure_message = message
	return self


func wait_until(timeout := 2000) -> GdUnitFuncAssert:
	if timeout <= 0:
		push_warning("Invalid timeout param, alloed timeouts must be grater than 0. Use default timeout instead")
		_timeout = DEFAULT_TIMEOUT
	else:
		_timeout = timeout
	return self


func is_null() -> GdUnitFuncAssert:
	return await _validate_callback(__is_null)


func is_not_null() -> GdUnitFuncAssert:
	return await _validate_callback(__is_not_null)


func is_false() -> GdUnitFuncAssert:
	return await _validate_callback(__is_false)


func is_true() -> GdUnitFuncAssert:
	return await _validate_callback(__is_true)


func is_equal(expected) -> GdUnitFuncAssert:
	return await _validate_callback(__is_equal, expected)


func is_not_equal(expected) -> GdUnitFuncAssert:
	return await _validate_callback(__is_not_equal, expected)

# we need actually to define this Callable as functions otherwise we results into leaked scripts here
# this is actually a Godot bug and needs this kind of workaround
func __is_null(c, _e): return c == null
func __is_not_null(c, _e): return c != null
func __is_false(c, _e): return c == false
func __is_true(c, _e): return c == true
func __is_equal(c, e): return GdObjects.equals(c,e)
func __is_not_equal(c, e): return not GdObjects.equals(c, e)


func ___validate_callback(predicate :Callable, expected = null):
	prints("##############################")
	var time_scale = Engine.get_time_scale()
	var timer := Timer.new()
	timer.set_name("gdunit_funcassert_interrupt_timer_%d" % timer.get_instance_id())
	Engine.get_main_loop().root.add_child(timer)
	timer.add_to_group("GdUnitTimers")
	timer.timeout.connect(func do_interrupt():
		_interrupted = true
		timer.free()
		, CONNECT_DEFERRED)
	timer.set_one_shot(true)
	timer.start((_timeout/1000.0)*time_scale)
	
	while true:
		await Engine.get_main_loop().process_frame
		var current = await next_current_value()
		if _interrupted or predicate.call(current, expected):
			break
	

func _validate_callback(predicate :Callable, expected = null) -> GdUnitFuncAssert:
	if _interrupted:
		return self
	var time_scale = Engine.get_time_scale()
	var timer := Timer.new()
	timer.set_name("gdunit_funcassert_interrupt_timer_%d" % timer.get_instance_id())
	Engine.get_main_loop().root.add_child(timer)
	timer.add_to_group("GdUnitTimers")
	timer.timeout.connect(func do_interrupt():
		_interrupted = true
		timer.free()
		, CONNECT_DEFERRED)
	timer.set_one_shot(true)
	timer.start((_timeout/1000.0)*time_scale)
	_sleep_timer = Timer.new()
	_sleep_timer.set_name("gdunit_funcassert_sleep_timer_%d" % _sleep_timer.get_instance_id() )
	Engine.get_main_loop().root.add_child(_sleep_timer)
	
	while true:
		var current = await next_current_value()
		# is interupted or predicate success
		if _interrupted or predicate.call(current, expected):
			break
		if is_instance_valid(_sleep_timer):
			_sleep_timer.start(0.05)
			await _sleep_timer.timeout
	
	_sleep_timer.stop()
	await Engine.get_main_loop().process_frame
	dispose()
	if _interrupted:
		# https://github.com/godotengine/godot/issues/73052
		#var predicate_name = predicate.get_method()
		var predicate_name :String = str(predicate).split('::')[1]
		report_error(GdAssertMessages.error_interrupted(predicate_name.strip_edges().trim_prefix("__"), expected, LocalTime.elapsed(_timeout)))
	else:
		report_success()
	return self


func next_current_value() -> Variant:
	@warning_ignore("redundant_await")
	if is_instance_valid(_current_value_provider):
		return await _current_value_provider.get_value()
	return "invalid value"


var _is_disposed := false

# it is important to free all references/connections to prevent orphan nodes
func dispose():
	if _is_disposed:
		return
	_is_disposed = true
	GdUnitTools._release_connections(self)
	if is_instance_valid(_current_value_provider):
		_current_value_provider.dispose()
		_current_value_provider = null
	if is_instance_valid(_sleep_timer):
		_sleep_timer.stop()
		_sleep_timer.free()
		_sleep_timer = null
	
	# finally do this very hacky stuff
	# we need to manually unreferece to avoid leaked scripts
	# but still leaked GDScriptFunctionState exists
	unreference()
