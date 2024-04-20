## This service class contains helpers to wrap Godot functions and handle them carefully depending on the current Godot version
class_name GodotVersionFixures
extends RefCounted


## Returns the icon property defined by name and theme_type, if it exists.
static func get_icon(control: Control, icon_name: String) -> Texture2D:
	if Engine.get_version_info().hex >= 040200:
		return control.get_theme_icon(icon_name, "EditorIcons")
	return control.theme.get_icon(icon_name, "EditorIcons")


@warning_ignore("shadowed_global_identifier")
static func type_convert(value: Variant, type: int):
	return convert(value, type)


@warning_ignore("shadowed_global_identifier")
static func convert(value: Variant, type: int) -> Variant:
	return type_convert(value, type)


# handle global_position fixed by https://github.com/godotengine/godot/pull/88473
static func set_event_global_position(event: InputEventMouseMotion, global_position: Vector2):
	if Engine.get_version_info().hex >= 0x40202 or Engine.get_version_info().hex == 0x40104:
		event.global_position = event.position
	else:
		event.global_position = global_position
