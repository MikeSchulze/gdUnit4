class_name GdUnitDictionaryAssertImpl
extends GdUnitDictionaryAssert

var _base :GdUnitAssert


func _init(current):
	_base = GdUnitAssertImpl.new(current)
	# save the actual assert instance on the current thread context
	GdUnitThreadManager.get_current_context().set_assert(self)
	if not _base.__validate_value_type(current, TYPE_DICTIONARY):
		report_error("GdUnitDictionaryAssert inital error, unexpected type <%s>" % GdObjects.typeof_as_string(current))


func _notification(event):
	if event == NOTIFICATION_PREDELETE:
		if _base != null:
			_base.notification(event)
			_base = null


func report_success() -> GdUnitDictionaryAssert:
	_base.report_success()
	return self


func report_error(error :String) -> GdUnitDictionaryAssert:
	_base.report_error(error)
	return self


func _failure_message() -> String:
	return _base._current_error_message


func override_failure_message(message :String) -> GdUnitDictionaryAssert:
	_base.override_failure_message(message)
	return self


func __current() -> Variant:
	return _base.__current()


func __expected(expected) -> Variant:
	return expected


func is_null() -> GdUnitDictionaryAssert:
	_base.is_null()
	return self


func is_not_null() -> GdUnitDictionaryAssert:
	_base.is_not_null()
	return self


func is_equal(expected) -> GdUnitDictionaryAssert:
	var current = __current()
	expected = __expected(expected)
	if current == null:
		return report_error(GdAssertMessages.error_equal(null, GdAssertMessages._format_dict(expected)))
	if not GdObjects.equals(current, expected):
		var c := GdAssertMessages._format_dict(current)
		var e := GdAssertMessages._format_dict(expected)
		var diff := GdDiffTool.string_diff(c, e)
		var curent_ = GdAssertMessages._colored_array_div(diff[1])
		return report_error(GdAssertMessages.error_equal(curent_, e))
	return report_success()


func is_not_equal(expected) -> GdUnitDictionaryAssert:
	var current = __current()
	expected = __expected(expected)
	if GdObjects.equals(current, expected):
		return report_error(GdAssertMessages.error_not_equal(current, expected))
	return report_success()


func is_empty() -> GdUnitDictionaryAssert:
	var current = __current()
	if current == null or not current.is_empty():
		return report_error(GdAssertMessages.error_is_empty(current))
	return report_success()


func is_not_empty() -> GdUnitDictionaryAssert:
	var current = __current()
	if current == null or current.is_empty():
		return report_error(GdAssertMessages.error_is_not_empty())
	return report_success()


func has_size(expected: int) -> GdUnitDictionaryAssert:
	var current = __current()
	if current == null:
		return report_error(GdAssertMessages.error_is_not_null())
	if current.size() != expected:
		return report_error(GdAssertMessages.error_has_size(current, expected))
	return report_success()


func contains_keys(expected :Array) -> GdUnitDictionaryAssert:
	var current = __current()
	if current == null:
		return report_error(GdAssertMessages.error_is_not_null())
	# find expected keys
	var keys_not_found := expected.duplicate()
	for key in current.keys():
		keys_not_found.erase(key)
	if not keys_not_found.is_empty():
		return report_error(GdAssertMessages.error_contains_keys(current.keys(), expected, keys_not_found))
	return report_success()


func contains_not_keys(expected :Array) -> GdUnitDictionaryAssert:
	var current = __current()
	if current == null:
		return report_error(GdAssertMessages.error_is_not_null())
	# find not expected keys
	var keys_found := Array()
	var current_keys = current.keys()
	for do_not_contain_key in expected:
		if current_keys.has(do_not_contain_key):
			keys_found.append(do_not_contain_key)
	if not keys_found.is_empty():
		return report_error(GdAssertMessages.error_not_contains_keys(current.keys(), expected, keys_found))
	return report_success()


func contains_key_value(key, value) -> GdUnitDictionaryAssert:
	var current = __current()
	if current == null:
		return report_error(GdAssertMessages.error_is_not_null())
	if not current.has(key):
		return report_error(GdAssertMessages.error_contains_keys(current.keys(), [key], [key]))
	if not GdObjects.equals(current[key], value):
		return report_error(GdAssertMessages.error_contains_key_value(key, value, current[key]))
	return report_success()
