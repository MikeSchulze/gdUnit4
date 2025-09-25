# GdUnit generated TestSuite
class_name GdFunctionDescriptorTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/parse/GdFunctionDescriptor.gd'


# helper to get method descriptor
func get_method_description(clazz_name :String, method_name :String) -> Dictionary:
	var method_list :Array = ClassDB.class_get_method_list(clazz_name)
	for method_descriptor :Dictionary in method_list:
		if method_descriptor["name"] == method_name:
			return method_descriptor
	return Dictionary()


func test_extract_from_func_without_return_type() -> void:
	# void add_sibling(sibling: Node, force_readable_name: bool = false)
	var method_descriptor := get_method_description("Node", "add_sibling")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("add_sibling")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(GdObjects.TYPE_VOID)
	assert_array(fd.args()).contains_exactly([
		GdFunctionArgument.new("sibling", GdObjects.TYPE_NODE),
		GdFunctionArgument.new("force_readable_name", TYPE_BOOL, false)
	])


func test_extract_from_func_with_return_type() -> void:
	# Node find_child(pattern: String, recursive: bool = true, owned: bool = true) const
	var method_descriptor := get_method_description("Node", "find_child")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("find_child")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(TYPE_OBJECT)
	assert_array(fd.args()).contains_exactly([
		GdFunctionArgument.new("pattern", TYPE_STRING),
		GdFunctionArgument.new("recursive", TYPE_BOOL, true),
		GdFunctionArgument.new("owned", TYPE_BOOL, true),
	])


func test_extract_from_func_with_vararg() -> void:
	# Error emit_signal(signal: StringName, ...) vararg
	var method_descriptor := get_method_description("Node", "emit_signal")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("emit_signal")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_true()
	assert_int(fd.return_type()).is_equal(GdObjects.TYPE_ENUM)
	assert_array(fd.args()).contains_exactly([GdFunctionArgument.new("signal", TYPE_STRING_NAME)])
	assert_array(fd.varargs()).contains_exactly([
		GdFunctionArgument.new("varargs", GdObjects.TYPE_VARARG, '')
	])


func test_extract_from_descriptor_is_virtual_func() -> void:
	var method_descriptor := get_method_description("Node", "_enter_tree")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("_enter_tree")
	assert_bool(fd.is_virtual()).is_true()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(GdObjects.TYPE_VOID)
	assert_array(fd.args()).is_empty()


func test_extract_from_descriptor_is_virtual_func_full_check() -> void:
	var methods := ClassDB.class_get_method_list("Node")
	var expected_virtual_functions := [
		"_process",
		"_physics_process",
		"_enter_tree",
		"_exit_tree",
		"_ready",
		"_get_configuration_warnings",
		"_get_accessibility_configuration_warnings",
		"_input",
		"_shortcut_input",
		"_unhandled_input",
		"_unhandled_key_input",
		"_get_focused_accessibility_element",
		"_init",
		"_to_string",
		"_notification",
		"_set",
		"_get",
		"_get_property_list",
		"_validate_property",
		"_property_can_revert",
		"_property_get_revert",
		"_iter_init",
		"_iter_next",
		"_iter_get"
	]

	var _count := 0
	for method_descriptor in methods:
		var fd := GdFunctionDescriptor.extract_from(method_descriptor)

		if fd.is_virtual():
			_count += 1
			assert_array(expected_virtual_functions).contains([fd.name()])
	assert_int(_count).is_equal(expected_virtual_functions.size())


func test_extract_from_func_with_return_type_variant() -> void:
	var method_descriptor := get_method_description("Node", "get")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("get")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(GdObjects.TYPE_VARIANT)
	assert_array(fd.args()).contains_exactly([
		GdFunctionArgument.new("property", TYPE_STRING_NAME),
	])


@warning_ignore("unused_parameter")
func test_extract_return_type(info: String, expected: int, descriptor: Dictionary, test_parameters := [
	['return_undefined', GdObjects.TYPE_VARIANT, { "name": "", "class_name": &"", "type": 0, "hint": 0, "hint_string": "", "usage": 131072 }],
	['return_variant', GdObjects.TYPE_VARIANT, { "name": "", "class_name": &"", "type": 0, "hint": 0, "hint_string": "", "usage": 131072 }],
	['return_int', TYPE_INT, { "name": "", "class_name": &"", "type": 2, "hint": 0, "hint_string": "", "usage": 0 }],
	['return_string', TYPE_STRING, { "name": "", "class_name": &"", "type": 4, "hint": 0, "hint_string": "", "usage": 0 }],
	['return_void', GdObjects.TYPE_VOID, { "name": "", "class_name": &"", "type": 0, "hint": 0, "hint_string": "", "usage": 6 }]
]) -> void:
	var return_type := GdFunctionDescriptor._extract_return_type(descriptor)
	assert_that(return_type).is_equal(expected)


@warning_ignore("unused_parameter")
func example_signature(info: String, expected: int, test_parameters := [
	["aaa", 10],
	["bbb", 11],
]) -> void:
	pass
