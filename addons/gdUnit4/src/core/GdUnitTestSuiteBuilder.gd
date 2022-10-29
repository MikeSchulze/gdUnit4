class_name GdUnitTestSuiteBuilder
extends Resource

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
		CLOSE_DOCS
}


func create(source :Script, line_number :int) -> Result:
	var test_suite_path := _TestSuiteScanner.resolve_test_suite_path(source.resource_path, GdUnitSettings.test_root_folder())
	_save_and_close_script(test_suite_path)
	
	if GdObjects.is_cs_script(source):
		return GdUnit3MonoAPI.create_test_suite(source.resource_path, line_number+1, test_suite_path)
	
	var parser := GdScriptParser.new()
	var lines := source.source_code.split("\n")
	var current_line := lines[line_number]
	var func_name := parser.parse_func_name(current_line)
	if func_name.is_empty():
		return Result.error("No function found at line: %d." % line_number)
	return _TestSuiteScanner.create_test_case(test_suite_path, func_name, source.resource_path)


static func _save_and_close_script(script_path :String):
	if not Engine.has_meta("GdUnitEditorPlugin"):
		return
	var plugin :EditorPlugin = Engine.get_meta("GdUnitEditorPlugin")
	var script_editor :ScriptEditor = plugin.get_editor_interface().get_script_editor()
	# is already opened?
	var open_file_index = 0
	for open_script in script_editor.get_open_scripts():
		if open_script.resource_path == script_path:
			# select the script in the editor
			script_editor._script_selected(open_file_index)
			
			# seams to be the save is async and collidates with external changes
			# https://github.com/godotengine/godot/issues/50163
			if not script_path.ends_with(".cs"):
				# needs to be saved first to store current editor changes
				script_editor._menu_option(EDITOR_ACTIONS.FILE_SAVE)
			# finally needs to be closed to can modify and reload
			script_editor._menu_option(EDITOR_ACTIONS.FILE_CLOSE)
			return
		open_file_index += 1
