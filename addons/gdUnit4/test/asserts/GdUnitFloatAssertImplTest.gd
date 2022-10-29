# GdUnit generated TestSuite
class_name GdUnitFloatAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitFloatAssertImpl.gd'

func test_is_null():
	assert_float(null).is_null()
	# should fail because the current is not null
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_null()\
		.starts_with_failure_message("Expecting: '<null>' but was '23.200000'")

func test_is_not_null():
	assert_float(23.2).is_not_null()
	# should fail because the current is null
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null()\
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_equal():
	assert_float(23.2).is_equal(23.2)
	# this assertion fails because 23.2 are not equal to 23.4
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(23.4)\
		.has_failure_message("Expecting:\n '23.400000'\n but was\n '23.200000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(23.4)\
		.has_failure_message("Expecting:\n '23.400000'\n but was\n '<null>'")

func test_is_not_equal():
	assert_float(null).is_not_equal(23.4)
	assert_float(23.2).is_not_equal(23.4)
	# this assertion fails because 23.2 are equal to 23.2
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_not_equal(23.2)\
		.has_failure_message("Expecting:\n '23.200000'\n not equal to\n '23.200000'")

func test_is_equal_approx() -> void:
	assert_float(23.2).is_equal_approx(23.2, 0.01)
	assert_float(23.19).is_equal_approx(23.2, 0.01)
	assert_float(23.20).is_equal_approx(23.2, 0.01)
	assert_float(23.21).is_equal_approx(23.2, 0.01)
	
	#false test
	assert_float(23.18, GdUnitAssert.EXPECT_FAIL)\
		.is_equal_approx(23.2, 0.01)\
		.has_failure_message("Expecting:\n '23.180000'\n in range between\n '23.190000' <> '23.210000'")
	assert_float(23.22, GdUnitAssert.EXPECT_FAIL)\
		.is_equal_approx(23.2, 0.01)\
		.has_failure_message("Expecting:\n '23.220000'\n in range between\n '23.190000' <> '23.210000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL)\
		.is_equal_approx(23.2, 0.01)\
		.has_failure_message("Expecting:\n '<null>'\n in range between\n '23.190000' <> '23.210000'")

func test_is_less():
	assert_float(23.2).is_less(23.4)
	assert_float(23.2).is_less(26.0)
	# this assertion fails because 23.2 is not less than 23.2
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_less(23.2)\
		.has_failure_message("Expecting to be less than:\n '23.200000' but was '23.200000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_less(23.2)\
		.has_failure_message("Expecting to be less than:\n '23.200000' but was '<null>'")

func test_is_less_equal():
	assert_float(23.2).is_less_equal(23.4)
	assert_float(23.2).is_less_equal(23.2)
	# this assertion fails because 23.2 is not less than or equal to 23.1
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_less_equal(23.1)\
		.has_failure_message("Expecting to be less than or equal:\n '23.100000' but was '23.200000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_less_equal(23.1)\
		.has_failure_message("Expecting to be less than or equal:\n '23.100000' but was '<null>'")

func test_is_greater():
	assert_float(23.2).is_greater(23.0)
	assert_float(23.4).is_greater(22.1)
	# this assertion fails because 23.2 is not greater than 23.2
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_greater(23.2)\
		.has_failure_message("Expecting to be greater than:\n '23.200000' but was '23.200000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_greater(23.2)\
		.has_failure_message("Expecting to be greater than:\n '23.200000' but was '<null>'")

func test_is_greater_equal():
	assert_float(23.2).is_greater_equal(20.2)
	assert_float(23.2).is_greater_equal(23.2)
	# this assertion fails because 23.2 is not greater than 23.3
	assert_float(23.2, GdUnitAssert.EXPECT_FAIL) \
		.is_greater_equal(23.3)\
		.has_failure_message("Expecting to be greater than or equal:\n '23.300000' but was '23.200000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_greater_equal(23.3)\
		.has_failure_message("Expecting to be greater than or equal:\n '23.300000' but was '<null>'")

func test_is_negative():
	assert_float(-13.2).is_negative()
	# this assertion fails because is not negative
	assert_float(13.2, GdUnitAssert.EXPECT_FAIL) \
		.is_negative()\
		.has_failure_message("Expecting:\n '13.200000' be negative")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_negative()\
		.has_failure_message("Expecting:\n '<null>' be negative")

func test_is_not_negative():
	assert_float(13.2).is_not_negative()
	# this assertion fails because is negative
	assert_float(-13.2, GdUnitAssert.EXPECT_FAIL) \
		.is_not_negative()\
		.has_failure_message("Expecting:\n '-13.200000' be not negative")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_negative()\
		.has_failure_message("Expecting:\n '<null>' be not negative")

func test_is_zero():
	assert_float(0.0).is_zero()
	# this assertion fail because the value is not zero
	assert_float(0.00001, GdUnitAssert.EXPECT_FAIL) \
		.is_zero()\
		.has_failure_message("Expecting:\n equal to 0 but is '0.000010'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_zero()\
		.has_failure_message("Expecting:\n equal to 0 but is '<null>'")

func test_is_not_zero():
	assert_float(0.00001).is_not_zero()
	# this assertion fail because the value is not zero
	assert_float(0.000001, GdUnitAssert.EXPECT_FAIL) \
		.is_not_zero()\
		.has_failure_message("Expecting:\n not equal to 0")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_zero()\
		.has_failure_message("Expecting:\n not equal to 0")

func test_is_in():
	assert_float(5.2).is_in([5.1, 5.2, 5.3, 5.4])
	# this assertion fail because 5.5 is not in [5.1, 5.2, 5.3, 5.4]
	assert_float(5.5, GdUnitAssert.EXPECT_FAIL) \
		.is_in([5.1, 5.2, 5.3, 5.4])\
		.has_failure_message("Expecting:\n '5.500000'\n is in\n '[5.1, 5.2, 5.3, 5.4]'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_in([5.1, 5.2, 5.3, 5.4])\
		.has_failure_message("Expecting:\n '<null>'\n is in\n '[5.1, 5.2, 5.3, 5.4]'")

func test_is_not_in():
	assert_float(null).is_not_in([5.1, 5.3, 5.4])
	assert_float(5.2).is_not_in([5.1, 5.3, 5.4])
	# this assertion fail because 5.2 is not in [5.1, 5.2, 5.3, 5.4]
	assert_float(5.2, GdUnitAssert.EXPECT_FAIL) \
		.is_not_in([5.1, 5.2, 5.3, 5.4])\
		.has_failure_message("Expecting:\n '5.200000'\n is not in\n '[5.1, 5.2, 5.3, 5.4]'")

func test_is_between():
	assert_float(-20.0).is_between(-20.0, 20.9)
	assert_float(10.0).is_between(-20.0, 20.9)
	assert_float(20.9).is_between(-20.0, 20.9)

func test_is_between_must_fail():
	assert_float(-10.0, GdUnitAssert.EXPECT_FAIL) \
		.is_between(-9.0, 0.0) \
		.has_failure_message("Expecting:\n '-10.000000'\n in range between\n '-9.000000' <> '0.000000'")
	assert_float(0.0, GdUnitAssert.EXPECT_FAIL) \
		.is_between(1, 10) \
		.has_failure_message("Expecting:\n '0.000000'\n in range between\n '1.000000' <> '10.000000'")
	assert_float(10.0, GdUnitAssert.EXPECT_FAIL) \
		.is_between(11, 21) \
		.has_failure_message("Expecting:\n '10.000000'\n in range between\n '11.000000' <> '21.000000'")
	assert_float(null, GdUnitAssert.EXPECT_FAIL) \
		.is_between(11, 21) \
		.has_failure_message("Expecting:\n '<null>'\n in range between\n '11.000000' <> '21.000000'")

func test_must_fail_has_invlalid_type():
	assert_float(1, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitFloatAssert inital error, unexpected type <int>")
	assert_float(true, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitFloatAssert inital error, unexpected type <bool>")
	assert_float("foo", GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitFloatAssert inital error, unexpected type <String>")
	assert_float(Resource.new(), GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitFloatAssert inital error, unexpected type <Object>")

func test_override_failure_message() -> void:
	assert_float(3.14, GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

var _value :float = 0
func next_value() -> float:
	_value += 1.1
	return _value

func test_with_value_provider() -> void:
	assert_float(CallBackValueProvider.new(self, "next_value"))\
		.is_equal(1.1).is_equal(2.2)

# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_float(0.0).is_zero()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_float(1.0, GdUnitAssert.EXPECT_FAIL).is_zero()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_float(0.0).is_zero()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
	
	# should abort here because we had an failing assert
	if is_failure():
		return
	assert_bool(true).override_failure_message("This line shold never be called").is_false()
