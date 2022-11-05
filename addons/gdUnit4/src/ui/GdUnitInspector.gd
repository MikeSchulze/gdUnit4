@tool
class_name GdUnitInspecor
extends Panel


signal gdunit_runner_start()
signal gdunit_runner_stop()

#https://github.com/godotengine/godot/blob/3.2/editor/plugins/script_editor_plugin.h
enum EDITOR_ACTIONS {
		FILE_NEW,
		FILE_NEW_TEXTFILE,
		FILE_OPEN,
		FILE_REOPEN_CLOSED,
		FILE_OPEN_RECENT,
		FILE_SAVE,
		FILE_SAVE_AS,
		FILE_SAVE_ALL,
		FILE_THEME,
		FILE_RUN,
		FILE_CLOSE,
		CLOSE_DOCS,
		CLOSE_ALL,
		CLOSE_OTHER_TABS,
		TOGGLE_SCRIPTS_PANEL,
		SHOW_IN_FILE_SYSTEM,
		FILE_COPY_PATH,
		FILE_TOOL_RELOAD,
		FILE_TOOL_RELOAD_SOFT,
		DEBUG_NEXT,
		DEBUG_STEP,
		DEBUG_BREAK,
		DEBUG_CONTINUE,
		DEBUG_KEEP_DEBUGGER_OPEN,
		DEBUG_WITH_EXTERNAL_EDITOR,
		SEARCH_IN_FILES,
		SEARCH_HELP,
		SEARCH_WEBSITE,
		HELP_SEARCH_FIND,
		HELP_SEARCH_FIND_NEXT,
		HELP_SEARCH_FIND_PREVIOUS,
		WINDOW_MOVE_UP,
		WINDOW_MOVE_DOWN,
		WINDOW_NEXT,
		WINDOW_PREV,
		WINDOW_SORT,
		WINDOW_SELECT_BASE = 100
	}

const MENU_ID_TEST_RUN    := GdUnitContextMenuItem.MENU_ID.TEST_RUN
const MENU_ID_TEST_DEBUG  := GdUnitContextMenuItem.MENU_ID.TEST_DEBUG
const MENU_ID_CREATE_TEST := GdUnitContextMenuItem.MENU_ID.CREATE_TEST

# header
@onready var _runButton :Button = $VBoxContainer/Header/ToolBar/Tools/run

# hold is current an test running
var _is_running :bool = false
# holds if the current running tests started in debug mode
var _running_debug_mode :bool
# if no debug mode we have an process id
var _current_runner_process_id :int = 0

# holds the current connected gdUnit runner client id
var _client_id :int

var _editor_interface :EditorInterface

# the current test runner config
var _runner_config := GdUnitRunnerConfig.new()

func _ready():
	GdUnitSignals.gdunit_client_connected.connect(Callable(self, "_on_client_connected"))
	GdUnitSignals.gdunit_client_disconnected.connect(Callable(self, "_on_client_disconnected"))
	GdUnitSignals.gdunit_event.connect(Callable(self, "_on_event"))
	
	if Engine.is_editor_hint():
		_getEditorThemes(_editor_interface)
		add_file_system_dock_context_menu()
	# preload previous test execution
	_runner_config.load()


func _enter_tree():
	if Engine.is_editor_hint():
		add_script_editor_context_menu()


func _exit_tree():
	ScriptEditorControls.unregister_context_menu()


func _process(_delta):
	_check_test_run_stopped_manually()

# is checking if the user has press the editor stop scene 
func _check_test_run_stopped_manually():
	if _is_test_running_but_stop_pressed():
		if GdUnitSettings.is_verbose_assert_warnings():
			push_warning("Test Runner scene was stopped manually, force stopping the current test run!")
		_gdUnit_stop(_client_id)

func _is_test_running_but_stop_pressed():
	return _editor_interface and _running_debug_mode and _is_running and not _editor_interface.is_playing_scene()

func set_editor_interface(editor_interface :EditorInterface) -> void:
	_editor_interface = editor_interface

