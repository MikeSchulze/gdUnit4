class_name ClassWithOverridenVirtuals
extends Node

var _x := 100


func _init():
	_x *= 2

# Called when the node enters the scene tree for the first time.
func _ready():
	_x *= 2

func _input(event):
	if event.is_action_released("ui_accept"):
		_x += 10
