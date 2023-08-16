# GdUnit generated TestSuite
class_name GdUnitAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitAssertImpl.gd'

func before():
	assert_int(GdUnitAssert._get_line_number()).is_equal(9)
	assert_failure(func(): assert_int(10).is_equal(42)) \
		.is_failed() \
		.has_line(10) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func after():
	assert_failure(func(): assert_int(10).is_equal(42)) \
		.is_failed() \
		.has_line(17) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func before_test():
	assert_failure(func(): assert_int(10).is_equal(42)) \
		.is_failed() \
		.has_line(24) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func after_test():
	assert_failure(func(): assert_int(10).is_equal(42)) \
		.is_failed() \
		.has_line(31) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func test_get_line_number():
	# test to return the current line number for an failure
	assert_failure(func(): assert_int(10).is_equal(42)) \
		.is_failed() \
		.has_line(39) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func test_get_line_number_yielded():
	# test to return the current line number after using yield
	await get_tree().create_timer(0.100).timeout
	assert_failure(func(): assert_int(10).is_equal(42)) \
		.is_failed() \
		.has_line(48) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func test_get_line_number_multiline():
	# test to return the current line number for an failure
	# https://github.com/godotengine/godot/issues/43326
	assert_failure(func(): assert_int(10)\
			.is_not_negative()\
			.is_equal(42)) \
		.is_failed() \
		.has_line(57) \
		.has_message("Expecting:\n '42'\n but was\n '10'")


func test_get_line_number_verify():
	var obj = mock(RefCounted)
	assert_failure(func(): verify(obj, 1).get_reference_count()) \
		.is_failed() \
		.has_line(67) \
		.has_message("Expecting interaction on:\n	'get_reference_count()'	1 time's\nBut found interactions on:\n")


func test_is_null():
	assert_that(null).is_null()
	
	assert_failure(func(): assert_that(Color.RED).is_null()) \
		.is_failed() \
		.has_line(76) \
		.starts_with_message("Expecting: '<null>' but was 'Color(1, 0, 0, 1)'")


func test_is_not_null():
	assert_that(Color.RED).is_not_null()
	
	assert_failure(func(): assert_that(null).is_not_null()) \
		.is_failed() \
		.has_line(85) \
		.has_message("Expecting: not to be '<null>'")


func test_is_equal():
	assert_that(Color.RED).is_equal(Color.RED)
	assert_that(Plane.PLANE_XY).is_equal(Plane.PLANE_XY)
	
	assert_failure(func(): assert_that(Color.RED).is_equal(Color.GREEN)) \
		.is_failed() \
		.has_line(95) \
		.has_message("Expecting:\n 'Color(0, 1, 0, 1)'\n but was\n 'Color(1, 0, 0, 1)'")


func test_is_not_equal():
	assert_that(Color.RED).is_not_equal(Color.GREEN)
	assert_that(Plane.PLANE_XY).is_not_equal(Plane.PLANE_XZ)
	
	assert_failure(func(): assert_that(Color.RED).is_not_equal(Color.RED)) \
		.is_failed() \
		.has_line(105) \
		.has_message("Expecting:\n 'Color(1, 0, 0, 1)'\n not equal to\n 'Color(1, 0, 0, 1)'")


func test_override_failure_message() -> void:
	assert_failure(func(): assert_that(Color.RED) \
			.override_failure_message("Custom failure message") \
			.is_null()) \
		.is_failed() \
		.has_line(112) \
		.has_message("Custom failure message")
