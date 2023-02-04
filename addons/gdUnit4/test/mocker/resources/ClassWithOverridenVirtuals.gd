class_name ClassWithOverridenVirtuals
extends Node

var _x := "default"


func _init():
	_x = "_init"


# Called when the node enters the scene tree for the first time.
func _ready():
	if _x == "_init":
		_x = ""
	_x += "_ready"


func _input(event):
	_x = "_input"
	if event.is_action_released("ui_accept"):
		_x = "ui_accept"
