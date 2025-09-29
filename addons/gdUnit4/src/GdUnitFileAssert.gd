@abstract class_name GdUnitFileAssert
extends GdUnitAssert


## Verifies that the current value is null.
@abstract func is_null() -> GdUnitFileAssert


## Verifies that the current value is not null.
@abstract func is_not_null() -> GdUnitFileAssert


## Verifies that the current value is equal to the given one.
@abstract func is_equal(expected: Variant) -> GdUnitFileAssert


## Verifies that the current value is not equal to expected one.
@abstract func is_not_equal(expected: Variant) -> GdUnitFileAssert


func is_file() -> GdUnitFileAssert:
	return self


func exists() -> GdUnitFileAssert:
	return self


func is_script() -> GdUnitFileAssert:
	return self


@warning_ignore("unused_parameter")
func contains_exactly(expected_rows :Array) -> GdUnitFileAssert:
	return self
