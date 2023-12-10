# GdUnit generated TestSuite
class_name GdFunctionDescriptorTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/parse/GdFunctionDescriptor.gd'


# helper to get method descriptor
func get_method_description(clazz_name :String, method_name :String) -> Dictionary:
	var method_list :Array = ClassDB.class_get_method_list(clazz_name)
	for method_descriptor in method_list:
		if method_descriptor["name"] == method_name:
			return method_descriptor
	return Dictionary()


func test_extract_from_func_without_return_type():
	# void add_sibling(sibling: Node, force_readable_name: bool = false)
	var method_descriptor := get_method_description("Node", "add_sibling")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("add_sibling")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(TYPE_NIL)
	assert_array(fd.args()).contains_exactly([
		GdFunctionArgument.new("sibling_", GdObjects.TYPE_NODE),
		GdFunctionArgument.new("force_readable_name_", TYPE_BOOL, "false")
	])
	# void add_sibling(node: Node, child_node: Node, legible_unique_name: bool = false)
	assert_str(fd.typeless()).is_equal("func add_sibling(sibling_, force_readable_name_=false) -> void:")


func test_extract_from_func_with_return_type():
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
		GdFunctionArgument.new("pattern_", TYPE_STRING),
		GdFunctionArgument.new("recursive_", TYPE_BOOL, "true"),
		GdFunctionArgument.new("owned_", TYPE_BOOL, "true"),
	])
	# Node find_child(mask: String, recursive: bool = true, owned: bool = true) const
	assert_str(fd.typeless()).is_equal("func find_child(pattern_, recursive_=true, owned_=true) -> Node:")


func test_extract_from_func_with_vararg():
	# Error emit_signal(signal: StringName, ...) vararg
	var method_descriptor := get_method_description("Node", "emit_signal")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("emit_signal")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_true()
	assert_int(fd.return_type()).is_equal(GdObjects.TYPE_ENUM)
	assert_array(fd.args()).contains_exactly([GdFunctionArgument.new("signal_", TYPE_STRING_NAME)])
	assert_array(fd.varargs()).contains_exactly([
		GdFunctionArgument.new("vararg0_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg1_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg2_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg3_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg4_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg5_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg6_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg7_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg8_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE),
		GdFunctionArgument.new("vararg9_", GdObjects.TYPE_VARARG, "\"%s\"" % GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE)
	])
	assert_str(fd.typeless()).is_equal("func emit_signal(signal_, vararg0_=\"__null__\", vararg1_=\"__null__\", vararg2_=\"__null__\", vararg3_=\"__null__\", vararg4_=\"__null__\", vararg5_=\"__null__\", vararg6_=\"__null__\", vararg7_=\"__null__\", vararg8_=\"__null__\", vararg9_=\"__null__\") -> Error:")


func test_extract_from_descriptor_is_virtual_func():
	var method_descriptor := get_method_description("Node", "_enter_tree")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("_enter_tree")
	assert_bool(fd.is_virtual()).is_true()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(TYPE_NIL)
	assert_array(fd.args()).is_empty()
	# void _enter_tree() virtual
	assert_str(fd.typeless()).is_equal("func _enter_tree() -> void:")


func test_extract_from_descriptor_is_virtual_func_full_check():
	var methods := ClassDB.class_get_method_list("Node")
	var expected_virtual_functions := [
		# Object virtuals
		"_get",
		"_get_property_list",
		"_init",
		"_notification",
		"_property_can_revert",
		"_property_get_revert",
		"_set",
		"_to_string",
		# Note virtuals
		"_enter_tree",
		"_exit_tree",
		"_get_configuration_warnings",
		"_input",
		"_physics_process",
		"_process",
		"_ready",
		"_shortcut_input",
		"_unhandled_input",
		"_unhandled_key_input"
	]
	# since Godot 4.2 there are more virtual functions
	if Engine.get_version_info().hex >= 0x40200:
		expected_virtual_functions.append("_validate_property")
		
	var _count := 0
	for method_descriptor in methods:
		var fd := GdFunctionDescriptor.extract_from(method_descriptor)
		
		if fd.is_virtual():
			_count += 1
			assert_array(expected_virtual_functions).contains([fd.name()])
	assert_int(_count).is_equal(expected_virtual_functions.size())


func test_extract_from_func_with_return_type_variant():
	var method_descriptor := get_method_description("Node", "get")
	var fd := GdFunctionDescriptor.extract_from(method_descriptor)
	assert_str(fd.name()).is_equal("get")
	assert_bool(fd.is_virtual()).is_false()
	assert_bool(fd.is_static()).is_false()
	assert_bool(fd.is_engine()).is_true()
	assert_bool(fd.is_vararg()).is_false()
	assert_int(fd.return_type()).is_equal(GdObjects.TYPE_VARIANT)
	assert_array(fd.args()).contains_exactly([
		GdFunctionArgument.new("property_", TYPE_STRING_NAME),
	])
	# Variant get(property: String) const
	assert_str(fd.typeless()).is_equal("func get(property_) -> Variant:")
