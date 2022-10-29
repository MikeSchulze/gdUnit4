# GdUnit generated TestSuite
class_name GdUnitBoolAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitBoolAssertImpl.gd'

func test_is_true():
	assert_bool(true).is_true()
	assert_bool(false, GdUnitAssert.EXPECT_FAIL).is_true() \
		.has_failure_message("Expecting: 'true' but is 'false'")
	assert_bool(null, GdUnitAssert.EXPECT_FAIL).is_true() \
		.has_failure_message("Expecting: 'true' but is '<null>'")

func test_isFalse():
	assert_bool(false).is_false()
	assert_bool(true, GdUnitAssert.EXPECT_FAIL).is_false() \
		.has_failure_message("Expecting: 'false' but is 'true'")
	assert_bool(null, GdUnitAssert.EXPECT_FAIL).is_false() \
		.has_failure_message("Expecting: 'false' but is '<null>'")

func test_is_null():
	assert_bool(null).is_null()
	# should fail because the current is not null
	assert_bool(true, GdUnitAssert.EXPECT_FAIL) \
		.is_null()\
		.starts_with_failure_message("Expecting: '<null>' but was 'true'")

func test_is_not_null():
	assert_bool(true).is_not_null()
	# should fail because the current is null
	assert_bool(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null()\
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_equal():
	assert_bool(true).is_equal(true)
	assert_bool(false).is_equal(false)
	assert_bool(true, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(false) \
		.has_failure_message("Expecting:\n 'false'\n but was\n 'true'")
	assert_bool(null, GdUnitAssert.EXPECT_FAIL) \
		.is_equal(false) \
		.has_failure_message("Expecting:\n 'false'\n but was\n '<null>'")

func test_is_not_equal():
	assert_bool(null).is_not_equal(false)
	assert_bool(true).is_not_equal(false)
	assert_bool(false).is_not_equal(true)
	assert_bool(true, GdUnitAssert.EXPECT_FAIL) \
		.is_not_equal(true) \
		.has_failure_message("Expecting:\n 'true'\n not equal to\n 'true'")

func test_fluent():
	assert_bool(true).is_true().is_equal(true).is_not_equal(false)

func test_must_fail_has_invlalid_type():
	assert_bool(1, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitBoolAssert inital error, unexpected type <int>")
	assert_bool(3.13, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitBoolAssert inital error, unexpected type <float>")
	assert_bool("foo", GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitBoolAssert inital error, unexpected type <String>")
	assert_bool(Resource.new(), GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitBoolAssert inital error, unexpected type <Object>")

func test_override_failure_message() -> void:
	assert_bool(true, GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

var _value = 0
func next_value() -> bool:
	_value += 1
	return true if _value == 1 else false

func test_with_value_provider() -> void:
	assert_bool(CallBackValueProvider.new(self, "next_value"))\
		.is_true().is_false().is_false()

# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_bool(true).is_true()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_bool(true, GdUnitAssert.EXPECT_FAIL).is_false()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_bool(true).is_true()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
	
	# should abort here because we had an failing assert
	if is_failure():
		return
	assert_bool(true).override_failure_message("This line shold never be called").is_false()
