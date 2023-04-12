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


func test_assert_failure_on_assert_bool() -> void:
	var  instance := assert_failure(func(): assert_bool(true))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)


func test_assert_failure_on_assert_str() -> void:
	var  instance := assert_failure(func(): assert_str("foo"))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)


func test_assert_failure_on_assert_int() -> void:
	var  instance := assert_failure(func(): assert_int(42))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)


func test_assert_failure_on_assert_float() -> void:
	var  instance := assert_failure(func(): assert_float(42.0))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)


func test_assert_failure_on_assert_object() -> void:
	var  instance := assert_failure(func(): assert_object(RefCounted.new()))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)


func test_assert_failure_on_assert_vector2() -> void:
	var  instance := assert_failure(func(): assert_vector2(Vector2.ZERO))
	assert_object(instance).is_instanceof(GdUnitFailureAssertImpl)
