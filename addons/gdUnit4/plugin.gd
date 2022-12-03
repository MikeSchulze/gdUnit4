@tool
extends EditorPlugin

var _gd_inspector :Node
var _server_node
var _gd_console :Node
var _update_tool :Node
var _singleton :GdUnitSingleton


# removes GdUnit classes inherits from Godot.Node from the node inspecor, ohterwise it takes very long to popup the dialog
func _fixup_node_inspector() -> void:
	var classes := PackedStringArray([
		"GdUnitTestSuite",
		"_TestCase",
		"GdUnitInspecor",
		"GdUnitExecutor",
		"GdUnitTcpClient",
		"GdUnitTcpServer"])
	for clazz in classes:
		remove_custom_type(clazz)


func _enter_tree():
	Engine.set_meta("GdUnitEditorPlugin", self)
	_singleton = GdUnitSingleton.new()
	GdUnitSettings.setup()
	# install SignalHandler singleton
	add_autoload_singleton("GdUnitSignals", "res://addons/gdUnit4/src/core/GdUnitSignals.gd")
	# install the GdUnit inspector
	_gd_inspector = load("res://addons/gdUnit4/src/ui/GdUnitInspector.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, _gd_inspector)
	# install the GdUnit Console
	_gd_console = load("res://addons/gdUnit4/src/ui/GdUnitConsole.tscn").instantiate()
	add_control_to_bottom_panel(_gd_console, "gdUnitConsole")
	_server_node = load("res://addons/gdUnit4/src/network/GdUnitServer.tscn").instantiate()
	add_child(_server_node)
	var err := _gd_inspector.connect("gdunit_runner_stop",Callable(_server_node,"_on_gdunit_runner_stop"))
	if err != OK:
		prints("ERROR", GdUnitTools.error_as_string(err))
	_fixup_node_inspector()
	prints("Loading GdUnit4 Plugin success")
	# show possible update notification when is enabled
	if GdUnitSettings.is_update_notification_enabled():
		# grap first valid parent used for dialogs
		var windows := GdObjects.find_nodes_by_class(Engine.get_main_loop().root, "AcceptDialog", true)
		var parent :Node = windows[0].get_parent()
		_update_tool = load("res://addons/gdUnit4/src/update/GdUnitUpdate.tscn").instantiate()
		parent.call_deferred("add_child", _update_tool)
		#var parent :Node = Control.new()
		#add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, parent)


func _exit_tree():
	if is_instance_valid(_gd_inspector):
		remove_control_from_docks(_gd_inspector)
		_gd_inspector.free()
	if is_instance_valid(_gd_console):
		remove_control_from_bottom_panel(_gd_console)
		_gd_console.free()
	if is_instance_valid(_server_node):
		remove_child(_server_node)
		_server_node.free()
	# Delete and release the update tool only when it is not in use, otherwise it will interrupt the execution of the update
	if is_instance_valid(_update_tool) and not _update_tool.is_update_in_progress():
		_update_tool.queue_free()
	remove_autoload_singleton("GdUnitSignals")
	if Engine.has_meta("GdUnitEditorPlugin"):
		Engine.remove_meta("GdUnitEditorPlugin")
	prints("Unload GdUnit4 Plugin success")
