extends Control

@onready var texture = preload("res://addons/gdUnit4/test/core/resources/scenes/drag_and_drop/icon.png")

func _ready():
	# set initial drag texture
	$left/TextureRect.texture = texture


# Virtual method to be implemented by the user. Use this method to process and accept inputs on UI elements. See accept_event().
func _gui_input(_event):
	#prints("Game _gui_input", _event.as_text())
	pass


func _on_Button_button_down():
	# print("BUTTON DOWN")
	pass
