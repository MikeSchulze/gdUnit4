# GdUnit generated TestSuite
class_name GdUnitResultAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitResultAssertImpl.gd'

func test_is_null():
	assert_result(null).is_null()
	
	assert_result(Result.success(""), GdUnitAssert.EXPECT_FAIL) \
		.is_null() \
		.has_failure_message("Expecting: '<null>' but was <RefCounted>")

func test_is_not_null():
	assert_result(Result.success("")).is_not_null()
	
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null() \
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_empty():
	assert_result(Result.empty()).is_empty()
	
	assert_result(Result.warn("a warning"), GdUnitAssert.EXPECT_FAIL) \
		.is_empty() \
		.has_failure_message("Expecting the result must be a EMPTY but was WARNING:\n 'a warning'")
	assert_result(Result.error("a error"), GdUnitAssert.EXPECT_FAIL) \
		.is_empty() \
		.has_failure_message("Expecting the result must be a EMPTY but was ERROR:\n 'a error'")
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.is_empty() \
		.has_failure_message("Expecting the result must be a EMPTY but was <null>.")

func test_is_success():
	assert_result(Result.success("")).is_success()
	
	assert_result(Result.warn("a warning"), GdUnitAssert.EXPECT_FAIL) \
		.is_success() \
		.has_failure_message("Expecting the result must be a SUCCESS but was WARNING:\n 'a warning'")
	assert_result(Result.error("a error"), GdUnitAssert.EXPECT_FAIL) \
		.is_success() \
		.has_failure_message("Expecting the result must be a SUCCESS but was ERROR:\n 'a error'")
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.is_success() \
		.has_failure_message("Expecting the result must be a SUCCESS but was <null>.")

func test_is_warning():
	assert_result(Result.warn("a warning")).is_warning()
	
	assert_result(Result.success("value"), GdUnitAssert.EXPECT_FAIL) \
		.is_warning() \
		.has_failure_message("Expecting the result must be a WARNING but was SUCCESS.")
	assert_result(Result.error("a error"), GdUnitAssert.EXPECT_FAIL) \
		.is_warning() \
		.has_failure_message("Expecting the result must be a WARNING but was ERROR:\n 'a error'")
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.is_warning() \
		.has_failure_message("Expecting the result must be a WARNING but was <null>.")

func test_is_error():
	assert_result(Result.error("a error")).is_error()
	
	assert_result(Result.success(""), GdUnitAssert.EXPECT_FAIL) \
		.is_error() \
		.has_failure_message("Expecting the result must be a ERROR but was SUCCESS.")
	assert_result(Result.warn("a warning"), GdUnitAssert.EXPECT_FAIL) \
		.is_error() \
		.has_failure_message("Expecting the result must be a ERROR but was WARNING:\n 'a warning'")
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.is_error() \
		.has_failure_message("Expecting the result must be a ERROR but was <null>.")

func test_contains_message():
	assert_result(Result.error("a error")).contains_message("a error")
	assert_result(Result.warn("a warning")).contains_message("a warning")
	
	assert_result(Result.success(""), GdUnitAssert.EXPECT_FAIL) \
		.contains_message("Error 500") \
		.has_failure_message("Expecting:\n 'Error 500'\n but the Result is a success.")
	assert_result(Result.warn("Warning xyz!"), GdUnitAssert.EXPECT_FAIL) \
		.contains_message("Warning aaa!") \
		.has_failure_message("Expecting:\n 'Warning aaa!'\n but was\n 'Warning xyz!'.")
	assert_result(Result.error("Error 410"), GdUnitAssert.EXPECT_FAIL) \
		.contains_message("Error 500") \
		.has_failure_message("Expecting:\n 'Error 500'\n but was\n 'Error 410'.")
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.contains_message("Error 500") \
		.has_failure_message("Expecting:\n 'Error 500'\n but was\n '<null>'.")

func test_is_value():
	assert_result(Result.success("")).is_value("")
	var result_value = auto_free(Node.new())
	assert_result(Result.success(result_value)).is_value(result_value)
	
	assert_result(Result.success(""), GdUnitAssert.EXPECT_FAIL) \
		.is_value("abc") \
		.has_failure_message("Expecting to contain same value:\n 'abc'\n but was\n '<empty>'.")
	assert_result(Result.success("abc"), GdUnitAssert.EXPECT_FAIL) \
		.is_value("") \
		.has_failure_message("Expecting to contain same value:\n '<empty>'\n but was\n 'abc'.")
	assert_result(Result.success(result_value), GdUnitAssert.EXPECT_FAIL) \
		.is_value("") \
		.has_failure_message("Expecting to contain same value:\n '<empty>'\n but was\n <Node>.")
	assert_result(null, GdUnitAssert.EXPECT_FAIL) \
		.is_value("") \
		.has_failure_message("Expecting to contain same value:\n '<empty>'\n but was\n '<null>'.")


func test_override_failure_message() -> void:
	assert_result(Result.success(""), GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

var _index = -1
var _values := [Result.success(""), Result.error("error"), Result.warn("warn")]
func next_value() -> Result:
	_index += 1
	return _values[_index]

func test_with_value_provider() -> void:
	assert_result(CallBackValueProvider.new(self, "next_value"))\
		.is_success().is_error().is_warning()

# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_result(null).is_null()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_result(RefCounted.new(), GdUnitAssert.EXPECT_FAIL).is_null()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_result(null).is_null()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
