# GdUnit generated TestSuite
class_name GdUnitFailureAssertImplTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitFailureAssertImpl.gd'


func test_has_line() -> void:
	assert_failure(func(): assert_bool(true).is_false()) \
		.is_failed() \
		.has_line(12)


func test_has_message() -> void:
	assert_failure(func(): assert_bool(true).is_true()) \
		.is_success()
	assert_failure(func(): assert_bool(true).is_false()) \
		.is_failed()\
		.has_message("Expecting: 'false' but is 'true'")


func test_starts_with_message() -> void:
	assert_failure(func(): assert_bool(true).is_false()) \
		.is_failed()\
		.starts_with_message("Expecting: 'false' bu")


func test_assert_failure_on_invalid_cb() -> void:
	assert_failure(func(): prints())\
		.is_failed()\
		.has_message("Invalid Callable! It must be a callable of 'GdUnitAssert'")


@warning_ignore("unused_parameter")
func test_assert_failure_on_assert(test_name :String, assert_type, value, test_parameters = [
	["GdUnitBoolAssert", GdUnitBoolAssert, true],
	["GdUnitStringAssert", GdUnitStringAssert, "value"],
	["GdUnitIntAssert", GdUnitIntAssert, 42],
	["GdUnitFloatAssert", GdUnitFloatAssert, 42.0],
	["GdUnitObjectAssert", GdUnitObjectAssert, RefCounted.new()],
	["GdUnitVector2Assert", GdUnitVector2Assert, Vector2.ZERO],
	["GdUnitVector3Assert", GdUnitVector3Assert, Vector3.ZERO],
	["GdUnitArrayAssert", GdUnitArrayAssert, Array()],
	["GdUnitDictionaryAssert", GdUnitDictionaryAssert, {}],
]) -> void:
	var  instance := assert_failure(func(): assert_that(value))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)
	assert_object(instance._current).is_instanceof(assert_type)


func test_assert_failure_on_assert_file() -> void:
	var  instance := assert_failure(func(): assert_file("res://foo.gd"))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)
	assert_object(instance._current).is_instanceof(GdUnitFileAssert)


func test_assert_failure_on_assert_func() -> void:
	var  instance := assert_failure(func(): assert_func(RefCounted.new(), "_to_string"))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)
	assert_object(instance._current).is_instanceof(GdUnitFuncAssert)


func test_assert_failure_on_assert_signal() -> void:
	var  instance := assert_failure(func(): assert_signal(null))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)
	assert_object(instance._current).is_instanceof(GdUnitSignalAssert)


func test_assert_failure_on_assert_result() -> void:
	var  instance := assert_failure(func(): assert_result(null))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)
	assert_object(instance._current).is_instanceof(GdUnitResultAssert)
