# GdUnit generated TestSuite
class_name ResultTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/Result.gd'


func test_serde():
	var value = {
		"info" : "test",
		"meta" : 42
	}
	var source := Result.success(value)
	var serialized_result = Result.serialize(source)
	var deserialised_result := Result.deserialize(serialized_result)
	assert_object(deserialised_result)\
		.is_instanceof(Result) \
		.is_equal(source)

func test_or_else_on_success():
	var result := Result.success("some value")
	assert_str(result.value()).is_equal("some value")
	assert_str(result.or_else("other value")).is_equal("some value")

func test_or_else_on_warning():
	var result := Result.warn("some warning message")
	assert_object(result.value()).is_null()
	assert_str(result.or_else("other value")).is_equal("other value")

func test_or_else_on_error():
	var result := Result.error("some error message")
	assert_object(result.value()).is_null()
	assert_str(result.or_else("other value")).is_equal("other value")
