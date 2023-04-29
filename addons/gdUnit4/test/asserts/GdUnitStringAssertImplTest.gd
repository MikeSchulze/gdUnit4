# GdUnit generated TestSuite
class_name GdUnitStringAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitStringAssertImpl.gd'

func test_is_null():
	assert_str(null).is_null()
	assert_str("abc").is_equal("abc")
	
	assert_failure(func(): assert_str("abc").is_null()) \
		.is_failed() \
		.starts_with_message("Expecting: '<null>' but was 'abc'")


func test_is_not_null():
	assert_str("abc").is_not_null()
	
	assert_failure(func(): assert_str(null).is_not_null()) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_is_equal():
	assert_str("This is a test message").is_equal("This is a test message")
	
	assert_failure(func(): assert_str("This is a test message").is_equal("This is a test Message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test Message'\n but was\n 'This is a test Mmessage'")
	assert_failure(func(): assert_str(null).is_equal("This is a test Message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test Message'\n but was\n '<null>'")


func test_is_equal_pipe_character() -> void:
	assert_failure(func(): assert_str("AAA|BBB|CCC").is_equal("AAA|BBB.CCC")) \
		.is_failed()


func test_is_equal_ignoring_case():
	assert_str("This is a test message").is_equal_ignoring_case("This is a test Message")
	
	assert_failure(func(): assert_str("This is a test message").is_equal_ignoring_case("This is a Message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a Message'\n but was\n 'This is a test Mmessage' (ignoring case)")
	assert_failure(func(): assert_str(null).is_equal_ignoring_case("This is a Message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a Message'\n but was\n '<null>' (ignoring case)")


func test_is_not_equal():
	assert_str(null).is_not_equal("This is a test Message")
	assert_str("This is a test message").is_not_equal("This is a test Message")
	
	assert_failure(func(): assert_str("This is a test message").is_not_equal("This is a test message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n not equal to\n 'This is a test message'")


func test_is_not_equal_ignoring_case():
	assert_str(null).is_not_equal_ignoring_case("This is a Message")
	assert_str("This is a test message").is_not_equal_ignoring_case("This is a Message")
	
	assert_failure(func(): assert_str("This is a test message").is_not_equal_ignoring_case("This is a test Message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test Message'\n not equal to\n 'This is a test message'")


func test_is_empty():
	assert_str("").is_empty()
	
	assert_failure(func(): assert_str(" ").is_empty()) \
		.is_failed() \
		.has_message("Expecting:\n must be empty but was\n ' '")
	assert_failure(func(): assert_str("abc").is_empty()) \
		.is_failed() \
		.has_message("Expecting:\n must be empty but was\n 'abc'")
	assert_failure(func(): assert_str(null).is_empty()) \
		.is_failed() \
		.has_message("Expecting:\n must be empty but was\n '<null>'")


func test_is_not_empty():
	assert_str(" ").is_not_empty()
	assert_str("	").is_not_empty()
	assert_str("abc").is_not_empty()
	
	assert_failure(func(): assert_str("").is_not_empty()) \
		.is_failed() \
		.has_message("Expecting:\n must not be empty")
	assert_failure(func(): assert_str(null).is_not_empty()) \
		.is_failed() \
		.has_message("Expecting:\n must not be empty")


func test_contains():
	assert_str("This is a test message").contains("a test")
	# must fail because of camel case difference
	assert_failure(func(): assert_str("This is a test message").contains("a Test")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n do contains\n 'a Test'")
	assert_failure(func(): assert_str(null).contains("a Test")) \
		.is_failed() \
		.has_message("Expecting:\n '<null>'\n do contains\n 'a Test'")


func test_not_contains():
	assert_str(null).not_contains("a tezt")
	assert_str("This is a test message").not_contains("a tezt")
	
	assert_failure(func(): assert_str("This is a test message").not_contains("a test")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n not do contain\n 'a test'")


func test_contains_ignoring_case():
	assert_str("This is a test message").contains_ignoring_case("a Test")
	
	assert_failure(func(): assert_str("This is a test message").contains_ignoring_case("a Tesd")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n contains\n 'a Tesd'\n (ignoring case)")
	assert_failure(func(): assert_str(null).contains_ignoring_case("a Tesd")) \
		.is_failed() \
		.has_message("Expecting:\n '<null>'\n contains\n 'a Tesd'\n (ignoring case)")


func test_not_contains_ignoring_case():
	assert_str(null).not_contains_ignoring_case("a Test")
	assert_str("This is a test message").not_contains_ignoring_case("a Tezt")
	
	assert_failure(func(): assert_str("This is a test message").not_contains_ignoring_case("a Test")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n not do contains\n 'a Test'\n (ignoring case)")


func test_starts_with():
	assert_str("This is a test message").starts_with("This is")
	
	assert_failure(func(): assert_str("This is a test message").starts_with("This iss")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n to start with\n 'This iss'")
	assert_failure(func(): assert_str("This is a test message").starts_with("this is")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n to start with\n 'this is'")
	assert_failure(func(): assert_str("This is a test message").starts_with("test")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n to start with\n 'test'")
	assert_failure(func(): assert_str(null).starts_with("test")) \
		.is_failed() \
		.has_message("Expecting:\n '<null>'\n to start with\n 'test'")


func test_ends_with():
	assert_str("This is a test message").ends_with("test message")
	
	assert_failure(func(): assert_str("This is a test message").ends_with("tes message")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n to end with\n 'tes message'")
	assert_failure(func(): assert_str("This is a test message").ends_with("a test")) \
		.is_failed() \
		.has_message("Expecting:\n 'This is a test message'\n to end with\n 'a test'")
	assert_failure(func(): assert_str(null).ends_with("a test")) \
		.is_failed() \
		.has_message("Expecting:\n '<null>'\n to end with\n 'a test'")


func test_has_lenght():
	assert_str("This is a test message").has_length(22)
	assert_str("").has_length(0)
	
	assert_failure(func(): assert_str("This is a test message").has_length(23)) \
		.is_failed() \
		.has_message("Expecting size:\n '23' but was '22' in\n 'This is a test message'")
	assert_failure(func(): assert_str(null).has_length(23)) \
		.is_failed() \
		.has_message("Expecting size:\n '23' but was '<null>' in\n '<null>'")


func test_has_lenght_less_than():
	assert_str("This is a test message").has_length(23, Comparator.LESS_THAN)
	assert_str("This is a test message").has_length(42, Comparator.LESS_THAN)
	
	assert_failure(func(): assert_str("This is a test message").has_length(22, Comparator.LESS_THAN)) \
		.is_failed() \
		.has_message("Expecting size to be less than:\n '22' but was '22' in\n 'This is a test message'")
	assert_failure(func(): assert_str(null).has_length(22, Comparator.LESS_THAN)) \
		.is_failed() \
		.has_message("Expecting size to be less than:\n '22' but was '<null>' in\n '<null>'")


func test_has_lenght_less_equal():
	assert_str("This is a test message").has_length(22, Comparator.LESS_EQUAL)
	assert_str("This is a test message").has_length(23, Comparator.LESS_EQUAL)
	
	assert_failure(func(): assert_str("This is a test message").has_length(21, Comparator.LESS_EQUAL)) \
		.is_failed() \
		.has_message("Expecting size to be less than or equal:\n '21' but was '22' in\n 'This is a test message'")
	assert_failure(func(): assert_str(null).has_length(21, Comparator.LESS_EQUAL)) \
		.is_failed() \
		.has_message("Expecting size to be less than or equal:\n '21' but was '<null>' in\n '<null>'")


func test_has_lenght_greater_than():
	assert_str("This is a test message").has_length(21, Comparator.GREATER_THAN)
	
	assert_failure(func(): assert_str("This is a test message").has_length(22, Comparator.GREATER_THAN)) \
		.is_failed() \
		.has_message("Expecting size to be greater than:\n '22' but was '22' in\n 'This is a test message'")
	assert_failure(func(): assert_str(null).has_length(22, Comparator.GREATER_THAN)) \
		.is_failed() \
		.has_message("Expecting size to be greater than:\n '22' but was '<null>' in\n '<null>'")


func test_has_lenght_greater_equal():
	assert_str("This is a test message").has_length(21, Comparator.GREATER_EQUAL)
	assert_str("This is a test message").has_length(22, Comparator.GREATER_EQUAL)
	
	assert_failure(func(): assert_str("This is a test message").has_length(23, Comparator.GREATER_EQUAL)) \
		.is_failed() \
		.has_message("Expecting size to be greater than or equal:\n '23' but was '22' in\n 'This is a test message'")
	assert_failure(func(): assert_str(null).has_length(23, Comparator.GREATER_EQUAL)) \
		.is_failed() \
		.has_message("Expecting size to be greater than or equal:\n '23' but was '<null>' in\n '<null>'")


func test_fluentable():
	assert_str("value a").is_not_equal("a")\
		.is_equal("value a")\
		.has_length(7)\
		.is_equal("value a")


func test_must_fail_has_invlalid_type():
	assert_failure(func(): assert_str(1)) \
		.is_failed() \
		.has_message("GdUnitStringAssert inital error, unexpected type <int>")
	assert_failure(func(): assert_str(1.3)) \
		.is_failed() \
		.has_message("GdUnitStringAssert inital error, unexpected type <float>")
	assert_failure(func(): assert_str(true)) \
		.is_failed() \
		.has_message("GdUnitStringAssert inital error, unexpected type <bool>")
	assert_failure(func(): assert_str(Resource.new())) \
		.is_failed() \
		.has_message("GdUnitStringAssert inital error, unexpected type <Object>")


func test_override_failure_message() -> void:
	assert_failure(func(): assert_str("")\
			.override_failure_message("Custom failure message")\
			.is_null())\
		.is_failed() \
		.has_message("Custom failure message")


# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_str(null).is_null()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_failure(func(): assert_str(RefCounted.new()).is_null()) \
		.is_failed()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_str(null).is_null()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
