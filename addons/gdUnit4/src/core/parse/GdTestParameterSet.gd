class_name GdTestParameterSet
extends RefCounted

const CLASS_TEMPLATE = """
class_name _ParameterExtractor extends '${clazz_path}'

func __extract_test_parameters() -> Array:
	return ${test_params}

"""

const EXCLUDE_PROPERTIES_TO_COPY = ["script", "type"]


# validates the given arguments are complete and matches to required input fields of the test function
static func validate(input_arguments :Array, input_value_set :Array) -> String:
	# check given parameter set with test case arguments
	var expected_arg_count = input_arguments.size() - 1
	for input_values in input_value_set:
		var parameter_set_index := input_value_set.find(input_values)
		if input_values is Array:
			var current_arg_count = input_values.size()
			if current_arg_count != expected_arg_count:
				return "\n	The parameter set at index [%d] does not match the expected input parameters!\n	The test case requires [%d] input parameters, but the set contains [%d]" % [parameter_set_index, expected_arg_count, current_arg_count]
			var error := validate_parameter_types(input_arguments, input_values, parameter_set_index)
			if not error.is_empty():
				return error
		else:
			return "\n	The parameter set at index [%d] does not match the expected input parameters!\n	Expecting an array of input values." % parameter_set_index
	return ""


static func validate_parameter_types(input_arguments :Array, input_values :Array, parameter_set_index :int) -> String:
	for i in input_arguments.size():
		var input_param :GdFunctionArgument = input_arguments[i]
		# only check the test input arguments
		if input_param.is_parameter_set():
			continue
		var input_param_type := input_param.type()
		var input_value = input_values[i]
		var input_value_type := typeof(input_value)
		# input parameter is not typed we skip the type test
		if input_param_type == TYPE_NIL:
			continue
		# is input type enum allow int values
		if input_param_type == GdObjects.TYPE_VARIANT and input_value_type == TYPE_INT:
			continue
		# allow only equal types and object == null
		if input_param_type == TYPE_OBJECT and input_value_type == TYPE_NIL:
			continue
		if input_param_type != input_value_type:
			return "\n	The parameter set at index [%d] does not match the expected input parameters!\n	The value '%s' does not match the required input parameter <%s>." % [parameter_set_index, input_value, input_param]
	return ""


static func extract_test_case_names(test_case :_TestCase, fd :GdFunctionDescriptor) -> PackedStringArray:
	var fa := GdFunctionArgument.get_parameter_set(fd.args())
	var parameter_set := fa.parameter_set()
	# if no static parameter set than needs to resolve by reflection
	if parameter_set.size() == 0:
		return _extract_test_names_by_reflection(test_case, fd)
	var test_case_names :PackedStringArray = []
	for parameter_index in parameter_set.size():
		test_case_names.append(_build_test_case_name(test_case, parameter_set[parameter_index], parameter_index))
		parameter_index += 1
	return test_case_names


static func _extract_test_names_by_reflection(test_case :_TestCase, fd :GdFunctionDescriptor) -> PackedStringArray:
	var parameters := GdTestParameterSet.extract_test_parameters(test_case.get_parent(), fd)
	var test_case_names :PackedStringArray = []
	for index in parameters.size():
		test_case_names.append(_build_test_case_name(test_case, str(parameters[index]), index))
	return test_case_names


static func _build_test_case_name(test_case :_TestCase, test_parameter :String, parameter_index :int) -> String:
	if not test_parameter.begins_with("["):
		test_parameter = "[" + test_parameter
	var test_name = "%s:%d %s" % [test_case.get_name(), parameter_index, test_parameter.replace('"', "'").replace("&'", "'")]
	if test_name.length() > 96:
		return test_name.substr(0, 96) + " ..."
	return test_name


# extracts the arguments from the given test case, using kind of reflection solution
# to restore the parameters from a string representation to real instance type
static func extract_test_parameters(ts_instance :Object, fd :GdFunctionDescriptor) -> Array:
	var source = ts_instance.get_script()
	var parameter_arg := GdFunctionArgument.get_parameter_set(fd.args())
	var source_code = CLASS_TEMPLATE\
		.replace("${clazz_path}", source.resource_path)\
		.replace("${test_params}", parameter_arg.value_as_string())
	var script = GDScript.new()
	script.source_code = source_code
	# enable this lines only for debuging
	#script.resource_path = GdUnitTools.create_temp_dir("parameter_extract") + "/%s__.gd" % fd.name()
	#DirAccess.remove_absolute(script.resource_path)
	#ResourceSaver.save(script, script.resource_path)
	var result = script.reload()
	if result != OK:
		push_error("Extracting test parameters failed! Script loading error: %s" % result)
		return []
	var instance = script.new()
	copy_properties(ts_instance, instance)
	instance.queue_free()
	return instance.call("__extract_test_parameters")


static func copy_properties(source :Object, dest :Object) -> void:
	var context := GdUnitThreadManager.get_current_context().get_execution_context()
	for property in source.get_property_list():
		var property_name = property["name"]
		var property_value = source.get(property_name)
		if EXCLUDE_PROPERTIES_TO_COPY.has(property_name):
			continue
		#if dest.get(property_name) == null:
		#	prints("|%s|" % property_name, source.get(property_name))

		# check for invalid name property
		if property_name == "name" and property_value == "":
			dest.set(property_name, "<empty>");
			continue
		# we need to duplicate the properties to the copy, the properties could be possible registered with `auto_free`
		if context != null and _needs_to_duplicate(property_value):
			dest.set(property_name, context.register_auto_free(property_value.duplicate(true)))
		else:
			dest.set(property_name, property_value)


static func _needs_to_duplicate(property_value) -> bool:
	return (property_value != null
		and typeof(property_value) == TYPE_OBJECT
		and is_instance_valid(property_value)
		and property_value.has_method("duplicate"))
