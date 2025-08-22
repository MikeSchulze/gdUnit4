class_name RPC
extends RefCounted


var _data: Dictionary = {}


func _init(obj: Object = null) -> void:
	if obj != null:
		if obj.has_method("serialize"):
			_data = obj.call("serialize")
		else:
			_data = inst_to_dict(obj)


func get_data() -> Object:
	return dict_to_inst(_data)


func serialize() -> String:
	var data = inst_to_dict(self)
	_strip_bbcode_from_dict(data)
	return JSON.stringify(data)


# Recursively strip BBCode tags from dictionary values to prevent TCP JSON deserialization errors.
#
# CONTEXT: GdUnit4 uses BBCode formatting (e.g., [color=#FF0000]text[/color]) in test messages for
# colored display in the Godot editor. When these messages are serialized to JSON and transmitted 
# over TCP, the network layer may split large JSON payloads into chunks at arbitrary byte boundaries.
# 
# PROBLEM: If a chunk boundary splits a BBCode tag (e.g., chunk ends with '[color=#FF00' and next 
# chunk starts with '00]Error[/color]'), the reassembled JSON contains malformed syntax that fails
# to parse, causing "Can't deserialize JSON" errors.
#
# SOLUTION: Strip BBCode tags during serialization so only clean text is transmitted over the network.
# Colors are preserved for display purposes by applying BBCode formatting in the UI layer after
# deserialization. This creates clean separation between transport (BBCode-free) and presentation.
static func _strip_bbcode_from_dict(data: Dictionary, depth: int = 0) -> void:
	if depth > 100:  # Prevent stack overflow with deeply nested or circular data
		push_warning("Maximum recursion depth reached in BBCode stripping")
		return
		
	for key in data:
		var value = data[key]
		if value is String:
			data[key] = _strip_bbcode(value)
		elif value is Dictionary:
			_strip_bbcode_from_dict(value, depth + 1)
		elif value is Array:
			_strip_bbcode_from_array(value, depth + 1)


# Recursively strip BBCode tags from array elements (see _strip_bbcode_from_dict for context)
static func _strip_bbcode_from_array(data: Array, depth: int = 0) -> void:
	if depth > 100:  # Prevent stack overflow with deeply nested or circular data
		push_warning("Maximum recursion depth reached in BBCode stripping")
		return
		
	for i in range(data.size()):
		var value = data[i]
		if value is String:
			data[i] = _strip_bbcode(value)
		elif value is Dictionary:
			_strip_bbcode_from_dict(value, depth + 1)
		elif value is Array:
			_strip_bbcode_from_array(value, depth + 1)


# Cached RegEx for BBCode stripping to avoid recompilation overhead
static var _bbcode_regex: RegEx

# Get the compiled BBCode regex, creating it if necessary
static func _get_bbcode_regex() -> RegEx:
	if _bbcode_regex == null:
		_bbcode_regex = RegEx.new()
		var compile_result = _bbcode_regex.compile("\\[/?[^\\]]*\\]")
		if compile_result != OK:
			push_error("Failed to compile BBCode regex pattern")
			return null
	return _bbcode_regex

# Strip all BBCode tags from a string using regex pattern matching.
# Removes tags like [color=#FF0000], [/color], [b], [/b], [bgcolor=#000000], etc.
# Preserves the text content while removing all BBCode formatting syntax.
static func _strip_bbcode(text: String) -> String:
	var regex = _get_bbcode_regex()
	if regex == null:
		return text  # Fallback: return original text if regex failed
	return regex.sub(text, "", true)


# using untyped version see comments below
static func deserialize(json_value: String) -> Object:
	var json := JSON.new()
	var err := json.parse(json_value)
	if err != OK:
		push_error("Can't deserialize JSON, error at line %d:\n	error: %s \n	json: '%s'"
			% [json.get_error_line(), json.get_error_message(), json_value])
		return null
	var result: Dictionary = json.get_data()
	if not typeof(result) == TYPE_DICTIONARY:
		push_error("Can't deserialize JSON. Expecting dictionary, error at line %d:\n	error: %s \n	json: '%s'"
			% [result.error_line, result.error_string, json_value])
		return null
	return dict_to_inst(result)
