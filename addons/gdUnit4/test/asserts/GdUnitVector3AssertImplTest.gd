# GdUnit generated TestSuite
class_name GdUnitVector3AssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitVector3AssertImpl.gd'


func test_is_null():
	assert_vector3(null).is_null()
	
	assert_failure(func(): assert_vector3(Vector3.ONE).is_null()) \
		.is_failed() \
		.starts_with_message("Expecting: '<null>' but was '(1, 1, 1)'")


func test_is_not_null():
	assert_vector3(Vector3.ONE).is_not_null()
	
	assert_failure(func(): assert_vector3(null).is_not_null()) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_is_equal() -> void:
	assert_vector3(Vector3.ONE).is_equal(Vector3.ONE)
	assert_vector3(Vector3.LEFT).is_equal(Vector3.LEFT)
	assert_vector3(Vector3(1.2, 1.000001, 1)).is_equal(Vector3(1.2, 1.000001, 1))
	
	assert_failure(func(): assert_vector3(Vector3.ONE).is_equal(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting:\n '(1.2, 1.000001, 1)'\n but was\n '(1, 1, 1)'")
	assert_failure(func(): assert_vector3(null).is_equal(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting:\n '(1.2, 1.000001, 1)'\n but was\n '<null>'")


func test_is_not_equal() -> void:
	assert_vector3(null).is_not_equal(Vector3.ONE)
	assert_vector3(Vector3.ONE).is_not_equal(Vector3.LEFT)
	assert_vector3(Vector3.LEFT).is_not_equal(Vector3.ONE)
	assert_vector3(Vector3(1.2, 1.000001, 1)).is_not_equal(Vector3(1.2, 1.000002, 1))
	
	assert_failure(func(): assert_vector3(Vector3(1.2, 1.000001, 1)).is_not_equal(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting:\n '(1.2, 1.000001, 1)'\n not equal to\n '(1.2, 1.000001, 1)'")


func test_is_equal_approx() -> void:
	assert_vector3(Vector3.ONE).is_equal_approx(Vector3.ONE, Vector3(0.004, 0.004, 0.004))
	assert_vector3(Vector3(0.996, 0.996, 0.996)).is_equal_approx(Vector3.ONE, Vector3(0.004, 0.004, 0.004))
	assert_vector3(Vector3(1.004, 1.004, 1.004)).is_equal_approx(Vector3.ONE, Vector3(0.004, 0.004, 0.004))
	
	assert_failure(func(): assert_vector3(Vector3(1.005, 1, 1)).is_equal_approx(Vector3.ONE, Vector3(0.004, 0.004, 0.004))) \
		.is_failed() \
		.has_message("Expecting:\n '(1.005, 1, 1)'\n in range between\n '(0.996, 0.996, 0.996)' <> '(1.004, 1.004, 1.004)'")
	assert_failure(func(): assert_vector3(Vector3(1, 0.995, 1)).is_equal_approx(Vector3.ONE, Vector3(0, 0.004, 0))) \
		.is_failed() \
		.has_message("Expecting:\n '(1, 0.995, 1)'\n in range between\n '(1, 0.996, 1)' <> '(1, 1.004, 1)'")
	assert_failure(func(): assert_vector3(null).is_equal_approx(Vector3.ONE, Vector3(0, 0.004, 0))) \
		.is_failed() \
		.has_message("Expecting:\n '<null>'\n in range between\n '(1, 0.996, 1)' <> '(1, 1.004, 1)'")


func test_is_less() -> void:
	assert_vector3(Vector3.LEFT).is_less(Vector3.ONE)
	assert_vector3(Vector3(1.2, 1.00001, 1)).is_less(Vector3(1.2, 1.00002, 1))
	
	assert_failure(func(): assert_vector3(Vector3.ONE).is_less(Vector3.ONE)) \
		.is_failed() \
		.has_message("Expecting to be less than:\n '(1, 1, 1)' but was '(1, 1, 1)'")
	assert_failure(func(): assert_vector3(Vector3(1.2, 1.000001, 1)).is_less(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting to be less than:\n '(1.2, 1.000001, 1)' but was '(1.2, 1.000001, 1)'")
	assert_failure(func(): assert_vector3(null).is_less(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting to be less than:\n '(1.2, 1.000001, 1)' but was '<null>'")


func test_is_less_equal() -> void:
	assert_vector3(Vector3.LEFT).is_less_equal(Vector3.ONE)
	assert_vector3(Vector3(1.2, 1.000001, 1)).is_less_equal(Vector3(1.2, 1.000001, 1))
	assert_vector3(Vector3(1.2, 1.000001, 1)).is_less_equal(Vector3(1.2, 1.000002, 1))
	
	assert_failure(func(): assert_vector3(Vector3.ONE).is_less_equal(Vector3.ZERO)) \
		.is_failed() \
		.has_message("Expecting to be less than or equal:\n '(0, 0, 0)' but was '(1, 1, 1)'")
	assert_failure(func(): assert_vector3(Vector3(1.2, 1.00002, 1)).is_less_equal(Vector3(1.2, 1.00001, 1))) \
		.is_failed() \
		.has_message("Expecting to be less than or equal:\n '(1.2, 1.00001, 1)' but was '(1.2, 1.00002, 1)'")
	assert_failure(func(): assert_vector3(null).is_less_equal(Vector3(1.2, 1.00001, 1))) \
		.is_failed() \
		.has_message("Expecting to be less than or equal:\n '(1.2, 1.00001, 1)' but was '<null>'")


func test_is_greater() -> void:
	assert_vector3(Vector3.ONE*2).is_greater(Vector3.ONE)
	assert_vector3(Vector3(1.2, 1.00002, 1)).is_greater(Vector3(1.2, 1.00001, 1))
	
	assert_failure(func(): assert_vector3(Vector3.ZERO).is_greater(Vector3.ONE)) \
		.is_failed() \
		.has_message("Expecting to be greater than:\n '(1, 1, 1)' but was '(0, 0, 0)'")
	assert_failure(func(): assert_vector3(Vector3(1.2, 1.000001, 1)).is_greater(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting to be greater than:\n '(1.2, 1.000001, 1)' but was '(1.2, 1.000001, 1)'")
	assert_failure(func(): assert_vector3(null).is_greater(Vector3(1.2, 1.000001, 1))) \
		.is_failed() \
		.has_message("Expecting to be greater than:\n '(1.2, 1.000001, 1)' but was '<null>'")


func test_is_greater_equal() -> void:
	assert_vector3(Vector3.ONE*2).is_greater_equal(Vector3.ONE)
	assert_vector3(Vector3.ONE).is_greater_equal(Vector3.ONE)
	assert_vector3(Vector3(1.2, 1.000001, 1)).is_greater_equal(Vector3(1.2, 1.000001, 1))
	assert_vector3(Vector3(1.2, 1.000002, 1)).is_greater_equal(Vector3(1.2, 1.000001, 1))
	
	assert_failure(func(): assert_vector3(Vector3.ZERO).is_greater_equal(Vector3.ONE)) \
		.is_failed() \
		.has_message("Expecting to be greater than or equal:\n '(1, 1, 1)' but was '(0, 0, 0)'")
	assert_failure(func(): assert_vector3(Vector3(1.2, 1.00002, 1)).is_greater_equal(Vector3(1.2, 1.00003, 1))) \
		.is_failed() \
		.has_message("Expecting to be greater than or equal:\n '(1.2, 1.00003, 1)' but was '(1.2, 1.00002, 1)'")
	assert_failure(func(): assert_vector3(null).is_greater_equal(Vector3(1.2, 1.00003, 1)))\
		.is_failed() \
		.has_message("Expecting to be greater than or equal:\n '(1.2, 1.00003, 1)' but was '<null>'")


func test_is_between(fuzzer = Fuzzers.rangev3(Vector3.ZERO, Vector3.ONE)):
	var value :Vector3 = fuzzer.next_value()
	assert_vector3(value).is_between(Vector3.ZERO, Vector3.ONE)
	
	assert_failure(func(): assert_vector3(Vector3(1, 1.00001, 1)).is_between(Vector3.ZERO, Vector3.ONE)) \
		.is_failed() \
		.has_message("Expecting:\n '(1, 1.00001, 1)'\n in range between\n '(0, 0, 0)' <> '(1, 1, 1)'")
	assert_failure(func(): assert_vector3(null).is_between(Vector3.ZERO, Vector3.ONE)) \
		.is_failed() \
		.has_message("Expecting:\n '<null>'\n in range between\n '(0, 0, 0)' <> '(1, 1, 1)'")


func test_is_not_between(fuzzer = Fuzzers.rangev3(Vector3.ONE, Vector3.ONE*2)):
	var value :Vector3 = fuzzer.next_value()
	assert_vector3(null).is_not_between(Vector3.ZERO, Vector3.ONE)
	assert_vector3(value).is_not_between(Vector3.ZERO, Vector3.ONE)
	
	assert_failure(func(): assert_vector3(Vector3.ONE).is_not_between(Vector3.ZERO, Vector3.ONE)) \
		.is_failed() \
		.has_message("Expecting:\n '(1, 1, 1)'\n not in range between\n '(0, 0, 0)' <> '(1, 1, 1)'")


func test_override_failure_message() -> void:
	assert_failure(func(): assert_vector3(Vector3.ONE) \
			.override_failure_message("Custom failure message") \
			.is_null()) \
		.is_failed() \
		.has_message("Custom failure message")


var _index = -1
var _values := [Vector3.ZERO, Vector3.ONE, Vector3.LEFT]
func next_value() -> Vector3:
	_index += 1
	return _values[_index]


func test_with_value_provider() -> void:
	assert_vector3(CallBackValueProvider.new(self, "next_value"))\
		.is_equal(Vector3.ZERO).is_equal(Vector3.ONE).is_equal(Vector3.LEFT)


# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_vector3(null).is_null()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_failure(func(): assert_vector3(RefCounted.new()).is_null()) \
		.is_failed()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_vector3(null).is_null()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
