extends Node2D

class Player extends Node:
	var position :Vector3 = Vector3.ZERO


	func _init():
		set_name("Player")

	func is_on_floor() -> bool:
		return true


func _ready():
	add_child(Player.new(), true)
