class_name GdUnitVector2AssertImpl
extends GdUnitVector2Assert

var _base: GdUnitAssert


func _init(current):
	_base = GdUnitAssertImpl.new(current)
	# save the actual assert instance on the current thread context
	GdUnitThreadManager.get_current_context().set_assert(self)
	if not _base.__validate_value_type(current, TYPE_VECTOR2):
		report_error("GdUnitVector2Assert inital error, unexpected type <%s>" % GdObjects.typeof_as_string(current))


func _notification(event):
	if event == NOTIFICATION_PREDELETE:
		if _base != null:
			_base.notification(event)
			_base = null


func __current() -> Variant:
	return _base.__current()


func report_success() -> GdUnitVector2Assert:
	_base.report_success()
	return self


func report_error(error :String) -> GdUnitVector2Assert:
	_base.report_error(error)
	return self


func _failure_message() -> String:
	return _base._current_error_message


func override_failure_message(message :String) -> GdUnitVector2Assert:
	_base.override_failure_message(message)
	return self


func is_null() -> GdUnitVector2Assert:
	_base.is_null()
	return self


func is_not_null() -> GdUnitVector2Assert:
	_base.is_not_null()
	return self


func is_equal(expected :Vector2) -> GdUnitVector2Assert:
	_base.is_equal(expected)
	return self


func is_not_equal(expected :Vector2) -> GdUnitVector2Assert:
	_base.is_not_equal(expected)
	return self


@warning_ignore("shadowed_global_identifier")
func is_equal_approx(expected :Vector2, approx :Vector2) -> GdUnitVector2Assert:
	return is_between(expected-approx, expected+approx)


func is_less(expected :Vector2) -> GdUnitVector2Assert:
	var current = __current()
	if current == null or current >= expected:
		return report_error(GdAssertMessages.error_is_value(Comparator.LESS_THAN, current, expected))
	return report_success()


func is_less_equal(expected :Vector2) -> GdUnitVector2Assert:
	var current = __current()
	if current == null or current > expected:
		return report_error(GdAssertMessages.error_is_value(Comparator.LESS_EQUAL, current, expected))
	return report_success()


func is_greater(expected :Vector2) -> GdUnitVector2Assert:
	var current = __current()
	if current == null or current <= expected:
		return report_error(GdAssertMessages.error_is_value(Comparator.GREATER_THAN, current, expected))
	return report_success()


func is_greater_equal(expected :Vector2) -> GdUnitVector2Assert:
	var current = __current()
	if current == null or current < expected:
		return report_error(GdAssertMessages.error_is_value(Comparator.GREATER_EQUAL, current, expected))
	return report_success()


func is_between(from :Vector2, to :Vector2) -> GdUnitVector2Assert:
	var current = __current()
	if current == null or not (current >= from and current <= to):
		return report_error(GdAssertMessages.error_is_value(Comparator.BETWEEN_EQUAL, current, from, to))
	return report_success()


func is_not_between(from :Vector2, to :Vector2) -> GdUnitVector2Assert:
	var current = __current()
	if (current != null and current >= from and current <= to):
		return report_error(GdAssertMessages.error_is_value(Comparator.NOT_BETWEEN_EQUAL, current, from, to))
	return report_success()
