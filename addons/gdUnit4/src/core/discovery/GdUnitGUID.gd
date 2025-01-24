## A class representing a globally unique identifier for GdUnit test elements.
## Uses Godot's ResourceUID system to generate unique identifiers that can be used
## to track and reference test cases and suites across the test framework.
class_name GdUnitGUID
extends RefCounted


## The internal string representation of the GUID.
## Generated using Godot's ResourceUID system when no existing GUID is provided.
var _guid: String


## Creates a new GUID instance.
## If no GUID is provided, generates a new one using Godot's ResourceUID system.
func _init(from_guid: String = "") -> void:
	# if no guid provided we use Godot UID to build the uique guid
	if from_guid.is_empty():
		var date_time := Time.get_datetime_dict_from_system(true)
		var year :int = date_time["year"]
		var month :int = date_time["month"]
		var day :int = date_time["day"]
		var hour :int = date_time["hour"]
		var minute :int = date_time["minute"]
		var second :int = date_time["second"]
		# Build date part by shifting and combining year, month, day
		var date_part := (year << 16) | (month << 8) | day
		# Build time part by shifting and combining hour, minute, second
		var time_part := (hour << 16) | (minute << 8) | second
		_guid = "%d-%d-%d-%d" % [ResourceUID.create_id(), date_part, time_part, 0]
	else:
		_guid = from_guid


## Compares this GUID with another for equality.
## Returns true if both GUIDs represent the same unique identifier.
func equals(other: GdUnitGUID) -> bool:
	return other._guid == _guid
