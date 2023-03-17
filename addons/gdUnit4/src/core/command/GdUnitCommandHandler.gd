@tool
class_name GdUnitCommandHandler
extends RefCounted

signal gdunit_runner_start()
signal gdunit_runner_stop(client_id :int)

var _editor_interface :EditorInterface
# the current test runner config
var _runner_config := GdUnitRunnerConfig.new()

# holds the current connected gdUnit runner client id
var _client_id :int
# if no debug mode we have an process id
var _current_runner_process_id :int = 0
# hold is current an test running
var _is_running :bool = false
# holds if the current running tests started in debug mode
var _running_debug_mode :bool


static func instance() -> GdUnitCommandHandler:
	return GdUnitSingleton.instance("GdUnitCommandHandler", func(): return GdUnitCommandHandler.new())


func _init():
	if Engine.is_editor_hint():
		_editor_interface = Engine.get_meta("GdUnitEditorPlugin").get_editor_interface()
	GdUnitSignals.instance().gdunit_event.connect(_on_event)
	GdUnitSignals.instance().gdunit_client_connected.connect(_on_client_connected)
	GdUnitSignals.instance().gdunit_client_disconnected.connect(_on_client_disconnected)
	# preload previous test execution
	_runner_config.load_config()


func _do_process() -> void:
	_check_test_run_stopped_manually()


# is checking if the user has press the editor stop scene
func _check_test_run_stopped_manually():
	if _is_test_running_but_stop_pressed():
		if GdUnitSettings.is_verbose_assert_warnings():
			push_warning("Test Runner scene was stopped manually, force stopping the current test run!")
		cmd_stop(_client_id)


func _is_test_running_but_stop_pressed():
	return _editor_interface and _running_debug_mode and _is_running and not _editor_interface.is_playing_scene()


func cmd_run_test_suites(test_suite_paths :PackedStringArray, debug :bool, rerun := false) -> void:
	# create new runner runner_config for fresh run otherwise use saved one
	if not rerun:
		var result := _runner_config.clear()\
			.add_test_suites(test_suite_paths)\
			.save_config()
		if result.is_error():
			push_error(result.error_message())
			return
	cmd_run(debug)


func cmd_run_test_case(test_suite_resource_path :String, test_case :String, test_param_index :int, debug :bool, rerun := false) -> void:
	# create new runner config for fresh run otherwise use saved one
	if not rerun:
		var result := _runner_config.clear()\
			.add_test_case(test_suite_resource_path, test_case, test_param_index)\
			.save_config()
		if result.is_error():
			push_error(result.error_message())
			return
	cmd_run(debug)


func cmd_run_overall(debug :bool) -> void:
	var test_suite_paths :PackedStringArray = GdUnitCommandHandler.scan_test_directorys("res://", [])
	prints("Run overall", test_suite_paths)
	# create new runner runner_config for fresh run otherwise use saved one
	var result := _runner_config.clear()\
		.add_test_suites(test_suite_paths)\
		.save_config()
	if result.is_error():
		push_error(result.error_message())
		return
	cmd_run(debug)


func cmd_run(debug :bool) -> void:
	# don't start is already running
	if _is_running:
		return
	# save current selected excution config
	var result := _runner_config.set_server_port(Engine.get_meta("gdunit_server_port")).save_config()
	if result.is_error():
		push_error(result.error_message())
		return
	# before start we have to save all changes
	ScriptEditorControls.save_all_open_script()
	gdunit_runner_start.emit()
	_is_running = true
	_current_runner_process_id = -1
	_running_debug_mode = debug
	if debug:
		run_debug_mode()
	else:
		run_release_mode()


func cmd_stop(client_id :int) -> void:
	# don't stop if is already stopped
	if not _is_running:
		return
	_is_running = false
	gdunit_runner_stop.emit(client_id)
	if _running_debug_mode:
		_editor_interface.stop_playing_scene()
	else: if _current_runner_process_id > 0:
		var result = OS.kill(_current_runner_process_id)
		if result != OK:
			push_error("ERROR checked stopping GdUnit Test Runner. error code: %s" % result)
	_current_runner_process_id = -1


static func scan_test_directorys(base_directory :String, test_suite_paths :PackedStringArray) -> PackedStringArray:
	prints("Scannning for test directories", base_directory)
	for directory in DirAccess.get_directories_at(base_directory):
		if directory.begins_with("."):
			continue
		var current_directory := base_directory + "/" + directory
		if directory == "test":
			prints(".. ", current_directory)
			test_suite_paths.append(current_directory)
		else:
			scan_test_directorys(current_directory, test_suite_paths)
	return test_suite_paths


func run_debug_mode():
	_editor_interface.play_custom_scene("res://addons/gdUnit4/src/core/GdUnitRunner.tscn")


func run_release_mode():
	var arguments := Array()
	if OS.is_stdout_verbose():
		arguments.append("--verbose")
	arguments.append("--no-window")
	arguments.append("--path")
	arguments.append(ProjectSettings.globalize_path("res://"))
	arguments.append("res://addons/gdUnit4/src/core/GdUnitRunner.tscn")
	_current_runner_process_id = OS.create_process(OS.get_executable_path(), arguments, false);


################################################################################
# signals handles
################################################################################
func _on_event(event :GdUnitEvent):
	if event.type() == GdUnitEvent.STOP:
		cmd_stop(_client_id)


func _on_stop_pressed():
	cmd_stop(_client_id)


func _on_run_pressed(debug := false):
	cmd_run(debug)


func _on_run_overall_pressed(_debug := false):
	cmd_run_overall(true)


################################################################################
# Network stuff
################################################################################
func _on_client_connected(client_id :int) -> void:
	_client_id = client_id


func _on_client_disconnected(client_id :int) -> void:
	# only stops is not in debug mode running and the current client
	if not _running_debug_mode and _client_id == client_id:
		cmd_stop(client_id)
	_client_id = -1
