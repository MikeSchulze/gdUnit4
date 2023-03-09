# GdUnit generated TestSuite
class_name GdTestParameterSetTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/parse/GdTestParameterSet.gd'


@warning_ignore("unused_parameter")
func test_example_a(a :int, b :int, test_parameters =[[1,2], [3,4]] ) -> void:
	pass


@warning_ignore("unused_parameter")
func test_example_b(a :Vector2, b :Vector2, test_parameters =[
	[Vector2.ZERO, Vector2.ONE], [Vector2(1.1, 3.2), Vector2.DOWN]] ) -> void:
	pass


@warning_ignore("unused_parameter")
func test_example_c(a :Object, b :Object, test_parameters =[
	[Resource.new(), Resource.new()],
	[Resource.new(), null]
	] ) -> void:
	pass


func build_param(value :float) -> Vector3:
	return Vector3(value, value, value)


@warning_ignore("unused_parameter")
func test_example_d(a :Vector3, b :Vector3, test_parameters =[
	[build_param(1), build_param(3)],
	[Vector3.BACK, Vector3.UP]
	] ) -> void:
	pass


class TestObj extends RefCounted:
	var _value :String
	
	func _init(value :String):
		_value = value
	
	func _to_string() -> String:
		return _value


@warning_ignore("unused_parameter")
func test_example_e(a: Object, b :Object, expected :String, test_parameters := [
	[TestObj.new("abc"), TestObj.new("def"), "abcdef"]]):
	pass


# verify the used 'test_parameters' is completly resolved
func test_extract_parameters() -> void:
	var script :GDScript = load("res://addons/gdUnit4/test/core/parse/GdTestParameterSetTest.gd")
	var parser := GdScriptParser.new()
	var source := parser.load_source_code(script, [script.resource_path])
	var functions := parser.parse_functions(source, "", [script.resource_path], ["test_example_a", "test_example_b", "test_example_c", "test_example_d", "test_example_e"])
	assert_array(functions).extract("name").contains_exactly(["test_example_a", "test_example_b", "test_example_c", "test_example_d", "test_example_e"])
	
	assert_array(GdTestParameterSet.extract_test_parameters(script, functions[0]))\
		.is_equal([[1,2], [3,4]])
	assert_array(GdTestParameterSet.extract_test_parameters(script, functions[1]))\
		.is_equal([[Vector2.ZERO, Vector2.ONE], [Vector2(1.1, 3.2), Vector2.DOWN]])
	assert_array(GdTestParameterSet.extract_test_parameters(script, functions[2]))\
		.is_equal([[Resource.new(), Resource.new()], [Resource.new(), null]])
	assert_array(GdTestParameterSet.extract_test_parameters(script, functions[3]))\
		.is_equal([[Vector3(1,1,1), Vector3(3,3,3)], [Vector3.BACK, Vector3.UP]])
	assert_array(GdTestParameterSet.extract_test_parameters(script, functions[4]))\
		.is_equal([[TestObj.new("abc"), TestObj.new("def"), "abcdef"]])
