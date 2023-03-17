@tool
class_name GdUnitInspecor
extends Panel

# header
@onready var _runButton :Button = $VBoxContainer/Header/ToolBar/Tools/run


var _command_handler := GdUnitCommandHandler.instance()


func _ready():
	if Engine.is_editor_hint():
		var plugin :EditorPlugin = Engine.get_meta("GdUnitEditorPlugin")
		_getEditorThemes(plugin.get_editor_interface())
	if GdUnitSettings.is_update_notification_enabled():
		var update_tool = load("res://addons/gdUnit4/src/update/GdUnitUpdateNotify.tscn").instantiate()
		add_child(update_tool)
	GdUnitCommandHandler.instance().gdunit_runner_start.connect(func():
		var tab_container :TabContainer = get_parent_control()
		for tab_index in tab_container.get_tab_count():
			if tab_container.get_tab_title(tab_index) == "GdUnit":
				tab_container.set_current_tab(tab_index)
	)


func _enter_tree():
	if Engine.is_editor_hint():
		add_script_editor_context_menu()
		add_file_system_dock_context_menu()


func _exit_tree():
	if Engine.is_editor_hint():
		ScriptEditorControls.unregister_context_menu()
		EditorFileSystemControls.unregister_context_menu()


func _process(_delta):
	_command_handler._do_process()


func _getEditorThemes(interface :EditorInterface) -> void:
	if interface == null:
		return
		# example to access current theme
	#var editiorTheme := interface.get_base_control().theme
	# setup inspector button icons
	#var stylebox_types :PackedStringArray = editiorTheme.get_stylebox_type_list()
	#for stylebox_type in stylebox_types:
		#prints("stylebox_type", stylebox_type)
	#	if "Tree" == stylebox_type:
	#		prints(editiorTheme.get_stylebox_list(stylebox_type))
	#var style:StyleBoxFlat = editiorTheme.get_stylebox("panel", "Tree")
	#style.bg_color = Color.RED
	#var locale = interface.get_editor_settings().get_setting("interface/editor/editor_language")
	#sessions_label.add_theme_color_override("font_color", get_color("contrast_color_2", "Editor"))
	#status_label.add_theme_color_override("font_color", get_color("contrast_color_2", "Editor"))
	#no_sessions_label.add_theme_color_override("font_color", get_color("contrast_color_2", "Editor"))


# Context menu registrations ----------------------------------------------------------------------
func add_file_system_dock_context_menu() -> void:
	var is_test_suite := func is_visible(script :GDScript, is_test_suite :bool):
		if script == null:
			return true
		return GdObjects.is_test_suite(script) == is_test_suite
	var is_enabled := func is_enabled(_script :GDScript):
		return !_runButton.disabled
	var run_test := func run_test(resource_paths :PackedStringArray, debug :bool):
		_command_handler.cmd_run_test_suites(resource_paths, debug)
	var menu :Array[GdUnitContextMenuItem] = [
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.TEST_RUN, "Run Tests", is_test_suite.bind(true), is_enabled, run_test.bind(false)),
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.TEST_DEBUG, "Debug Tests", is_test_suite.bind(true), is_enabled, run_test.bind(true)),
	]
	EditorFileSystemControls.register_context_menu(menu)


func add_script_editor_context_menu():
	var is_test_suite := func is_visible(script :GDScript, is_test_suite :bool):
		return GdObjects.is_test_suite(script) == is_test_suite
	var is_enabled := func is_enabled(_script :GDScript):
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
				_command_handler.cmd_run_test_case(script.resource_path, func_name, -1, debug)
				return
		# otherwise run the full test suite
		var selected_test_suites := [script.resource_path]
		_command_handler.cmd_run_test_suites(selected_test_suites, debug)
	var create_test := func create_test(script :Script, text_edit :TextEdit):
		var cursor_line := text_edit.get_caret_line()
		var result = GdUnitTestSuiteBuilder.create(script, cursor_line)
		if result.is_error():
			# show error dialog
			push_error("Failed to create test case: %s" % result.error_message())
			return
		var info := result.value() as Dictionary
		ScriptEditorControls.edit_script(info.get("path"), info.get("line"))

	var menu :Array[GdUnitContextMenuItem] = [
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.TEST_RUN, "Run Tests", is_test_suite.bind(true), is_enabled, run_test.bind(false)),
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.TEST_DEBUG, "Debug Tests", is_test_suite.bind(true), is_enabled, run_test.bind(true)),
		GdUnitContextMenuItem.new(GdUnitContextMenuItem.MENU_ID.CREATE_TEST, "Create Test", is_test_suite.bind(false), is_enabled, create_test)
	]
	ScriptEditorControls.register_context_menu(menu)


func _on_MainPanel_run_testsuite(test_suite_paths :Array, debug :bool):
	_command_handler.cmd_run_test_suites(test_suite_paths, debug)


func _on_MainPanel_run_testcase(resource_path :String, test_case :String, test_param_index :int, debug :bool):
	_command_handler.cmd_run_test_case(resource_path, test_case, test_param_index, debug)
