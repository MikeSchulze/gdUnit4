class_name PriorizedTestSessionHook
extends GdUnitTestSessionHook

signal start_up(name: String)
signal shut_down(name: String)

var _name: String

func _init(_priority: int, name: String) -> void:
	priority = _priority
	_name = name


func startup(_session: GdUnitTestSession) -> GdUnitResult:
	start_up.emit(_name)
	return GdUnitResult.success()


func shutdown(_session: GdUnitTestSession) -> GdUnitResult:
	shut_down.emit(_name)
	return GdUnitResult.success()
