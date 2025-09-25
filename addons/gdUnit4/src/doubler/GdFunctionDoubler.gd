@abstract class_name GdFunctionDoubler
extends RefCounted


const DEFAULT_TYPED_RETURN_VALUES := {
	TYPE_NIL: "null",
	TYPE_BOOL: "false",
	TYPE_INT: "0",
	TYPE_FLOAT: "0.0",
	TYPE_STRING: "\"\"",
	TYPE_STRING_NAME: "&\"\"",
	TYPE_VECTOR2: "Vector2.ZERO",
	TYPE_VECTOR2I: "Vector2i.ZERO",
	TYPE_RECT2: "Rect2()",
	TYPE_RECT2I: "Rect2i()",
	TYPE_VECTOR3: "Vector3.ZERO",
	TYPE_VECTOR3I: "Vector3i.ZERO",
	TYPE_VECTOR4: "Vector4.ZERO",
	TYPE_VECTOR4I: "Vector4i.ZERO",
	TYPE_TRANSFORM2D: "Transform2D()",
	TYPE_PLANE: "Plane()",
	TYPE_QUATERNION: "Quaternion()",
	TYPE_AABB: "AABB()",
	TYPE_BASIS: "Basis()",
	TYPE_TRANSFORM3D: "Transform3D()",
	TYPE_PROJECTION: "Projection()",
	TYPE_COLOR: "Color()",
	TYPE_NODE_PATH: "NodePath()",
	TYPE_RID: "RID()",
	TYPE_OBJECT: "null",
	TYPE_CALLABLE: "Callable()",
	TYPE_SIGNAL: "Signal()",
	TYPE_DICTIONARY: "Dictionary()",
	TYPE_ARRAY: "Array()",
	TYPE_PACKED_BYTE_ARRAY: "PackedByteArray()",
	TYPE_PACKED_INT32_ARRAY: "PackedInt32Array()",
	TYPE_PACKED_INT64_ARRAY: "PackedInt64Array()",
	TYPE_PACKED_FLOAT32_ARRAY: "PackedFloat32Array()",
	TYPE_PACKED_FLOAT64_ARRAY: "PackedFloat64Array()",
	TYPE_PACKED_STRING_ARRAY: "PackedStringArray()",
	TYPE_PACKED_VECTOR2_ARRAY: "PackedVector2Array()",
	TYPE_PACKED_VECTOR3_ARRAY: "PackedVector3Array()",
	# since Godot 4.3.beta1 TYPE_PACKED_VECTOR4_ARRAY = 38
	GdObjects.TYPE_PACKED_VECTOR4_ARRAY: "PackedVector4Array()",
	TYPE_PACKED_COLOR_ARRAY: "PackedColorArray()",
	GdObjects.TYPE_VARIANT: "null",
	GdObjects.TYPE_ENUM: "0"
}

# @GlobalScript enums
# needs to manually map because of https://github.com/godotengine/godot/issues/73835
const DEFAULT_ENUM_RETURN_VALUES = {
	"Side" : "SIDE_LEFT",
	"Corner" : "CORNER_TOP_LEFT",
	"Orientation" : "HORIZONTAL",
	"ClockDirection" : "CLOCKWISE",
	"HorizontalAlignment" : "HORIZONTAL_ALIGNMENT_LEFT",
	"VerticalAlignment" : "VERTICAL_ALIGNMENT_TOP",
	"InlineAlignment" : "INLINE_ALIGNMENT_TOP_TO",
	"EulerOrder" : "EULER_ORDER_XYZ",
	"Key" : "KEY_NONE",
	"KeyModifierMask" : "KEY_CODE_MASK",
	"MouseButton" : "MOUSE_BUTTON_NONE",
	"MouseButtonMask" : "MOUSE_BUTTON_MASK_LEFT",
	"JoyButton" : "JOY_BUTTON_INVALID",
	"JoyAxis" : "JOY_AXIS_INVALID",
	"MIDIMessage" : "MIDI_MESSAGE_NONE",
	"Error" : "OK",
	"PropertyHint" : "PROPERTY_HINT_NONE",
	"Variant.Type" : "TYPE_NIL",
	"Vector2.Axis" : "Vector2.AXIS_X",
	"Vector2i.Axis" : "Vector2i.AXIS_X",
	"Vector3.Axis" : "Vector3.AXIS_X",
	"Vector3i.Axis" : "Vector3i.AXIS_X",
	"Vector4.Axis" : "Vector4.AXIS_X",
	"Vector4i.Axis" : "Vector4i.AXIS_X",
}


