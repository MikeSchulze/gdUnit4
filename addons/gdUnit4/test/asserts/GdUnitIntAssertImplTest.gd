# GdUnit generated TestSuite
class_name GdUnitIntAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitIntAssertImpl.gd'

func test_is_null():
	assert_int(null).is_null()
	# should fail because the current is not null
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_null()\
		.starts_with_failure_message("Expecting: '<null>' but was '23'")

func test_is_not_null():
	assert_int(23).is_not_null()
	# should fail because the current is null
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null()\
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_equal():
	assert_int(23).is_equal(23)
	# this assertion fails because 23 are not equal to 42
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(42)\
		.has_failure_message("Expecting:\n '42'\n but was\n '23'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(42)\
		.has_failure_message("Expecting:\n '42'\n but was\n '<null>'")

func test_is_not_equal():
	assert_int(null).is_not_equal(42)
	assert_int(23).is_not_equal(42)
	# this assertion fails because 23 are equal to 23 
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_not_equal(23)\
		.has_failure_message("Expecting:\n '23'\n not equal to\n '23'")


func test_is_less():
	assert_int(23).is_less(42)
	assert_int(23).is_less(24)
	# this assertion fails because 23 is not less than 23
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_less(23)\
		.has_failure_message("Expecting to be less than:\n '23' but was '23'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_less(23)\
		.has_failure_message("Expecting to be less than:\n '23' but was '<null>'")

func test_is_less_equal():
	assert_int(23).is_less_equal(42)
	assert_int(23).is_less_equal(23)
	# this assertion fails because 23 is not less than or equal to 22
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_less_equal(22)\
		.has_failure_message("Expecting to be less than or equal:\n '22' but was '23'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_less_equal(22)\
		.has_failure_message("Expecting to be less than or equal:\n '22' but was '<null>'")

func test_is_greater():
	assert_int(23).is_greater(20)
	assert_int(23).is_greater(22)
	# this assertion fails because 23 is not greater than 23
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_greater(23)\
		.has_failure_message("Expecting to be greater than:\n '23' but was '23'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_greater(23)\
		.has_failure_message("Expecting to be greater than:\n '23' but was '<null>'")

func test_is_greater_equal():
	assert_int(23).is_greater_equal(20)
	assert_int(23).is_greater_equal(23)
	# this assertion fails because 23 is not greater than 23
	assert_int(23, GdUnitAssert.EXPECT_FAIL) \
		.is_greater_equal(24)\
		.has_failure_message("Expecting to be greater than or equal:\n '24' but was '23'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_greater_equal(24)\
		.has_failure_message("Expecting to be greater than or equal:\n '24' but was '<null>'")

func test_is_even():
	assert_int(12).is_even()
	assert_int(13, GdUnitAssert.EXPECT_FAIL) \
		.is_even()\
		.has_failure_message("Expecting:\n '13' must be even")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_even()\
		.has_failure_message("Expecting:\n '<null>' must be even")

func test_is_odd():
	assert_int(13).is_odd()
	assert_int(12, GdUnitAssert.EXPECT_FAIL) \
		.is_odd()\
		.has_failure_message("Expecting:\n '12' must be odd")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_odd()\
		.has_failure_message("Expecting:\n '<null>' must be odd")

func test_is_negative():
	assert_int(-13).is_negative()
	assert_int(13, GdUnitAssert.EXPECT_FAIL) \
		.is_negative()\
		.has_failure_message("Expecting:\n '13' be negative")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_negative()\
		.has_failure_message("Expecting:\n '<null>' be negative")

func test_is_not_negative():
	assert_int(13).is_not_negative()
	assert_int(-13, GdUnitAssert.EXPECT_FAIL) \
		.is_not_negative()\
		.has_failure_message("Expecting:\n '-13' be not negative")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_negative()\
		.has_failure_message("Expecting:\n '<null>' be not negative")

func test_is_zero():
	assert_int(0).is_zero()
	# this assertion fail because the value is not zero
	assert_int(1, GdUnitAssert.EXPECT_FAIL) \
		.is_zero()\
		.has_failure_message("Expecting:\n equal to 0 but is '1'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_zero()\
		.has_failure_message("Expecting:\n equal to 0 but is '<null>'")

func test_is_not_zero():
	assert_int(null).is_not_zero()
	assert_int(1).is_not_zero()
	# this assertion fail because the value is not zero
	assert_int(0, GdUnitAssert.EXPECT_FAIL) \
		.is_not_zero()\
		.has_failure_message("Expecting:\n not equal to 0")

func test_is_in():
	assert_int(5).is_in([3, 4, 5, 6])
	# this assertion fail because 7 is not in [3, 4, 5, 6]
	assert_int(7, GdUnitAssert.EXPECT_FAIL) \
		.is_in([3, 4, 5, 6])\
		.has_failure_message("Expecting:\n '7'\n is in\n '[3, 4, 5, 6]'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_in([3, 4, 5, 6])\
		.has_failure_message("Expecting:\n '<null>'\n is in\n '[3, 4, 5, 6]'")

func test_is_not_in():
	assert_int(null).is_not_in([3, 4, 6, 7])
	assert_int(5).is_not_in([3, 4, 6, 7])
	# this assertion fail because 7 is not in [3, 4, 5, 6]
	assert_int(5, GdUnitAssert.EXPECT_FAIL) \
		.is_not_in([3, 4, 5, 6])\
		.has_failure_message("Expecting:\n '5'\n is not in\n '[3, 4, 5, 6]'")

func test_is_between(fuzzer = Fuzzers.rangei(-20, 20)):
	var value = fuzzer.next_value() as int
	assert_int(value).is_between(-20, 20)

func test_is_between_must_fail():
	assert_int(-10, GdUnitAssert.EXPECT_FAIL) \
		.is_between(-9, 0) \
		.has_failure_message("Expecting:\n '-10'\n in range between\n '-9' <> '0'")
	assert_int(0, GdUnitAssert.EXPECT_FAIL) \
		.is_between(1, 10) \
		.has_failure_message("Expecting:\n '0'\n in range between\n '1' <> '10'")
	assert_int(10, GdUnitAssert.EXPECT_FAIL) \
		.is_between(11, 21) \
		.has_failure_message("Expecting:\n '10'\n in range between\n '11' <> '21'")
	assert_int(null, GdUnitAssert.EXPECT_FAIL) \
		.is_between(11, 21) \
		.has_failure_message("Expecting:\n '<null>'\n in range between\n '11' <> '21'")

func test_must_fail_has_invlalid_type():
	assert_int(3.3, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitIntAssert inital error, unexpected type <float>")
	assert_int(true, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitIntAssert inital error, unexpected type <bool>")
	assert_int("foo", GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitIntAssert inital error, unexpected type <String>")
	assert_int(Resource.new(), GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitIntAssert inital error, unexpected type <Object>")

func test_override_failure_message() -> void:
	assert_int(314, GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

var _value := 0
func next_value() -> int:
	_value += 1
	return _value

func test_with_value_provider() -> void:
	assert_int(CallBackValueProvider.new(self, "next_value"))\
		.is_equal(1).is_equal(2).is_equal(3)

# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_int(0).is_zero()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_int(1, GdUnitAssert.EXPECT_FAIL).is_zero()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_int(0).is_zero()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
	
	# should abort here because we had an failing assert
	if is_failure():
		return
	assert_bool(true).override_failure_message("This line shold never be called").is_false()
