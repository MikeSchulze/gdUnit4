class_name GdUnitSpyFunctionDoubler 
extends GdFunctionDoubler

const TEMPLATE_RETURN_VARIANT = """
	var args :Array = ["$(func_name)", $(arguments)]
	
	if $(instance)__is_verify_interactions():
		$(instance)__verify_interactions(args)
		return ${default_return_value}
	else:
		$(instance)__save_function_interaction(args)
	
	return $(await)super.$(func_name)($(func_arg))
"""

const TEMPLATE_RETURN_VOID = """
	var args :Array = ["$(func_name)", $(arguments)]
	
	if $(instance)__is_verify_interactions():
		$(instance)__verify_interactions(args)
		return
	else:
		$(instance)__save_function_interaction(args)
	
	$(await)super.$(func_name)($(func_arg))
"""

const TEMPLATE_RETURN_VOID_VARARG = """
	var varargs :Array = __filter_vargs([$(varargs)])
	var args :Array = ["$(func_name)", $(arguments)] + varargs
	
	if $(instance)__is_verify_interactions():
		$(instance)__verify_interactions(args)
		return
	else:
		$(instance)__save_function_interaction(args)
	
	$(await)__instance_delegator.callv("$(func_name)", [$(arguments)] + varargs)
"""

const TEMPLATE_RETURN_VARIANT_VARARG = """
	var varargs :Array = __filter_vargs([$(varargs)])
	var args :Array = ["$(func_name)", $(arguments)] + varargs
	
	if $(instance)__is_verify_interactions():
		$(instance)__verify_interactions(args)
		return ${default_return_value}
	else:
		$(instance)__save_function_interaction(args)
	
	return $(await)__instance_delegator.callv("$(func_name)", [$(arguments)] + varargs)
"""





func _init(push_errors :bool = false):
	super._init(push_errors)

func get_template(return_type :int, is_vararg :bool, is_args :bool) -> String:
	if is_vararg:
		return TEMPLATE_RETURN_VOID_VARARG.trim_prefix("\n") if return_type == TYPE_NIL else TEMPLATE_RETURN_VARIANT_VARARG.trim_prefix("\n")
	return TEMPLATE_RETURN_VOID.trim_prefix("\n") if (return_type == TYPE_NIL or return_type == GdObjects.TYPE_VOID) else TEMPLATE_RETURN_VARIANT.trim_prefix("\n")
