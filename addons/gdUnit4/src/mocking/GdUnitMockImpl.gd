class_name DoubledMockClassSourceClassName

################################################################################
# internal mocking stuff
################################################################################

static var __excluded_methods__ := PackedStringArray()
static var __verifier_instance__ := GdUnitObjectInteractionsVerifier.new()
static var __working_mode__ := GdUnitMock.RETURN_DEFAULTS
static var __is_prepare_return__ := false
static var __return_values__ := Dictionary()
static var __return_value__: Variant = null


func __init(__script: GDScript, mock_working_mode: String) -> void:
	super.set_script(__script)
	__working_mode__ = mock_working_mode


static func __get_verifier() -> GdUnitObjectInteractionsVerifier:
	return __verifier_instance__


static func __is_prepare_return_value() -> bool:
	return __is_prepare_return__


static func __sort_by_argument_matcher(__left_args: Array, __right_args: Array) -> bool:
	for __index in __left_args.size():
		var __larg: Variant = __left_args[__index]
		if __larg is GdUnitArgumentMatcher:
			return false
	return true


# we need to sort by matcher arguments so that they are all at the end of the list
static func __sort_dictionary(__unsorted_args: Dictionary) -> Dictionary:
	# only need to sort if contains more than one entry
	if __unsorted_args.size() <= 1:
		return __unsorted_args
	var __sorted_args: Array = __unsorted_args.keys()
	__sorted_args.sort_custom(__sort_by_argument_matcher)
	var __sorted_result := {}
	for __index in __sorted_args.size():
		var key :Variant = __sorted_args[__index]
		__sorted_result[key] = __unsorted_args[key]
	return __sorted_result


static func __save_function_return_value(__func_name: String, __func_args: Array) -> void:
	var mocked_return_value_by_args: Dictionary = __return_values__.get(__func_name, {})

	mocked_return_value_by_args[__func_args] = __return_value__
	__return_values__[__func_name] = __sort_dictionary(mocked_return_value_by_args)
	__return_value__ = null
	__is_prepare_return__ = false


static func __is_mocked_args_match(__func_args: Array, __mocked_args: Array) -> bool:
	var __is_matching := false
	for __index in __mocked_args.size():
		var __fuction_args: Array = __mocked_args[__index]
		if __func_args.size() != __fuction_args.size():
			continue
		__is_matching = true
		for __arg_index in __func_args.size():
			var __func_arg: Variant = __func_args[__arg_index]
			var __mock_arg: Variant = __fuction_args[__arg_index]
			if __mock_arg is GdUnitArgumentMatcher:
				@warning_ignore("unsafe_method_access")
				__is_matching = __is_matching and __mock_arg.is_match(__func_arg)
			else:
				__is_matching = __is_matching and typeof(__func_arg) == typeof(__mock_arg) and __func_arg == __mock_arg
			if not __is_matching:
				break
		if __is_matching:
			break
	return __is_matching


static func __return_mock_value(__func_name: String, __func_args: Array, __default_return_value: Variant) -> Variant:
	if not __return_values__.has(__func_name):
		return __default_return_value
	@warning_ignore("unsafe_method_access")
	var __mocked_args: Array = __return_values__.get(__func_name).keys()
	for __index in __mocked_args.size():
		var __margs: Variant = __mocked_args[__index]
		if __is_mocked_args_match(__func_args, [__margs]):
			return __return_values__[__func_name][__margs]
	return __default_return_value


static func __is_do_not_call_real_func(__func_name: String, __func_args := []) -> bool:
	var __is_call_real_func: bool = __working_mode__ == GdUnitMock.CALL_REAL_FUNC  and not __excluded_methods__.has(__func_name)
	# do not call real funcions for mocked functions
	if __is_call_real_func and __return_values__.has(__func_name):
		@warning_ignore("unsafe_method_access")
		var __mocked_args: Array = __return_values__.get(__func_name).keys()
		return __is_mocked_args_match(__func_args, __mocked_args)
	return !__is_call_real_func


func __exclude_method_call(exluded_methods: PackedStringArray) -> void:
	__excluded_methods__.append_array(exluded_methods)


func __do_return(mock_do_return_value: Variant) -> Object:
	__return_value__ = mock_do_return_value
	__is_prepare_return__ = true
	return self
