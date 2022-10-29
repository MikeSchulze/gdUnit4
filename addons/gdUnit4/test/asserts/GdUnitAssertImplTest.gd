# GdUnit generated TestSuite
class_name GdUnitAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitAssertImpl.gd'

func before():
	assert_int(GdUnitAssertImpl._get_line_number()).is_equal(9)

func after():
	assert_int(10, GdUnitAssert.EXPECT_FAIL).is_equal(42)
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(12)

func before_test():
	assert_int(10, GdUnitAssert.EXPECT_FAIL).is_equal(42)
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(16)

func after_test():
	assert_int(10, GdUnitAssert.EXPECT_FAIL).is_equal(42)
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(20)

func test_get_line_number():
	# test to return the current line number for an failure
	assert_int(10, GdUnitAssert.EXPECT_FAIL).is_equal(42)
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(25)

func test_get_line_number_yielded():
	# test to return the current line number after using yield
	await get_tree().create_timer(0.100).timeout
	assert_int(10, GdUnitAssert.EXPECT_FAIL).is_equal(42)
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(31)

func test_get_line_number_multiline():
	# test to return the current line number for an failure
	# https://github.com/godotengine/godot/issues/43326
	assert_int(10, GdUnitAssert.EXPECT_FAIL).is_not_negative().is_equal(42)
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(37)

func test_get_line_number_verify():
	var obj = mock(RefCounted)
	verify(obj, 1, GdUnitAssert.EXPECT_FAIL).get_reference_count()
	assert_int(GdAssertReports.get_last_error_line_number()).is_equal(42)

func test_is_null():
	assert_that(null).is_null()
	# should fail because the current is not null
	assert_that(Color.RED, GdUnitAssert.EXPECT_FAIL) \
		.is_null()\
		.starts_with_failure_message("Expecting: '<null>' but was 'Color(1, 0, 0, 1)'")

func test_is_not_null():
	assert_that(Color.RED).is_not_null()
	# should fail because the current is null
	assert_that(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null()\
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_equal():
	assert_that(Color.RED).is_equal(Color.RED)
	assert_that(Plane.PLANE_XY).is_equal(Plane.PLANE_XY)
	assert_that(Color.RED, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(Color.GREEN) \
		.has_failure_message("Expecting:\n 'Color(0, 1, 0, 1)'\n but was\n 'Color(1, 0, 0, 1)'")

func test_is_not_equal():
	assert_that(Color.RED).is_not_equal(Color.GREEN)
	assert_that(Plane.PLANE_XY).is_not_equal(Plane.PLANE_XZ)
	assert_that(Color.RED, GdUnitAssert.EXPECT_FAIL) \
		.is_not_equal(Color.RED) \
		.has_failure_message("Expecting:\n 'Color(1, 0, 0, 1)'\n not equal to\n 'Color(1, 0, 0, 1)'")

func test_override_failure_message() -> void:
	assert_that(Color.RED, GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

func test_construct_with_value() -> void:
	var assert_imp := GdUnitAssertImpl.new(self, "a value")
	assert_bool(assert_imp._current_value_provider is DefaultValueProvider).is_true()
	assert_str(assert_imp.__current()).is_equal("a value")

var _value = 0
func next_value() -> int:
	_value += 1
	return _value

func test_construct_with_value_provider() -> void:
	var assert_imp := GdUnitAssertImpl.new(self, CallBackValueProvider.new(self, "next_value"))
	assert_bool(assert_imp._current_value_provider is CallBackValueProvider).is_true()
	assert_int(assert_imp.__current()).is_equal(1)
	assert_int(assert_imp.__current()).is_equal(2)
	assert_int(assert_imp.__current()).is_equal(3)
