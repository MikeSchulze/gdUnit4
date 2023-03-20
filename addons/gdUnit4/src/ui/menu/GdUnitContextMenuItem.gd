class_name GdUnitContextMenuItem

enum MENU_ID {
	TEST_RUN = 1000,
	TEST_DEBUG = 1001,
	CREATE_TEST = 1010,
}


var _is_visible :Callable


func _init(p_id :MENU_ID, p_name :StringName, p_is_visible :Callable, p_command :GdUnitCommand):
	self.id = p_id
	self.name = p_name
	self.command = p_command
	_is_visible = p_is_visible


var id: MENU_ID:
	set(value):
		id = value
	get:
		return id


var name: StringName:
	set(value):
		name = value
	get:
		return name


var command: GdUnitCommand:
	set(value):
		command = value
	get:
		return command


func shortcut() -> Shortcut:
	return GdUnitCommandHandler.instance().get_shortcut(command.shortcut)


func is_enabled(script :GDScript) -> bool:
	return command.is_enabled.call(script)


func is_visible(script :GDScript) -> bool:
	return _is_visible.call(script)


func execute(args :Array) -> void:
	command.runnable.callv(args)