# Determine the enum default by reflection
static func get_enum_default(value: String) -> Variant:
	var script := GDScript.new()
	script.source_code = """
	extends Resource

	static func get_enum_default() -> Variant:
		return %s.values()[0]

	""".dedent() % value
	@warning_ignore("return_value_discarded")
	var err := script.reload()
	if err != OK:
		push_error("Cant get enum values form '%s', %s" % [value, error_string(err)])
	@warning_ignore("unsafe_method_access")
	return script.new().call("get_enum_default")


static func default_return_value(func_descriptor :GdFunctionDescriptor) -> String:
	var return_type :Variant = func_descriptor.return_type()
	if return_type == GdObjects.TYPE_ENUM:
		var enum_class := func_descriptor._return_class
		if DEFAULT_ENUM_RETURN_VALUES.has(enum_class):
			return DEFAULT_ENUM_RETURN_VALUES.get(func_descriptor._return_class, "0")

		var enum_path := enum_class.split(".")
		if enum_path.size() >= 2:
			var keys := ClassDB.class_get_enum_constants(enum_path[0], enum_path[1])
			if not keys.is_empty():
				return "%s.%s" % [enum_path[0], keys[0]]
			var enum_value :Variant = get_enum_default(enum_class)
			if enum_value != null:
				return str(enum_value)
		# we need fallback for @GlobalScript enums,
		return DEFAULT_ENUM_RETURN_VALUES.get(func_descriptor._return_class, "0")
	return DEFAULT_TYPED_RETURN_VALUES.get(return_type, "invalid")


func _init() -> void:
	for type_key in TYPE_MAX:
		if not DEFAULT_TYPED_RETURN_VALUES.has(type_key):
			push_error("missing default definitions! Expexting %d bud is %d" % [DEFAULT_TYPED_RETURN_VALUES.size(), TYPE_MAX])
			prints("missing default definition for type", type_key)
			assert(DEFAULT_TYPED_RETURN_VALUES.has(type_key), "Missing Type default definition!")


@abstract func double(func_descriptor: GdFunctionDescriptor) -> PackedStringArray

@warning_ignore("unused_parameter")
func get_template(return_type: GdFunctionDescriptor) -> String:
	assert(false, "'get_template' must be implemented!")
	return ""

