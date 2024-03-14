# GdUnit generated TestSuite
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/parse/GdUnitTestParameterSetResolver.gd'


var _test_param1 := 10
var _test_param2 := 20


func before():
	_test_param1 = 11


func test_before():
	_test_param2 = 22


@warning_ignore("unused_parameter")
func test_example_a(a: int, b: int, test_parameters=[[1, 2], [3,4]]) -> void:
	pass


@warning_ignore("unused_parameter")
func test_example_b(a: Vector2, b: Vector2, test_parameters=[
	[Vector2.ZERO, Vector2.ONE], [Vector2(1.1, 3.2), Vector2.DOWN]] ) -> void:
	pass


@warning_ignore("unused_parameter")
func test_example_c(a: Object, b: Object, test_parameters=[
	[Resource.new(), Resource.new()],
	[Resource.new(), null]
	] ) -> void:
	pass


@warning_ignore("unused_parameter")
func test_resolve_paramaters_static(a: int, b: int, test_parameters=[
	[1, 10],
	[2, 20]
	]) -> void:
	pass


@warning_ignore("unused_parameter")
func test_resolve_paramaters_at_runtime(a: int, b: int, test_parameters=[
	[1, _test_param1],
	[2, _test_param2],
	[3, 30]
	]) -> void:
	pass


func build_param(value: float) -> Vector3:
	return Vector3(value, value, value)


@warning_ignore("unused_parameter")
func test_example_d(a: Vector3, b: Vector3, test_parameters=[
	[build_param(1), build_param(3)],
	[Vector3.BACK, Vector3.UP]
	] ) -> void:
	pass


class TestObj extends RefCounted:
	var _value: String
	
	func _init(value: String):
		_value = value
	
	func _to_string() -> String:
		return _value


@warning_ignore("unused_parameter")
func test_example_e(a: Object, b: Object, expected: String, test_parameters:=[
	[TestObj.new("abc"), TestObj.new("def"), "abcdef"]]):
	pass


# verify the used 'test_parameters' is completly resolved
func test_load_parameter_sets() -> void:
	var tc := get_test_case("test_example_a")
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([[1, 2], [3, 4]])
	
	tc = get_test_case("test_example_b")
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([[Vector2.ZERO, Vector2.ONE], [Vector2(1.1, 3.2), Vector2.DOWN]])
	
	tc = get_test_case("test_example_c")
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([[Resource.new(), Resource.new()], [Resource.new(), null]])
	
	tc = get_test_case("test_example_d")
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([[Vector3(1, 1, 1), Vector3(3, 3, 3)], [Vector3.BACK, Vector3.UP]])
	
	tc = get_test_case("test_example_e")
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([[TestObj.new("abc"), TestObj.new("def"), "abcdef"]])


func test_load_parameter_sets_at_runtime() -> void:
	var tc := get_test_case("test_resolve_paramaters_at_runtime")
	# check the parameters resolved at runtime
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([
			# the value `_test_param1` is changed from 10 to 11 on `before` stage
			[1, 11],
			# the value `_test_param2` is changed from 20 to 2 on `test_before` stage
			[2, 22],
			# the value is static initial `30`
			[3, 30]])


func test_build_test_case_names_on_static_parameter_set() -> void:
	var test_case := get_test_case("test_resolve_paramaters_static")
	var resolver := test_case.parameter_set_resolver()
	
	assert_array(resolver.build_test_case_names(test_case))\
		.contains_exactly([
			"test_resolve_paramaters_static:0 [1, 10]",
			"test_resolve_paramaters_static:1 [2, 20]"])
	assert_that(resolver.is_parameter_sets_static()).is_true()
	assert_that(resolver.is_parameter_set_static(0)).is_true()
	assert_that(resolver.is_parameter_set_static(1)).is_true()


func test_build_test_case_names_on_runtime_parameter_set() -> void:
	var test_case := get_test_case("test_resolve_paramaters_at_runtime")
	var resolver := test_case.parameter_set_resolver()
	
	assert_array(resolver.build_test_case_names(test_case))\
		.contains_exactly([
			"test_resolve_paramaters_at_runtime:0 [1, _test_param1]",
			"test_resolve_paramaters_at_runtime:1 [2, _test_param2]",
			"test_resolve_paramaters_at_runtime:2 [3, 30]"])
	assert_that(resolver.is_parameter_sets_static()).is_false()
	assert_that(resolver.is_parameter_set_static(0)).is_false()
	assert_that(resolver.is_parameter_set_static(1)).is_false()
	assert_that(resolver.is_parameter_set_static(2)).is_false()


func get_test_case(name: String) -> _TestCase:
	return find_child(name, true, false)
