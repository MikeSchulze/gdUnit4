# GdUnit generated TestSuite
class_name GdUnitVector2AssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitVector2AssertImpl.gd'

func test_is_null():
	assert_vector2(null).is_null()
	# should fail because the current is not null
	assert_vector2(Vector2.ONE, GdUnitAssert.EXPECT_FAIL) \
		.is_null()\
		.starts_with_failure_message("Expecting: '<null>' but was '(1, 1)'")

func test_is_not_null():
	assert_vector2(Vector2.ONE).is_not_null()
	# should fail because the current is null
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null()\
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_equal() -> void:
	assert_vector2(Vector2.ONE).is_equal(Vector2.ONE)
	assert_vector2(Vector2.LEFT).is_equal(Vector2.LEFT)
	assert_vector2(Vector2(1.2, 1.000001)).is_equal(Vector2(1.2, 1.000001))
	
	# false test
	assert_vector2(Vector2.ONE, GdUnitAssert.EXPECT_FAIL)\
		.is_equal(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting:\n '(1.2, 1.000001)'\n but was\n '(1, 1)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_equal(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting:\n '(1.2, 1.000001)'\n but was\n '<null>'")

func test_is_not_equal() -> void:
	assert_vector2(null).is_not_equal(Vector2.LEFT)
	assert_vector2(Vector2.ONE).is_not_equal(Vector2.LEFT)
	assert_vector2(Vector2.LEFT).is_not_equal(Vector2.ONE)
	assert_vector2(Vector2(1.2, 1.000001)).is_not_equal(Vector2(1.2, 1.000002))
	
	# false test
	assert_vector2(Vector2(1.2, 1.000001), GdUnitAssert.EXPECT_FAIL)\
		.is_not_equal(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting:\n '(1.2, 1.000001)'\n not equal to\n '(1.2, 1.000001)'")

func test_is_equal_approx() -> void:
	assert_vector2(Vector2.ONE).is_equal_approx(Vector2.ONE, Vector2(0.004, 0.004))
	assert_vector2(Vector2(0.996, 0.996)).is_equal_approx(Vector2.ONE, Vector2(0.004, 0.004))
	assert_vector2(Vector2(1.004, 1.004)).is_equal_approx(Vector2.ONE, Vector2(0.004, 0.004))
	
	# false test
	assert_vector2(Vector2(1.005, 1), GdUnitAssert.EXPECT_FAIL)\
		.is_equal_approx(Vector2.ONE, Vector2(0.004, 0.004))\
		.has_failure_message("Expecting:\n '(1.005, 1)'\n in range between\n '(0.996, 0.996)' <> '(1.004, 1.004)'")
	assert_vector2(Vector2(1, 0.995), GdUnitAssert.EXPECT_FAIL)\
		.is_equal_approx(Vector2.ONE, Vector2(0, 0.004))\
		.has_failure_message("Expecting:\n '(1, 0.995)'\n in range between\n '(1, 0.996)' <> '(1, 1.004)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_equal_approx(Vector2.ONE, Vector2(0, 0.004))\
		.has_failure_message("Expecting:\n '<null>'\n in range between\n '(1, 0.996)' <> '(1, 1.004)'")

func test_is_less() -> void:
	assert_vector2(Vector2.LEFT).is_less(Vector2.ONE)
	assert_vector2(Vector2(1.2, 1.000001)).is_less(Vector2(1.2, 1.000002))
	
	# false test
	assert_vector2(Vector2.ONE, GdUnitAssert.EXPECT_FAIL)\
		.is_less(Vector2.ONE)\
		.has_failure_message("Expecting to be less than:\n '(1, 1)' but was '(1, 1)'")
	assert_vector2(Vector2(1.2, 1.000001), GdUnitAssert.EXPECT_FAIL)\
		.is_less(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting to be less than:\n '(1.2, 1.000001)' but was '(1.2, 1.000001)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_less(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting to be less than:\n '(1.2, 1.000001)' but was '<null>'")

func test_is_less_equal() -> void:
	assert_vector2(Vector2.ONE).is_less_equal(Vector2.ONE)
	assert_vector2(Vector2(1.2, 1.000001)).is_less_equal(Vector2(1.2, 1.000001))
	assert_vector2(Vector2(1.2, 1.000001)).is_less_equal(Vector2(1.2, 1.000002))
	
	# false test
	assert_vector2(Vector2.ONE, GdUnitAssert.EXPECT_FAIL)\
		.is_less_equal(Vector2.ZERO)\
		.has_failure_message("Expecting to be less than or equal:\n '(0, 0)' but was '(1, 1)'")
	assert_vector2(Vector2(1.2, 1.000002), GdUnitAssert.EXPECT_FAIL)\
		.is_less_equal(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting to be less than or equal:\n '(1.2, 1.000001)' but was '(1.2, 1.000002)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_less_equal(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting to be less than or equal:\n '(1.2, 1.000001)' but was '<null>'")

func test_is_greater() -> void:
	assert_vector2(Vector2.ONE).is_greater(Vector2.RIGHT)
	assert_vector2(Vector2(1.2, 1.000002)).is_greater(Vector2(1.2, 1.000001))
	
	# false test
	assert_vector2(Vector2.ZERO, GdUnitAssert.EXPECT_FAIL)\
		.is_greater(Vector2.ONE)\
		.has_failure_message("Expecting to be greater than:\n '(1, 1)' but was '(0, 0)'")
	assert_vector2(Vector2(1.2, 1.000001), GdUnitAssert.EXPECT_FAIL)\
		.is_greater(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting to be greater than:\n '(1.2, 1.000001)' but was '(1.2, 1.000001)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_greater(Vector2(1.2, 1.000001))\
		.has_failure_message("Expecting to be greater than:\n '(1.2, 1.000001)' but was '<null>'")

func test_is_greater_equal() -> void:
	assert_vector2(Vector2.ONE*2).is_greater_equal(Vector2.ONE)
	assert_vector2(Vector2.ONE).is_greater_equal(Vector2.ONE)
	assert_vector2(Vector2(1.2, 1.000001)).is_greater_equal(Vector2(1.2, 1.000001))
	assert_vector2(Vector2(1.2, 1.000002)).is_greater_equal(Vector2(1.2, 1.000001))
	
	# false test
	assert_vector2(Vector2.ZERO, GdUnitAssert.EXPECT_FAIL)\
		.is_greater_equal(Vector2.ONE)\
		.has_failure_message("Expecting to be greater than or equal:\n '(1, 1)' but was '(0, 0)'")
	assert_vector2(Vector2(1.2, 1.000002), GdUnitAssert.EXPECT_FAIL)\
		.is_greater_equal(Vector2(1.2, 1.000003))\
		.has_failure_message("Expecting to be greater than or equal:\n '(1.2, 1.000003)' but was '(1.2, 1.000002)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_greater_equal(Vector2(1.2, 1.000003))\
		.has_failure_message("Expecting to be greater than or equal:\n '(1.2, 1.000003)' but was '<null>'")

func test_is_between(fuzzer = Fuzzers.rangev2(Vector2.ZERO, Vector2.ONE)):
	var value :Vector2 = fuzzer.next_value()
	assert_vector2(value).is_between(Vector2.ZERO, Vector2.ONE)

func test_is_between_fail():
	assert_vector2(Vector2(1, 1.00001), GdUnitAssert.EXPECT_FAIL)\
		.is_between(Vector2.ZERO, Vector2.ONE)\
		.has_failure_message("Expecting:\n '(1, 1.00001)'\n in range between\n '(0, 0)' <> '(1, 1)'")
	assert_vector2(null, GdUnitAssert.EXPECT_FAIL)\
		.is_between(Vector2.ZERO, Vector2.ONE)\
		.has_failure_message("Expecting:\n '<null>'\n in range between\n '(0, 0)' <> '(1, 1)'")

func test_is_not_between(fuzzer = Fuzzers.rangev2(Vector2.ONE, Vector2.ONE*2)):
	var value :Vector2 = fuzzer.next_value()
	assert_vector2(null).is_not_between(Vector2.ZERO, Vector2.ONE)
	assert_vector2(value).is_not_between(Vector2.ZERO, Vector2.ONE)

func test_is_not_between_fail():
	assert_vector2(Vector2.ONE, GdUnitAssert.EXPECT_FAIL)\
		.is_not_between(Vector2.ZERO, Vector2.ONE)\
		.has_failure_message("Expecting:\n '(1, 1)'\n not in range between\n '(0, 0)' <> '(1, 1)'")

func test_override_failure_message() -> void:
	assert_vector2(Vector2.ONE, GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

var _index = -1
var _values := [Vector2.ZERO, Vector2.ONE, Vector2.LEFT]
func next_value() -> Vector2:
	_index += 1
	return _values[_index]

func test_with_value_provider() -> void:
	assert_vector2(CallBackValueProvider.new(self, "next_value"))\
		.is_equal(Vector2.ZERO).is_equal(Vector2.ONE).is_equal(Vector2.LEFT)

# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_vector2(null).is_null()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_vector2(RefCounted.new(), GdUnitAssert.EXPECT_FAIL).is_null()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_vector2(null).is_null()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
