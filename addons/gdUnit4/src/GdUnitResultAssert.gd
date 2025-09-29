## An Assertion Tool to verify Results
@abstract class_name GdUnitResultAssert
extends GdUnitAssert


## Verifies that the current value is null.
@abstract func is_null() -> GdUnitResultAssert


## Verifies that the current value is not null.
@abstract func is_not_null() -> GdUnitResultAssert


## Verifies that the current value is equal to the given one.
@abstract func is_equal(expected: Variant) -> GdUnitResultAssert


## Verifies that the current value is not equal to expected one.
@abstract func is_not_equal(expected: Variant) -> GdUnitResultAssert


## Overrides the default failure message by given custom message.
@abstract func override_failure_message(message: String) -> GdUnitResultAssert


## Appends a custom message to the failure message.
@abstract func append_failure_message(message: String) -> GdUnitResultAssert


## Verifies that the result is ends up with empty
func is_empty() -> GdUnitResultAssert:
	return self


## Verifies that the result is ends up with success
func is_success() -> GdUnitResultAssert:
	return self


## Verifies that the result is ends up with warning
func is_warning() -> GdUnitResultAssert:
	return self


## Verifies that the result is ends up with error
func is_error() -> GdUnitResultAssert:
	return self


## Verifies that the result contains the given message
@warning_ignore("unused_parameter")
func contains_message(expected :String) -> GdUnitResultAssert:
	return self


## Verifies that the result contains the given value
@warning_ignore("unused_parameter")
func is_value(expected :Variant) -> GdUnitResultAssert:
	return self
