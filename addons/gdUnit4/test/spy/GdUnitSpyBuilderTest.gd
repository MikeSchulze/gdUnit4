# GdUnit generated TestSuite
class_name GdUnitSpyBuilderTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/spy/GdUnitSpyBuilder.gd'


# helper to get function descriptor
func get_function_description(clazz_name :String, method_name :String) -> GdFunctionDescriptor:
	var method_list :Array = ClassDB.class_get_method_list(clazz_name)
	for method_descriptor :Dictionary in method_list:
		if method_descriptor["name"] == method_name:
			return GdFunctionDescriptor.extract_from(method_descriptor)
	return null


func test_double__init() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void _init() virtual
	var fd := get_function_description("Object", "_init")
	var expected := [
		'func _init() -> void:',
		'	super()',
		'	pass',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_without_arg() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# String get_class() const
	var fd := get_function_description("Object", "get_class")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("shadowed_variable")',
		'func get_class() -> String:',
		'	var args__: Array = ["get_class", ]',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return ""',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	if __do_call_real_func("get_class"):',
		'		return super()',
		'	return ""',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_with_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# bool is_connected(signal: String,Callable(target: Object,method: String)) const
	var fd := get_function_description("Object", "is_connected")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("shadowed_variable")',
		'func is_connected(signal_, callable_) -> bool:',
		'	var args__: Array = ["is_connected", signal_, callable_]',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return false',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	if __do_call_real_func("is_connected"):',
		'		return super(signal_, callable_)',
		'	return false',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_void_function_with_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void disconnect(signal: StringName, callable: Callable)
	var fd := get_function_description("Object", "disconnect")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("shadowed_variable")',
		'func disconnect(signal_, callable_) -> void:',
		'	var args__: Array = ["disconnect", signal_, callable_]',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	if __do_call_real_func("disconnect"):',
		'		super(signal_, callable_)',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_void_function_without_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void free()
	var fd := get_function_description("Object", "free")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("shadowed_variable")',
		'func free() -> void:',
		'	var args__: Array = ["free", ]',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	if __do_call_real_func("free"):',
		'		super()',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_with_args_and_varargs() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# Error emit_signal(signal: StringName, ...) vararg
	var fd := get_function_description("Object", "emit_signal")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("int_as_enum_without_match")',
		'@warning_ignore("int_as_enum_without_cast")',
		'@warning_ignore("shadowed_variable")',
		'func emit_signal(signal_, vararg0_="__null__", vararg1_="__null__", vararg2_="__null__", vararg3_="__null__", vararg4_="__null__", vararg5_="__null__", vararg6_="__null__", vararg7_="__null__", vararg8_="__null__", vararg9_="__null__") -> Error:',
		'	var varargs__: Array = __filter_vargs([vararg0_, vararg1_, vararg2_, vararg3_, vararg4_, vararg5_, vararg6_, vararg7_, vararg8_, vararg9_])',
		'	var args__: Array = ["emit_signal", signal_] + varargs__',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return OK',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	return __call_func("emit_signal", [signal_] + varargs__)',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_void_function_only_varargs() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void bar(s...) vararg
	var fd := GdFunctionDescriptor.new( "bar", 23, false, false, false, TYPE_NIL, "void", [], GdFunctionDescriptor._build_varargs(true))
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("shadowed_variable")',
		'func bar(vararg0_="__null__", vararg1_="__null__", vararg2_="__null__", vararg3_="__null__", vararg4_="__null__", vararg5_="__null__", vararg6_="__null__", vararg7_="__null__", vararg8_="__null__", vararg9_="__null__") -> void:',
		'	var varargs__: Array = __filter_vargs([vararg0_, vararg1_, vararg2_, vararg3_, vararg4_, vararg5_, vararg6_, vararg7_, vararg8_, vararg9_])',
		'	var args__: Array = ["bar", ] + varargs__',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	__call_func("bar", [] + varargs__)',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_only_varargs() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# String bar(s...) vararg
	var fd := GdFunctionDescriptor.new( "bar", 23, false, false, false, TYPE_STRING, "String", [], GdFunctionDescriptor._build_varargs(true))
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("shadowed_variable")',
		'func bar(vararg0_="__null__", vararg1_="__null__", vararg2_="__null__", vararg3_="__null__", vararg4_="__null__", vararg5_="__null__", vararg6_="__null__", vararg7_="__null__", vararg8_="__null__", vararg9_="__null__") -> String:',
		'	var varargs__: Array = __filter_vargs([vararg0_, vararg1_, vararg2_, vararg3_, vararg4_, vararg5_, vararg6_, vararg7_, vararg8_, vararg9_])',
		'	var args__: Array = ["bar", ] + varargs__',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return ""',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	return __call_func("bar", [] + varargs__)',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_static_return_void_function_without_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void foo()
	var fd := GdFunctionDescriptor.new( "foo", 23, false, true, false, TYPE_NIL, "", [])
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("shadowed_variable")',
		'static func foo() -> void:',
		'	var args__: Array = ["foo", ]',
		'',
		'	if __instance().__is_verify_interactions():',
		'		__instance().__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__instance().__save_function_interaction(args__)',
		'',
		'	if __instance().__do_call_real_func("foo"):',
		'		super()',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_static_return_void_function_with_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	var fd := GdFunctionDescriptor.new( "foo", 23, false, true, false, TYPE_NIL, "", [
		GdFunctionArgument.new("arg1", TYPE_BOOL),
		GdFunctionArgument.new("arg2", TYPE_STRING, '"default"')
	])
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("shadowed_variable")',
		'static func foo(arg1_, arg2_="default") -> void:',
		'	var args__: Array = ["foo", arg1_, arg2_]',
		'',
		'	if __instance().__is_verify_interactions():',
		'		__instance().__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__instance().__save_function_interaction(args__)',
		'',
		'	if __instance().__do_call_real_func("foo"):',
		'		super(arg1_, arg2_)',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_static_script_function_with_args_return_bool() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)

	var fd := GdFunctionDescriptor.new( "foo", 23, false, true, false, TYPE_BOOL, "", [
		GdFunctionArgument.new("arg1", TYPE_BOOL),
		GdFunctionArgument.new("arg2", TYPE_STRING, '"default"')
	])
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("shadowed_variable")',
		'static func foo(arg1_, arg2_="default") -> bool:',
		'	var args__: Array = ["foo", arg1_, arg2_]',
		'',
		'	if __instance().__is_verify_interactions():',
		'		__instance().__verify_interactions(args__)',
		'		return false',
		'	else:',
		'		__instance().__save_function_interaction(args__)',
		'',
		'	if __instance().__do_call_real_func("foo"):',
		'		return super(arg1_, arg2_)',
		'	return false',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_virtual_return_void_function_with_arg() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void _input(event: InputEvent) virtual
	var fd := get_function_description("Node", "_input")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("shadowed_variable")',
		'func _input(event_) -> void:',
		'	var args__: Array = ["_input", event_]',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	if __do_call_real_func("_input"):',
		'		super(event_)',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_virtual_return_void_function_without_arg() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void _ready() virtual
	var fd := get_function_description("Node", "_ready")
	var expected := [
		'@warning_ignore("untyped_declaration")' if Engine.get_version_info().hex >= 0x40200 else '',
		'@warning_ignore("native_method_override")',
		'@warning_ignore("shadowed_variable")',
		'func _ready() -> void:',
		'	var args__: Array = ["_ready", ]',
		'',
		'	if __is_verify_interactions():',
		'		__verify_interactions(args__)',
		'		return',
		'	else:',
		'		__save_function_interaction(args__)',
		'',
		'	if __do_call_real_func("_ready"):',
		'		super()',
		'',
		'']
	assert_array(doubler.double(fd)).contains_exactly(expected)


class NodeWithOutVirtualFunc extends Node:
	func _ready() -> void:
		pass

	#func _input(event :InputEvent) -> void:


func test_spy_on_script_respect_virtual_functions() -> void:
	var do_spy :Variant = auto_free(GdUnitSpyBuilder.spy_on_script(auto_free(NodeWithOutVirtualFunc.new()), [], false).new())
	assert_that(do_spy.has_method("_ready")).is_true()
	assert_that(do_spy.has_method("_input")).is_false()
