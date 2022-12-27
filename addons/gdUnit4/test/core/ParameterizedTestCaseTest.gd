#warning-ignore-all:unused_argument
class_name ParameterizedTestCaseTest
extends GdUnitTestSuite

var _collected_tests = {}
var _expected_tests = {
	"test_parameterized_bool_value" : [
		[0, false],
		[1, true]
	],
	"test_parameterized_int_values" : [
		[1, 2, 3, 6],
		[3, 4, 5, 12],
		[6, 7, 8, 21]
	],
	"test_parameterized_float_values" : [
		[2.2, 2.2, 4.4],
		[2.2, 2.3, 4.5],
		[3.3, 2.2, 5.5]
	],
	"test_parameterized_string_values" : [
		["2.2", "2.2", "2.22.2"],
		["foo", "bar", "foobar"],
		["a", "b", "ab"]
	],
	"test_parameterized_Vector2_values" : [
		[Vector2.ONE, Vector2.ONE, Vector2(2, 2)],
		[Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO],
		[Vector2.ZERO, Vector2.LEFT, Vector2.LEFT]
	],
	"test_parameterized_Vector3_values" : [
		[Vector3.ONE, Vector3.ONE, Vector3(2, 2, 2)],
		[Vector3.LEFT, Vector3.RIGHT, Vector3.ZERO],
		[Vector3.ZERO, Vector3.LEFT, Vector3.LEFT]
	],
	"test_parameterized_obj_values" : [
		[TestObj.new("abc"), TestObj.new("def"), "abcdef"]
	],
	"test_parameterized_dict_values" : [
		[{"key_a":"value_a"}, '{"key_a":"value_a"}'],
		[{"key_b":"value_b"}, '{"key_b":"value_b"}']
	]
}


func after():
	for test_name in _expected_tests.keys():
		if _collected_tests.has(test_name):
			var current_values = _collected_tests[test_name]
			var expected_values = _expected_tests[test_name]
			assert_that(current_values)\
				.override_failure_message("Expecting '%s' called with parameters:\n %s\n but was\n %s" % [test_name, expected_values, current_values])\
				.is_equal(expected_values)
		else:
			fail("Missing test '%s' executed!" % test_name)


func collect_test_call(test_name :String, values :Array) -> void:
	if not _collected_tests.has(test_name):
		_collected_tests[test_name] = Array()
	_collected_tests[test_name].append(values)


func test_parameterized_bool_value(a: int, expected :bool, test_parameters := [
	[0, false],
	[1, true]]):
	collect_test_call("test_parameterized_bool_value", [a, expected])
	assert_that(bool(a)).is_equal(expected)


func test_parameterized_int_values(a: int, b :int, c :int, expected :int, test_parameters := [
	[1, 2, 3, 6],
	[3, 4, 5, 12],
	[6, 7, 8, 21] ]):
	
	collect_test_call("test_parameterized_int_values", [a, b, c, expected])
	assert_that(a+b+c).is_equal(expected)


func test_parameterized_float_values(a: float, b :float, expected :float, test_parameters := [
	[2.2, 2.2, 4.4],
	[2.2, 2.3, 4.5],
	[3.3, 2.2, 5.5] ]):
	
	collect_test_call("test_parameterized_float_values", [a, b, expected])
	assert_float(a+b).is_equal(expected)


func test_parameterized_string_values(a: String, b :String, expected :String, test_parameters := [
	["2.2", "2.2", "2.22.2"],
	["foo", "bar", "foobar"],
	["a", "b", "ab"] ]):
	
	collect_test_call("test_parameterized_string_values", [a, b, expected])
	assert_that(a+b).is_equal(expected)


func test_parameterized_Vector2_values(a: Vector2, b :Vector2, expected :Vector2, test_parameters := [
	[Vector2.ONE, Vector2.ONE, Vector2(2, 2)],
	[Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO],
	[Vector2.ZERO, Vector2.LEFT, Vector2.LEFT] ]):
	
	collect_test_call("test_parameterized_Vector2_values", [a, b, expected])
	assert_that(a+b).is_equal(expected)


func test_parameterized_Vector3_values(a: Vector3, b :Vector3, expected :Vector3, test_parameters := [
	[Vector3.ONE, Vector3.ONE, Vector3(2, 2, 2)],
	[Vector3.LEFT, Vector3.RIGHT, Vector3.ZERO],
	[Vector3.ZERO, Vector3.LEFT, Vector3.LEFT] ]):
	
	collect_test_call("test_parameterized_Vector3_values", [a, b, expected])
	assert_that(a+b).is_equal(expected)


class TestObj extends RefCounted:
	var _value :String
	
	func _init(value :String):
		_value = value
	
	func _to_string() -> String:
		return _value


func test_parameterized_obj_values(a: Object, b :Object, expected :String, test_parameters := [
	[TestObj.new("abc"), TestObj.new("def"), "abcdef"]]):
	
	collect_test_call("test_parameterized_obj_values", [a, b, expected])
	assert_that(a.to_string()+b.to_string()).is_equal(expected)


func test_parameterized_dict_values(data: Dictionary, expected :String, test_parameters := [
	[{"key_a" : "value_a"}, '{"key_a":"value_a"}'],
	[{"key_b" : "value_b"}, '{"key_b":"value_b"}']
	]):
	collect_test_call("test_parameterized_dict_values", [data, expected])
	assert_that(str(data).replace(" ", "")).is_equal(expected)
