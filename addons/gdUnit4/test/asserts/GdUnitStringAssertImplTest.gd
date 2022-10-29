# GdUnit generated TestSuite
class_name GdUnitStringAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitStringAssertImpl.gd'

func test_is_null():
	assert_str(null).is_null()
	assert_str("abc").is_equal("abc")
	# should fail because the current is not null
	assert_str("abc", GdUnitAssert.EXPECT_FAIL) \
		.is_null()\
		.starts_with_failure_message("Expecting: '<null>' but was 'abc'")

func test_is_not_null():
	assert_str("abc").is_not_null()
	# should fail because the current is null
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.is_not_null()\
		.has_failure_message("Expecting: not to be '<null>'")

func test_is_equal():
	assert_str("This is a test message").is_equal("This is a test message")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.is_equal("This is a test Message") \
		.has_failure_message("Expecting:\n 'This is a test Message'\n but was\n 'This is a test Mmessage'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.is_equal("This is a test Message") \
		.has_failure_message("Expecting:\n 'This is a test Message'\n but was\n '<null>'")

func test_is_equal_pipe_character() -> void:
	assert_str("AAA|BBB|CCC", GdUnitAssert.EXPECT_FAIL).is_equal("AAA|BBB.CCC")

func test_is_equal_ignoring_case():
	assert_str("This is a test message").is_equal_ignoring_case("This is a test Message")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.is_equal_ignoring_case("This is a Message") \
		.has_failure_message("Expecting:\n 'This is a Message'\n but was\n 'This is a test Mmessage' (ignoring case)")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.is_equal_ignoring_case("This is a Message") \
		.has_failure_message("Expecting:\n 'This is a Message'\n but was\n '<null>' (ignoring case)")

func test_is_not_equal():
	assert_str(null).is_not_equal("This is a test Message")
	assert_str("This is a test message").is_not_equal("This is a test Message")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.is_not_equal("This is a test message")\
		.has_failure_message("Expecting:\n 'This is a test message'\n not equal to\n 'This is a test message'")

func test_is_not_equal_ignoring_case():
	assert_str(null).is_not_equal_ignoring_case("This is a Message")
	assert_str("This is a test message").is_not_equal_ignoring_case("This is a Message")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.is_not_equal_ignoring_case("This is a test Message")\
		.has_failure_message("Expecting:\n 'This is a test Message'\n not equal to\n 'This is a test message'")

func test_is_empty():
	assert_str("").is_empty()
	# should fail because the current value is not empty it contains a space
	assert_str(" ", GdUnitAssert.EXPECT_FAIL)\
		.is_empty()\
		.has_failure_message("Expecting:\n must be empty but was\n ' '")
	assert_str("abc", GdUnitAssert.EXPECT_FAIL)\
		.is_empty()\
		.has_failure_message("Expecting:\n must be empty but was\n 'abc'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL)\
		.is_empty()\
		.has_failure_message("Expecting:\n must be empty but was\n '<null>'")

func test_is_not_empty():
	assert_str(" ").is_not_empty()
	assert_str("	").is_not_empty()
	assert_str("abc").is_not_empty()
	# should fail because current is empty
	assert_str("", GdUnitAssert.EXPECT_FAIL)\
		.is_not_empty()\
		.has_failure_message("Expecting:\n must not be empty")
	assert_str(null, GdUnitAssert.EXPECT_FAIL)\
		.is_not_empty()\
		.has_failure_message("Expecting:\n must not be empty")

func test_contains():
	assert_str("This is a test message").contains("a test")
	# must fail because of camel case difference
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.contains("a Test") \
		.has_failure_message("Expecting:\n 'This is a test message'\n do contains\n 'a Test'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.contains("a Test") \
		.has_failure_message("Expecting:\n '<null>'\n do contains\n 'a Test'")

func test_not_contains():
	assert_str(null).not_contains("a tezt")
	assert_str("This is a test message").not_contains("a tezt")

func test_not_contains_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.not_contains("a test") \
		.has_failure_message("Expecting:\n 'This is a test message'\n not do contain\n 'a test'")

func test_contains_ignoring_case():
	assert_str("This is a test message").contains_ignoring_case("a Test")

func test_contains_ignoring_case_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.contains_ignoring_case("a Tesd") \
		.has_failure_message("Expecting:\n 'This is a test message'\n contains\n 'a Tesd'\n (ignoring case)")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.contains_ignoring_case("a Tesd") \
		.has_failure_message("Expecting:\n '<null>'\n contains\n 'a Tesd'\n (ignoring case)")

func test_not_contains_ignoring_case():
	assert_str(null).not_contains_ignoring_case("a Test")
	assert_str("This is a test message").not_contains_ignoring_case("a Tezt")

func test_not_contains_ignoring_case_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.not_contains_ignoring_case("a Test") \
		.has_failure_message("Expecting:\n 'This is a test message'\n not do contains\n 'a Test'\n (ignoring case)")

func test_starts_with():
	assert_str("This is a test message").starts_with("This is")

func test_starts_with_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.starts_with("This iss") \
		.has_failure_message("Expecting:\n 'This is a test message'\n to start with\n 'This iss'")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.starts_with("this is") \
		.has_failure_message("Expecting:\n 'This is a test message'\n to start with\n 'this is'")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.starts_with("test") \
		.has_failure_message("Expecting:\n 'This is a test message'\n to start with\n 'test'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.starts_with("test") \
		.has_failure_message("Expecting:\n '<null>'\n to start with\n 'test'")

func test_ends_with():
	assert_str("This is a test message").ends_with("test message")

func test_ends_with_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.ends_with("tes message") \
		.has_failure_message("Expecting:\n 'This is a test message'\n to end with\n 'tes message'")
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.ends_with("a test") \
		.has_failure_message("Expecting:\n 'This is a test message'\n to end with\n 'a test'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.ends_with("a test") \
		.has_failure_message("Expecting:\n '<null>'\n to end with\n 'a test'")

func test_has_lenght():
	assert_str("This is a test message").has_length(22)
	assert_str("").has_length(0)

func test_has_lenght_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.has_length(23) \
		.has_failure_message("Expecting size:\n '23' but was '22' in\n 'This is a test message'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.has_length(23) \
		.has_failure_message("Expecting size:\n '23' but was '<null>' in\n '<null>'")

func test_has_lenght_less_than():
	assert_str("This is a test message").has_length(23, Comparator.LESS_THAN)
	assert_str("This is a test message").has_length(42, Comparator.LESS_THAN)

func test_has_lenght_less_than_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.has_length(22, Comparator.LESS_THAN) \
		.has_failure_message("Expecting size to be less than:\n '22' but was '22' in\n 'This is a test message'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.has_length(22, Comparator.LESS_THAN) \
		.has_failure_message("Expecting size to be less than:\n '22' but was '<null>' in\n '<null>'")

func test_has_lenght_less_equal():
	assert_str("This is a test message").has_length(22, Comparator.LESS_EQUAL)
	assert_str("This is a test message").has_length(23, Comparator.LESS_EQUAL)

func test_has_lenght_less_equal_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.has_length(21, Comparator.LESS_EQUAL) \
		.has_failure_message("Expecting size to be less than or equal:\n '21' but was '22' in\n 'This is a test message'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.has_length(21, Comparator.LESS_EQUAL) \
		.has_failure_message("Expecting size to be less than or equal:\n '21' but was '<null>' in\n '<null>'")

func test_has_lenght_greater_than():
	assert_str("This is a test message").has_length(21, Comparator.GREATER_THAN)

func test_has_lenght_greater_than_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.has_length(22, Comparator.GREATER_THAN) \
		.has_failure_message("Expecting size to be greater than:\n '22' but was '22' in\n 'This is a test message'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.has_length(22, Comparator.GREATER_THAN) \
		.has_failure_message("Expecting size to be greater than:\n '22' but was '<null>' in\n '<null>'")

func test_has_lenght_greater_equal():
	assert_str("This is a test message").has_length(21, Comparator.GREATER_EQUAL)
	assert_str("This is a test message").has_length(22, Comparator.GREATER_EQUAL)

func test_has_lenght_greater_equal_do_fail():
	assert_str("This is a test message", GdUnitAssert.EXPECT_FAIL) \
		.has_length(23, Comparator.GREATER_EQUAL) \
		.has_failure_message("Expecting size to be greater than or equal:\n '23' but was '22' in\n 'This is a test message'")
	assert_str(null, GdUnitAssert.EXPECT_FAIL) \
		.has_length(23, Comparator.GREATER_EQUAL) \
		.has_failure_message("Expecting size to be greater than or equal:\n '23' but was '<null>' in\n '<null>'")

func test_fluentable():
	assert_str("value a").is_not_equal("a")\
		.is_equal("value a")\
		.has_length(7)\
		.is_equal("value a")

func test_must_fail_has_invlalid_type():
	assert_str(1, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitStringAssert inital error, unexpected type <int>")
	assert_str(1.3, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitStringAssert inital error, unexpected type <float>")
	assert_str(true, GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitStringAssert inital error, unexpected type <bool>")
	assert_str(Resource.new(), GdUnitAssert.EXPECT_FAIL) \
		.has_failure_message("GdUnitStringAssert inital error, unexpected type <Object>")

func test_override_failure_message() -> void:
	assert_str("", GdUnitAssert.EXPECT_FAIL)\
		.override_failure_message("Custom failure message")\
		.is_null()\
		.has_failure_message("Custom failure message")

var _value := 0
func next_value() -> String:
	_value += 1
	return "value_%d" % _value

func test_with_value_provider() -> void:
	assert_str(CallBackValueProvider.new(self, "next_value"))\
		.is_equal("value_1").is_equal("value_2").is_equal("value_3")

# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_str(null).is_null()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_str(RefCounted.new(), GdUnitAssert.EXPECT_FAIL).is_null()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_str(null).is_null()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
