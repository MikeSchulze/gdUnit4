class_name GdUnitContextMenuItem

enum MENU_ID {
	TEST_RUN = 1000,
	TEST_DEBUG = 1001,
	CREATE_TEST = 1010,
}

var _is_visible :Callable
var _is_enabled :Callable
var _runnable: Callable


func _init(p_id :MENU_ID, p_name :StringName, p_is_visible :Callable, p_is_enabled: Callable, p_runnable: Callable):
	self.id = p_id
	self.name = p_name
	_is_visible = p_is_visible
	_is_enabled = p_is_enabled
	_runnable = p_runnable


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


func is_enabled(script :GDScript) -> bool:
	return _is_enabled.call(script)


func is_visible(script :GDScript) -> bool:
	return _is_visible.call(script)


func execute(args :Array) -> void:
	_runnable.callv(args)