func _getEditorThemes(interface :EditorInterface) -> void:
	if interface == null:
		return
		# example to access current theme
	var editiorTheme := interface.get_base_control().theme

	# setup inspector button icons
	#var stylebox_types :PackedStringArray = editiorTheme.get_stylebox_type_list()
	#for stylebox_type in stylebox_types:
		#prints("stylebox_type", stylebox_type)
	#	if "Tree" == stylebox_type:
	#		prints(editiorTheme.get_stylebox_list(stylebox_type))
	#var style:StyleBoxFlat = editiorTheme.get_stylebox("panel", "Tree")
	#style.bg_color = Color.RED
	var locale = interface.get_editor_settings().get_setting("interface/editor/editor_language")
	#sessions_label.add_theme_color_override("font_color", get_color("contrast_color_2", "Editor"))
	#status_label.add_theme_color_override("font_color", get_color("contrast_color_2", "Editor"))
	#no_sessions_label.add_theme_color_override("font_color", get_color("contrast_color_2", "Editor"))

# Context menu registrations ----------------------------------------------------------------------
func add_file_system_dock_context_menu() -> void:
	if _editor_interface == null:
		return
	var filesystem_dock = _editor_interface.get_file_system_dock()
	var popups := GdObjects.find_nodes_by_class(filesystem_dock, "PopupMenu")
	var file_tree := GdObjects.find_nodes_by_class(filesystem_dock, "Tree", true)
	var context_menu :PopupMenu = popups[-1]
	context_menu.connect("about_to_popup", Callable(self, "_on_file_system_dock_context_menu_show").bind(context_menu))
	context_menu.connect("id_pressed", Callable(self, "_on_file_system_dock_context_menu_pressed").bind(file_tree[-1]))

func _on_file_system_dock_context_menu_show(context_menu :PopupMenu) -> void:
	context_menu.add_separator()
	# save menu entry index
	var current_index := context_menu.get_item_count()
	context_menu.add_item("Run Tests", MENU_ID_TEST_RUN)
	context_menu.add_item("Debug Tests", MENU_ID_TEST_DEBUG)
	# deactivate menu enties if currently a run in progress
	context_menu.set_item_disabled(current_index+0, _runButton.disabled)
	context_menu.set_item_disabled(current_index+1, _runButton.disabled)

func _on_file_system_dock_context_menu_pressed(id :int, file_tree :Tree) -> void:
	if id != MENU_ID_TEST_RUN && id != MENU_ID_TEST_DEBUG:
		return
	var selected_item := file_tree.get_selected()
	if selected_item == null:
		prints("no resource selected")
		return
	var selected_test_suites := Array()
	while selected_item:
		selected_test_suites.append(selected_item.get_metadata(0))
		selected_item = file_tree.get_next_selected(selected_item)
	var debug = id == MENU_ID_TEST_DEBUG
	run_test_suites(selected_test_suites, debug)


func add_script_editor_context_menu():
	var is_test_suite := func is_visible(script :GDScript, is_test_suite :bool):
		return GdObjects.is_test_suite(script) == is_test_suite
	var is_enabled := func is_enabled(script :GDScript):
		return !_runButton.disabled
	var run_test := func run_test(script :Script, text_edit :TextEdit, debug :bool):
		var cursor_line := text_edit.get_caret_line()
		#run test case?
		var regex := RegEx.new()
		regex.compile("(^func[ ,\t])(test_[a-zA-Z0-9_]*)")
		var result := regex.search(text_edit.get_line(cursor_line))
		if result:
			var func_name := result.get_string(2).strip_edges()
			prints("Run test:", func_name, "debug", debug)
			if func_name.begins_with("test_"):
				run_test_case(script.resource_path, func_name, debug)
				return
		# otherwise run the full test suite
		var selected_test_suites := [script.resource_path]
		run_test_suites(selected_test_suites, debug)
	var create_test := func create_test(script :Script, text_edit :TextEdit):
		var cursor_line := text_edit.get_caret_line()
		var result = GdUnitTestSuiteBuilder.create(script, cursor_line)
		if result.is_error():
			# show error dialog
			push_error("Failed to create test case: %s" % result.error_message())
			return
		var info := result.value() as Dictionary
		ScriptEditorControls.edit_script(info.get("path"), info.get("line"))
	
	var menu := [
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.TEST_RUN, "Run Tests", is_test_suite.bind(true), is_enabled, run_test.bind(false)),
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.TEST_DEBUG, "Debug Tests", is_test_suite.bind(true), is_enabled, run_test.bind(true)),
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.CREATE_TEST, "Create Test", is_test_suite.bind(false), is_enabled, create_test)
	]
	ScriptEditorControls.register_context_menu(menu)


