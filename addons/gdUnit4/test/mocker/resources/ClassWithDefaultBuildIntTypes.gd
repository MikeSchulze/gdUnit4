class_name ClassWithDefaultBuildIntTypes
extends RefCounted

func foo(_value :String, _color := Color.RED):
	pass

func bar(_value :String, _direction := Vector3.FORWARD, _aabb := AABB()):
	pass
