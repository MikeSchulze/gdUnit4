class_name GdUnitShortcutAction
extends RefCounted


var _type :GdUnitShortcut.ShortCut


func _init(p_type :GdUnitShortcut.ShortCut, p_shortcut :Shortcut, p_command :String):
	_type = p_type
	self.shortcut = p_shortcut
	self.command = p_command


var shortcut: Shortcut:
	set(value):
		shortcut = value
	get:
		return shortcut


var command: String:
	set(value):
		command = value
	get:
		return command


func _to_string() -> String:
	return "GdUnitShortcutAction: %s (%s) -> %s" % [GdUnitShortcut.ShortCut.keys()[_type], shortcut.get_as_text(), command]
