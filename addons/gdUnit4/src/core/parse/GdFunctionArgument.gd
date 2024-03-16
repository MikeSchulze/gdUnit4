class_name GdFunctionArgument
extends RefCounted


var _cleanup_leading_spaces = RegEx.create_from_string("(?m)^[ \t]+")
var _fix_comma_space := RegEx.create_from_string(""", {0,}\t{0,}(?=(?:[^"]*"[^"]*")*[^"]*$)(?!\\s)""")
var _name: String
var _type: int
var _default_value :Variant
var _parameter_sets :PackedStringArray = []

const UNDEFINED :Variant = "<-NO_ARG->"
const ARG_PARAMETERIZED_TEST := "test_parameters"


func _init(p_name :String, p_type :int = TYPE_MAX, value :Variant = UNDEFINED):
	_name = p_name
	_type = p_type
	if p_name == ARG_PARAMETERIZED_TEST:
		_parameter_sets = _parse_parameter_set(value)
	_default_value = value


func name() -> String:
	return _name


func default() -> Variant:
	return GodotVersionFixures.convert(_default_value, _type)


func value_as_string() -> String:
	if has_default():
		return str(_default_value)
	return ""


func type() -> int:
	return _type


func has_default() -> bool:
	return not is_same(_default_value, UNDEFINED)


func is_parameter_set() -> bool:
	return _name == ARG_PARAMETERIZED_TEST


func parameter_sets() -> PackedStringArray:
	return _parameter_sets


static func get_parameter_set(parameters :Array) -> GdFunctionArgument:
	for current in parameters:
		if current != null and current.is_parameter_set():
			return current
	return null


func _to_string() -> String:
	var s = _name
	if _type != TYPE_MAX:
		s += ":" + GdObjects.type_as_string(_type)
	if _default_value != UNDEFINED:
		s += "=" + str(_default_value)
	return s


func _parse_parameter_set(input :String) -> PackedStringArray:
	if not input.contains("["):
		return []

	input = _cleanup_leading_spaces.sub(input, "", true)
	input = input.trim_prefix("[").trim_suffix("]").replace("\n", "").trim_prefix(" ")
	var single_quote := false
	var double_quote := false
	var array_end := 0
	var current_index = 0
	var output :PackedStringArray = []
	var start_index := 0
	var buf = input.to_ascii_buffer()
	for c in buf:
		current_index += 1
		match c:
				# ignore spaces between array elements
			32: if array_end == 0:
					start_index += 1
					continue
				# step over array element seperator ','
			44: if array_end == 0:
					start_index += 1
					continue
			39: single_quote = !single_quote
			34: if not single_quote: double_quote = !double_quote
			91: if not double_quote and not single_quote: array_end +=1 # counts array open
			93: if not double_quote and not single_quote: array_end -=1 # counts array closed

		# if array closed than collect the element
		if array_end == 0 and current_index > start_index:
			var parameters := input.substr(start_index, current_index-start_index)
			parameters = _fix_comma_space.sub(parameters, ", ", true)
			output.append(parameters)
			start_index = current_index
	return output