func run_test_suites(test_suite_paths :Array, debug :bool, rerun :bool=false) -> void:
	# create new runner runner_config for fresh run otherwise use saved one
	if not rerun:
		var result := _runner_config.clear()\
			.add_test_suites(test_suite_paths)\
			.save()
		if result.is_error():
			push_error(result.error_message())
			return
	_gdUnit_run(debug)

func run_test_case(test_suite_resource_path :String, test_case :String, debug :bool, rerun := false) -> void:
	# create new runner config for fresh run otherwise use saved one
	if not rerun:
		var result := _runner_config.clear()\
			.add_test_case(test_suite_resource_path, test_case)\
			.save()
		if result.is_error():
			push_error(result.error_message())
			return
	_gdUnit_run(debug)


func _gdUnit_run(debug :bool) -> void:
	# don't start is already running
	if _is_running:
		return
	
	grab_focus()
	show()
	# save current selected excution config
	var result := _runner_config.set_server_port(Engine.get_meta("gdunit_server_port")).save()
	if result.is_error():
		push_error(result.error_message())
		return
	_running_debug_mode = debug
	_current_runner_process_id = -1
	# before start we have to save all changes
	ScriptEditorControls.save_all_open_script()
	# wait until all changes are saved
	await get_tree().process_frame

	gdunit_runner_start.emit()
	if debug:
		_editor_interface.play_custom_scene("res://addons/gdUnit4/src/core/GdUnitRunner.tscn")
		_is_running = true
		return
	var arguments := Array()
	arguments.append("--no-window")
	#arguments.append("-d")
	#arguments.append("-s")
	arguments.append("res://addons/gdUnit4/src/core/GdUnitRunner.tscn")
	#prints("arguments", arguments)
	var output = []
#	_running_debug_mode = false
	# prints("execute ", OS.get_executable_path(), arguments)
	_current_runner_process_id = OS.execute(OS.get_executable_path(), arguments, output, false, false);
	_is_running = true

func _gdUnit_stop(client_id :int) -> void:
	# don't stop if is already stopped
	if not _is_running:
		return
	_is_running = false
	emit_signal("gdunit_runner_stop", client_id)
	await get_tree().process_frame
	if _running_debug_mode:
		_editor_interface.stop_playing_scene()
	else: if _current_runner_process_id > 0:
		var result = OS.kill(_current_runner_process_id)
		if result != OK:
			push_error("ERROR checked stopping GdUnit Test Runner. error code: %s" % result)
	_current_runner_process_id = -1


################################################################################
# Event signal receiver
################################################################################
func _on_event(event :GdUnitEvent):
	if event.type() == GdUnitEvent.STOP:
		_gdUnit_stop(_client_id)

################################################################################
# Inspector signal receiver
################################################################################
func _on_ToolBar_run_pressed(debug :bool = false):
	_gdUnit_run(debug)

func _on_ToolBar_stop_pressed():
	_gdUnit_stop(_client_id)

func _on_MainPanel_run_testsuite(test_suite_paths :Array, debug :bool):
	run_test_suites(test_suite_paths, debug)

func _on_MainPanel_run_testcase(resource_path :String, test_case :String, debug :bool):
	run_test_case(resource_path, test_case, debug)

##########################################################################
# Network stuff
func _on_client_connected(client_id :int) -> void:
	_client_id = client_id

func _on_client_disconnected(client_id :int) -> void:
	# only stops is not in debug mode running and the current client
	if not _running_debug_mode and _client_id == client_id:
		_gdUnit_stop(client_id)
	_client_id = -1
