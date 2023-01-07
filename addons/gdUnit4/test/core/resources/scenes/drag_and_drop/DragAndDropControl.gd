extends PanelContainer


# Godot calls this method to get data that can be dragged and dropped onto controls that expect drop data. 
# Returns null if there is no data to drag. 
# Controls that want to receive drop data should implement can_drop_data() and drop_data(). 
# position is local to this control. Drag may be forced with force_drag().
func get_drag_data(_position: Vector2) -> Dictionary:
	var data: = {texture = $TextureRect.texture}
	var drag_texture := $TextureRect.duplicate()
	
	# set drag preview
	var control := Control.new()
	control.add_child(drag_texture)
	# center texture relative to mouse pos
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	set_drag_preview(control)
	return data

# Godot calls this method to test if data from a control's get_drag_data() can be dropped at position. position is local to this control.
func can_drop_data(_position: Vector2, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("texture")


# Godot calls this method to pass you the data from a control's get_drag_data() result. 
# Godot first calls can_drop_data() to test if data is allowed to drop at position where position is local to this control.
func drop_data(_position: Vector2, data) -> void:
	var drag_texture :StreamTexture = data["texture"]
	if drag_texture != null:
		$TextureRect.texture = drag_texture


# Virtual method to be implemented by the user. Use this method to process and accept inputs on UI elements. See accept_event().
func _gui_input(_event):
	#prints("Panel _gui_input", _event.as_text())
	#if _event is InputEventMouseButton:
	#	prints("Panel _gui_input", _event.as_text())
	pass
