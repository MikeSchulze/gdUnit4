class_name GdUnitCommand
extends RefCounted


func _init(p_is_enabled: Callable, p_runnable: Callable, p_shortcut :GdUnitShortcut.ShortCut):
	self.is_enabled = p_is_enabled
	self.shortcut = p_shortcut
	self.runnable = p_runnable


var name: String:
	set(value):
		name = value
	get:
		return name


var shortcut: GdUnitShortcut.ShortCut:
	set(value):
		shortcut = value
	get:
		return shortcut


var is_enabled: Callable:
	set(value):
		is_enabled = value
	get:
		return is_enabled


var runnable: Callable:
	set(value):
		runnable = value
	get:
		return runnable
