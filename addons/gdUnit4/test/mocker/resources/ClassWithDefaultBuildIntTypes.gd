class_name ClassWithDefaultBuildIntTypes
extends RefCounted

func foo(value :String, color := Color.RED):
	pass

func bar(value :String, direction := Vector3.FORWARD, aabb := AABB()):
	pass
