class_name ScriptEditorContextMenuHandler
extends Control

var _context_menus := Dictionary()
var _active_script :GDScript = null
var _active_text_edit: TextEdit = null

static func create(context_menus :Array[GdUnitContextMenuItem]) -> Callable:
	return Callable(ScriptEditorContextMenuHandler.new(context_menus), "on_script_changed")


func _init(context_menus :Array[GdUnitContextMenuItem]):
	for menu in context_menus:
		_context_menus[menu.id] = menu
	Engine.get_main_loop().root.call_deferred("add_child", self)


func _input(event):
	if event is InputEventKey and event.is_pressed():
		for shortcut_action in _context_menus.values():
			var action :GdUnitContextMenuItem =  shortcut_action
			if action.shortcut().matches_event(event) and action.is_visible(_active_script):
				if not has_editor_focus():
					return
				action.execute([_active_script, _active_text_edit])
				accept_event()
				return


func has_editor_focus() -> bool:
	return Engine.get_main_loop().root.gui_get_focus_owner() == _active_text_edit


func on_script_changed(script, editor :ScriptEditor):
	#prints("ContextMenuHandler:on_script_changed", script, editor)
	_active_script = script
	if script is GDScript:
		var current_editor := editor.get_current_editor()
		_active_text_edit = current_editor.get_base_editor()
		var popups :Array[Node] = GdObjects.find_nodes_by_class(current_editor, "PopupMenu", true)
		for popup in popups:
			if not popup.about_to_popup.is_connected(on_context_menu_show):
				popup.about_to_popup.connect(on_context_menu_show.bind(script, popup))
			if not popup.id_pressed.is_connected(on_context_menu_pressed):
				popup.id_pressed.connect(on_context_menu_pressed.bind(script, current_editor.get_base_editor()))


func on_context_menu_show(script :GDScript, context_menu :PopupMenu):
	#prints("on_context_menu_show", _context_menus.keys(), context_menu, self)
	context_menu.add_separator()
	var current_index := context_menu.get_item_count()
	for menu_id in _context_menus.keys():
		var menu_item :GdUnitContextMenuItem = _context_menus[menu_id]
		if menu_item.is_visible(script):
			context_menu.add_item(menu_item.name, menu_id)
			context_menu.set_item_disabled(current_index, !menu_item.is_enabled(script))
			context_menu.set_item_shortcut(current_index, menu_item.shortcut(), true)
			current_index += 1


func on_context_menu_pressed(id :int, script :GDScript, text_edit :TextEdit):
	prints("on_context_menu_pressed", id, script, text_edit)
	if !_context_menus.has(id):
		return
	var menu_item :GdUnitContextMenuItem = _context_menus[id]
	menu_item.execute([script, text_edit])
