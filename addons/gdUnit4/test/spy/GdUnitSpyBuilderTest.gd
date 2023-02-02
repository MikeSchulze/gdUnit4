# GdUnit generated TestSuite
class_name GdUnitSpyBuilderTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/spy/GdUnitSpyBuilder.gd'

# helper to get function descriptor
static func get_function_description(clazz_name :String, method_name :String) -> GdFunctionDescriptor:
	var method_list :Array = ClassDB.class_get_method_list(clazz_name)
	for method_descriptor in method_list:
		if method_descriptor["name"] == method_name:
			return GdFunctionDescriptor.extract_from(method_descriptor)
	return null


func test_double__init() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void _init() virtual
	var fd := get_function_description("Object", "_init")
	var expected := [
		"func _init():",
		"	super._init()",
		"	pass",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_without_arg() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# String get_class() const
	var fd := get_function_description("Object", "get_class")
	var expected := [
		"func get_class() -> String:",
		"	var args :Array = [\"get_class\"]",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return \"\"",
		"	else:",
		"		__save_function_interaction(args)",
		"	return super.get_class()",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_with_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# bool is_connected(signal: String,Callable(target: Object,method: String)) const
	var fd := get_function_description("Object", "is_connected")
	var expected := [
		"func is_connected(signal_, callable_) -> bool:",
		"	var args :Array = [\"is_connected\", signal_, callable_]",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return false",
		"	else:",
		"		__save_function_interaction(args)",
		"	return super.is_connected(signal_, callable_)",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_return_void_function_with_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void disconnect(signal: StringName, callable: Callable)
	var fd := get_function_description("Object", "disconnect")
	var expected := [
		"func disconnect(signal_, callable_):",
		"	var args :Array = [\"disconnect\", signal_, callable_]",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return",
		"	else:",
		"		__save_function_interaction(args)",
		"	super.disconnect(signal_, callable_)",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_return_void_function_without_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void free()
	var fd := get_function_description("Object", "free")
	var expected := [
		"func free():",
		"	var args :Array = [\"free\"]",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return",
		"	else:",
		"		__save_function_interaction(args)",
		"	super.free()",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_return_typed_function_with_args_and_varargs() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# Error emit_signal(signal: StringName, ...) vararg
	var fd := get_function_description("Object", "emit_signal")
	var expected := [
		"func emit_signal(signal_, vararg0_=\"__null__\", vararg1_=\"__null__\", vararg2_=\"__null__\", vararg3_=\"__null__\", vararg4_=\"__null__\", vararg5_=\"__null__\", vararg6_=\"__null__\", vararg7_=\"__null__\", vararg8_=\"__null__\", vararg9_=\"__null__\") -> int:",
		"	var varargs :Array = __filter_vargs([vararg0_, vararg1_, vararg2_, vararg3_, vararg4_, vararg5_, vararg6_, vararg7_, vararg8_, vararg9_])",
		"	var args :Array = [\"emit_signal\", signal_] + varargs",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return 0",
		"	else:",
		"		__save_function_interaction(args)",
		"	",
		"	match varargs.size():",
		"		0: return super.emit_signal(signal_)",
		"		1: return super.emit_signal(signal_, varargs[0])",
		"		2: return super.emit_signal(signal_, varargs[0], varargs[1])",
		"		3: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2])",
		"		4: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3])",
		"		5: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3], varargs[4])",
		"		6: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5])",
		"		7: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6])",
		"		8: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7])",
		"		9: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7], varargs[8])",
		"		10: return super.emit_signal(signal_, varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7], varargs[8], varargs[9])",
		"	push_error('To many function arguments %s, only 10 args current supported!' % varargs)",
		"	return 0",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_return_void_function_only_varargs() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void bar(s...) vararg
	var fd := GdFunctionDescriptor.new( "bar", 23, false, false, false, TYPE_NIL, "void", [], GdFunctionDescriptor._build_varargs(true))
	var expected := [
		"func bar(vararg0_=\"__null__\", vararg1_=\"__null__\", vararg2_=\"__null__\", vararg3_=\"__null__\", vararg4_=\"__null__\", vararg5_=\"__null__\", vararg6_=\"__null__\", vararg7_=\"__null__\", vararg8_=\"__null__\", vararg9_=\"__null__\"):",
		"	var varargs :Array = __filter_vargs([vararg0_, vararg1_, vararg2_, vararg3_, vararg4_, vararg5_, vararg6_, vararg7_, vararg8_, vararg9_])",
		"	var args :Array = [\"bar\"] + varargs",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return",
		"	else:",
		"		__save_function_interaction(args)",
		"	",
		"	match varargs.size():",
		"		0: super.bar()",
		"		1: super.bar(varargs[0])",
		"		2: super.bar(varargs[0], varargs[1])",
		"		3: super.bar(varargs[0], varargs[1], varargs[2])",
		"		4: super.bar(varargs[0], varargs[1], varargs[2], varargs[3])",
		"		5: super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4])",
		"		6: super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5])",
		"		7: super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6])",
		"		8: super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7])",
		"		9: super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7], varargs[8])",
		"		10: super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7], varargs[8], varargs[9])",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_return_typed_function_only_varargs() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# String bar(s...) vararg
	var fd := GdFunctionDescriptor.new( "bar", 23, false, false, false, TYPE_STRING, "String", [], GdFunctionDescriptor._build_varargs(true))
	var expected := [
		"func bar(vararg0_=\"__null__\", vararg1_=\"__null__\", vararg2_=\"__null__\", vararg3_=\"__null__\", vararg4_=\"__null__\", vararg5_=\"__null__\", vararg6_=\"__null__\", vararg7_=\"__null__\", vararg8_=\"__null__\", vararg9_=\"__null__\") -> String:",
		"	var varargs :Array = __filter_vargs([vararg0_, vararg1_, vararg2_, vararg3_, vararg4_, vararg5_, vararg6_, vararg7_, vararg8_, vararg9_])",
		"	var args :Array = [\"bar\"] + varargs",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return \"\"",
		"	else:",
		"		__save_function_interaction(args)",
		"	",
		"	match varargs.size():",
		"		0: return super.bar()",
		"		1: return super.bar(varargs[0])",
		"		2: return super.bar(varargs[0], varargs[1])",
		"		3: return super.bar(varargs[0], varargs[1], varargs[2])",
		"		4: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3])",
		"		5: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4])",
		"		6: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5])",
		"		7: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6])",
		"		8: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7])",
		"		9: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7], varargs[8])",
		"		10: return super.bar(varargs[0], varargs[1], varargs[2], varargs[3], varargs[4], varargs[5], varargs[6], varargs[7], varargs[8], varargs[9])",
		"	push_error('To many function arguments %s, only 10 args current supported!' % varargs)",
		"	return \"\"",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)


func test_double_static_return_void_function_without_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void foo()
	var fd := GdFunctionDescriptor.new( "foo", 23, false, true, false, TYPE_NIL, "", [])
	var expected := [
		"static func foo():",
		"	var args :Array = [\"foo\"]",
		"	",
		"	if __instance().__is_verify_interactions():",
		"		__instance().__verify_interactions(args)",
		"		return",
		"	else:",
		"		__instance().__save_function_interaction(args)",
		"	if false == false:",
		"		super.foo()",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_static_return_void_function_with_args() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	var fd := GdFunctionDescriptor.new( "foo", 23, false, true, false, TYPE_NIL, "", [
		GdFunctionArgument.new("arg1", TYPE_BOOL),
		GdFunctionArgument.new("arg2", TYPE_STRING, "\"default\"")
	])
	var expected := [
		"static func foo(arg1, arg2=\"default\"):",
		"	var args :Array = [\"foo\", arg1, arg2]",
		"	",
		"	if __instance().__is_verify_interactions():",
		"		__instance().__verify_interactions(args)",
		"		return",
		"	else:",
		"		__instance().__save_function_interaction(args)",
		"	if false == false:",
		"		super.foo(arg1, arg2)",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_virtual_return_void_function_with_arg() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void _input(event: InputEvent) virtual
	var fd := get_function_description("Node", "_input")
	var expected := [
		"func _input(event_):",
		"	var args :Array = [\"_input\", event_]",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return",
		"	else:",
		"		__save_function_interaction(args)",
		"	if true == false:",
		"		super._input(event_)",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)

func test_double_virtual_return_void_function_without_arg() -> void:
	var doubler := GdUnitSpyFunctionDoubler.new(false)
	# void _ready() virtual
	var fd := get_function_description("Node", "_ready")
	var expected := [
		"func _ready():",
		"	var args :Array = [\"_ready\"]",
		"	",
		"	if __is_verify_interactions():",
		"		__verify_interactions(args)",
		"		return",
		"	else:",
		"		__save_function_interaction(args)",
		"	if true == false:",
		"		super._ready()",
		""]
	assert_array(doubler.double(fd)).contains_exactly(expected)