class GdUnitFunctionDublerBuilder extends RefCounted:
	static var def_verify_block := """
		# verify block
		var __verifier := __get_verifier()
		if __verifier != null:
			if __verifier.is_verify_interactions():
				__verifier.verify_interactions("$func_name", __args)
				$default_return
			else:
				__verifier.save_function_interaction("$func_name", __args)
		""".dedent().indent("\t").trim_suffix("\n")

	static var def_prepare_block := """
		if __is_prepare_return_value():
			__save_function_return_value("$func_name", __args)
			$default_return
		""".dedent().indent("\t").trim_suffix("\n")

	static var def_void_prepare_block := """
		if __is_prepare_return_value():
			push_error("Mocking functions with return type void is not allowed!")
			return
		""".dedent().indent("\t").trim_suffix("\n")

	static var def_mock_return := """
		if __is_do_not_call_real_func("$func_name", __args):
			return __return_mock_value("$func_name", __args, $default_return)
		""".dedent().indent("\t").trim_suffix("\n")

	static var def_void_mock_return := """
		if __is_do_not_call_real_func("$func_name", __args):
			return
		""".dedent().indent("\t").trim_suffix("\n")

	var fd: GdFunctionDescriptor
	var func_args: Array
	var default_return: String
	var func_signature: String
	var verify_block: String = ""
	var prepare_block: String = ""
	var mock_return: String = ""

	static func extract_func_signature(descriptor: GdFunctionDescriptor) -> String:
		var signature := ""
		if descriptor._return_type == TYPE_NIL:
			signature = "func %s(%s) -> void:" % [descriptor.name(), typeless_args(descriptor)]
		elif descriptor._return_type == GdObjects.TYPE_VARIANT:
			signature = "func %s(%s):" % [descriptor.name(), typeless_args(descriptor)]
		else:
			signature = "func %s(%s) -> %s:" % [descriptor.name(), typeless_args(descriptor), descriptor.return_type_as_string()]
		return "static " + signature if descriptor.is_static() else signature


	static func typeless_args(descriptor: GdFunctionDescriptor) -> String:
		var collect := PackedStringArray()
		for arg in descriptor.args():
			if arg.has_default():
				# For Variant types we need to enforce the type in the signature
				if arg.type() == GdObjects.TYPE_VARIANT:
					collect.push_back("%s_:%s=%s" % [arg.name(), GdObjects.type_as_string(arg.type()), arg.value_as_string()])
				else:
					@warning_ignore("return_value_discarded")
					collect.push_back("%s_=%s" % [arg.name(), arg.value_as_string()])
			else:
				@warning_ignore("return_value_discarded")
				collect.push_back(arg.name() + "_")
		if descriptor.is_vararg():
			var arg_descriptor := descriptor.varargs()[0]
			@warning_ignore("return_value_discarded")
			collect.push_back("...%s_: Array" % arg_descriptor.name())
		return ", ".join(collect)


	static func extract_arg_names(descriptor: GdFunctionDescriptor) -> PackedStringArray:
		var arg_names := PackedStringArray()
		for arg in descriptor.args():
			@warning_ignore("return_value_discarded")
			arg_names.append(arg._name + "_")
		return arg_names


	func _init(descriptor: GdFunctionDescriptor) -> void:
		self.fd = descriptor

		func_args = extract_arg_names(descriptor)
		func_signature = extract_func_signature(descriptor)
		default_return = GdFunctionDoubler.default_return_value(descriptor)
		reset()

	func reset() -> void:
		pass

	func is_void_func() -> bool:
		return fd.return_type() == TYPE_NIL or fd.return_type() == GdObjects.TYPE_VOID

	func with_args() -> String:
		return "\tvar __args := [$args]"\
			.replace("[$args]", "[$args]%s" % (" + varargs_" if fd.is_vararg() else ""))\
			.replace("$args", ", ".join(func_args))

	func with_verify_block() -> GdUnitFunctionDublerBuilder:
		verify_block = def_verify_block\
				.replace("$func_name", fd.name())\
				.replace("$default_return", "return" if is_void_func() else "return " + default_return)
		return self

	func with_prepare_block() -> GdUnitFunctionDublerBuilder:
		if fd.return_type() == TYPE_NIL or fd.return_type() == GdObjects.TYPE_VOID:
			prepare_block = def_void_prepare_block
			return self

		prepare_block = def_prepare_block\
				.replace("$func_name", fd.name())\
				.replace("$default_return", "return" if is_void_func() else "return " + default_return)
		return self

	func with_mocked_return_value() -> GdUnitFunctionDublerBuilder:
		if fd.return_type() == TYPE_NIL or fd.return_type() == GdObjects.TYPE_VOID:
			mock_return = def_void_mock_return.replace("$func_name", fd.name())
			return self

		mock_return = def_mock_return\
				.replace("$func_name", fd.name())\
				.replace("$default_return", "no_arg" if is_void_func() else default_return)
		return self

	func super_call_block() -> String:
		if !fd.is_vararg():
			return 'super(%s)\n' % ", ".join(func_args)

		var match_block := "match varargs_.size():\n"
		for i in range(0, 11):
			match_block += '%d: super(%s)\n'\
				.indent("\t") % [i, ", ".join(func_args + vararg_list(i))]
		match_block += '_: push_error("to many varradic arguments")\n'.indent("\t")
		match_block += '$default_return\n'.replace("$default_return", "return" if is_void_func() else "return " + default_return)
		return match_block


	func vararg_list(count: int) -> Array:
		var arg_list := []
		for index in count:
			arg_list.append("varargs_[%d]" % index)
		return arg_list


	func build() -> PackedStringArray:
		var func_body: PackedStringArray = []
		func_body.append(func_signature)
		func_body.append(with_args())
		if not prepare_block.is_empty():
			func_body.append(prepare_block)
		func_body.append(verify_block)
		if not mock_return.is_empty():
			func_body.append(mock_return)
		var super_calls := super_call_block()
		if not is_void_func():
			super_calls = super_calls.replace("super(", "return super(" )
		if fd.is_coroutine():
			super_calls = super_calls.replace("super(", "await super(" )
		func_body.append("")
		func_body.append(super_calls.indent("\t"))
		return func_body





func extract_arg_names(argument_signatures: Array[GdFunctionArgument], add_suffix := false) -> PackedStringArray:
	var arg_names := PackedStringArray()
	for arg in argument_signatures:
		@warning_ignore("return_value_discarded")
		arg_names.append(arg._name + ("_" if add_suffix else ""))
	return arg_names


static func extract_constructor_args(args :Array[GdFunctionArgument]) -> PackedStringArray:
	var constructor_args := PackedStringArray()
	for arg in args:
		var arg_name := arg._name + "_"
		var default_value := get_default(arg)
		if default_value == "null":
			@warning_ignore("return_value_discarded")
			constructor_args.append(arg_name + ":Variant=" + default_value)
		else:
			@warning_ignore("return_value_discarded")
			constructor_args.append(arg_name + ":=" + default_value)
	return constructor_args


static func get_default(arg :GdFunctionArgument) -> String:
	if arg.has_default():
		return arg.value_as_string()
	else:
		return DEFAULT_TYPED_RETURN_VALUES.get(arg.type(), "null")


static func await_is_coroutine(is_coroutine :bool) -> String:
	return "await " if is_coroutine else ""
