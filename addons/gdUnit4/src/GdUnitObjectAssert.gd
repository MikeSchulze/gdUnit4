## An Assertion Tool to verify Object values
@abstract class_name GdUnitObjectAssert
extends GdUnitAssert


## Verifies that the current value is null.
@abstract func is_null() -> GdUnitObjectAssert


## Verifies that the current value is not null.
@abstract func is_not_null() -> GdUnitObjectAssert


## Verifies that the current value is equal to the given one.
@abstract func is_equal(expected: Variant) -> GdUnitObjectAssert


## Verifies that the current value is not equal to expected one.
@abstract func is_not_equal(expected: Variant) -> GdUnitObjectAssert


## Overrides the default failure message by given custom message.
@abstract func override_failure_message(message: String) -> GdUnitObjectAssert


## Verifies that the current object is the same as the given one.
@warning_ignore("unused_parameter", "shadowed_global_identifier")
func is_same(expected: Variant) -> GdUnitObjectAssert:
	return self


## Verifies that the current object is not the same as the given one.
@warning_ignore("unused_parameter")
func is_not_same(expected: Variant) -> GdUnitObjectAssert:
	return self


## Verifies that the current object is an instance of the given type.
@warning_ignore("unused_parameter")
func is_instanceof(type: Variant) -> GdUnitObjectAssert:
	return self


## Verifies that the current object is not an instance of the given type.
@warning_ignore("unused_parameter")
func is_not_instanceof(type: Variant) -> GdUnitObjectAssert:
	return self


## Checks whether the current object inherits from the specified type.
@warning_ignore("unused_parameter")
func is_inheriting(type: Variant) -> GdUnitObjectAssert:
	return self


## Checks whether the current object does NOT inherit from the specified type.
@warning_ignore("unused_parameter")
func is_not_inheriting(type: Variant) -> GdUnitObjectAssert:
	return self
