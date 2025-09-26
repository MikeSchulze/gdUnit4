class_name GdUnitSpyFunctionDoubler
extends GdFunctionDoubler


func double(func_descriptor: GdFunctionDescriptor) -> PackedStringArray:
	var func_name := func_descriptor.name()
	var args := func_descriptor.args()
	var arg_names := extract_arg_names(args, true)

	# save original constructor arguments
	if func_name == "_init":
		var constructor_args := ",".join(GdFunctionDoubler.extract_constructor_args(args))
		var constructor := """
			func _init(%s) -> void:
				super(%s)

			""".dedent() % [constructor_args, ", ".join(arg_names)]
		return constructor.split("\n")

	var doubled_function := GdUnitFunctionDublerBuilder.new(func_descriptor)\
		.with_verify_block()\
		.build()
	#prints("------------------------------")
	#prints("\n".join(doubled_function))
	#prints("------------------------------")

	return doubled_function
