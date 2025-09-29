## An Assertion Tool to verify float values
@abstract class_name GdUnitFloatAssert
extends GdUnitAssert


## Verifies that the current value is null.
@abstract func is_null() -> GdUnitFloatAssert


## Verifies that the current value is not null.
@abstract func is_not_null() -> GdUnitFloatAssert


## Verifies that the current value is equal to the given one.
@abstract func is_equal(expected: Variant) -> GdUnitFloatAssert


## Verifies that the current value is not equal to expected one.
@abstract func is_not_equal(expected: Variant) -> GdUnitFloatAssert


## Verifies that the current and expected value are approximately equal.
@warning_ignore("unused_parameter", "shadowed_global_identifier")
func is_equal_approx(expected :float, approx :float) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is less than the given one.
@warning_ignore("unused_parameter")
func is_less(expected :float) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is less than or equal the given one.
@warning_ignore("unused_parameter")
func is_less_equal(expected :float) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is greater than the given one.
@warning_ignore("unused_parameter")
func is_greater(expected :float) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is greater than or equal the given one.
@warning_ignore("unused_parameter")
func is_greater_equal(expected :float) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is negative.
func is_negative() -> GdUnitFloatAssert:
	return self


## Verifies that the current value is not negative.
func is_not_negative() -> GdUnitFloatAssert:
	return self


## Verifies that the current value is equal to zero.
func is_zero() -> GdUnitFloatAssert:
	return self


## Verifies that the current value is not equal to zero.
func is_not_zero() -> GdUnitFloatAssert:
	return self


## Verifies that the current value is in the given set of values.
@warning_ignore("unused_parameter")
func is_in(expected :Array) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is not in the given set of values.
@warning_ignore("unused_parameter")
func is_not_in(expected :Array) -> GdUnitFloatAssert:
	return self


## Verifies that the current value is between the given boundaries (inclusive).
@warning_ignore("unused_parameter")
func is_between(from :float, to :float) -> GdUnitFloatAssert:
	return self
