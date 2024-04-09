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
func test_resolve_parameters_static(a: int, b: int, test_parameters=[
	[1, 10],
	[2, 20]
	]) -> void:
	pass


@warning_ignore("unused_parameter")
func test_resolve_parameters_at_runtime(a: int, b: int, test_parameters=[
	[1, _test_param1],
	[2, _test_param2],
	[3, 30]
	]) -> void:
	pass


@warning_ignore("unused_parameter")
func test_parameterized_with_comments(a: int, b :int, c :String, expected :int, test_parameters = [
	# before data set
	[1, 2, '3', 6], # after data set
	# between data sets
	[3, 4, '5', 11],
	[6, 7, 'string #ABCD', 21], # dataset with [comment] singn
	[6, 7, "string #ABCD", 21] # dataset with "comment" singn
	#eof
]):
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
	var tc := get_test_case("test_resolve_parameters_at_runtime")
	assert_that(tc).is_not_null()
	# check the parameters resolved at runtime
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([
			# the value `_test_param1` is changed from 10 to 11 on `before` stage
			[1, 11],
			# the value `_test_param2` is changed from 20 to 2 on `test_before` stage
			[2, 22],
			# the value is static initial `30`
			[3, 30]])


func test_load_parameter_with_comments() -> void:
	var tc := get_test_case("test_parameterized_with_comments")
	assert_that(tc).is_not_null()
	# check the parameters resolved at runtime
	assert_array(tc.parameter_set_resolver().load_parameter_sets(tc)) \
		.is_equal([
			[1, 2, '3', 6],
			[3, 4, '5', 11],
			[6, 7, 'string #ABCD', 21],
			[6, 7, "string #ABCD", 21]])


func test_build_test_case_names_on_static_parameter_set() -> void:
	var test_case := get_test_case("test_resolve_parameters_static")
	var resolver := test_case.parameter_set_resolver()

	assert_array(resolver.build_test_case_names(test_case))\
		.contains_exactly([
			"test_resolve_parameters_static:0 [1, 10]",
			"test_resolve_parameters_static:1 [2, 20]"])
	assert_that(resolver.is_parameter_sets_static()).is_true()
	assert_that(resolver.is_parameter_set_static(0)).is_true()
	assert_that(resolver.is_parameter_set_static(1)).is_true()


func test_build_test_case_names_on_runtime_parameter_set() -> void:
	var test_case := get_test_case("test_resolve_parameters_at_runtime")
	var resolver := test_case.parameter_set_resolver()

	assert_array(resolver.build_test_case_names(test_case))\
		.contains_exactly([
			"test_resolve_parameters_at_runtime:0 [1, _test_param1]",
			"test_resolve_parameters_at_runtime:1 [2, _test_param2]",
			"test_resolve_parameters_at_runtime:2 [3, 30]"])
	assert_that(resolver.is_parameter_sets_static()).is_false()
	assert_that(resolver.is_parameter_set_static(0)).is_false()
	assert_that(resolver.is_parameter_set_static(1)).is_false()
	assert_that(resolver.is_parameter_set_static(2)).is_false()


func test_validate_test_parameter_set():
	var test_suite :GdUnitTestSuite = auto_free(GdUnitTestResourceLoader.load_test_suite("res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteInvalidParameterizedTests.resource"))

	assert_is_not_skipped(test_suite, "test_no_parameters")
	assert_is_not_skipped(test_suite, "test_parameterized_success")
	assert_is_not_skipped(test_suite, "test_parameterized_failed")
	assert_is_skipped(test_suite, "test_parameterized_to_less_args")\
		.contains("The parameter set at index [0] does not match the expected input parameters!")\
		.contains("The test case requires [3] input parameters, but the set contains [4]")
	assert_is_skipped(test_suite, "test_parameterized_to_many_args")\
		.contains("The parameter set at index [0] does not match the expected input parameters!")\
		.contains("The test case requires [5] input parameters, but the set contains [4]")
	assert_is_skipped(test_suite, "test_parameterized_to_less_args_at_index_1")\
		.contains("The parameter set at index [1] does not match the expected input parameters!")\
		.contains("The test case requires [3] input parameters, but the set contains [4]")
	assert_is_skipped(test_suite, "test_parameterized_invalid_struct")\
		.contains("The parameter set at index [1] does not match the expected input parameters!")\
		.contains("The test case requires [3] input parameters, but the set contains [1]")
	assert_is_skipped(test_suite, "test_parameterized_invalid_args")\
		.contains("The parameter set at index [1] does not match the expected input parameters!")\
		.contains("The value '4' does not match the required input parameter <b:int>.")


func assert_is_not_skipped(test_suite :GdUnitTestSuite, test_case :String) -> void:
	# set actual execution context for this test suite
	test_suite.__execution_context = GdUnitExecutionContext.new(test_suite.get_name())
	var test :_TestCase = test_suite.find_child(test_case, true, false)
	if test.is_parameterized():
		# to load parameter set and force validate
		var resolver := test.parameter_set_resolver()
		resolver.build_test_case_names(test)
		resolver.load_parameter_sets(test, true)
	assert_that(test.is_skipped()).is_false()


func assert_is_skipped(test_suite :GdUnitTestSuite, test_case :String) -> GdUnitStringAssert:
	# set actual execution context for this test suite
	test_suite.__execution_context = GdUnitExecutionContext.new(test_suite.get_name())
	var test :_TestCase = test_suite.find_child(test_case, true, false)
	if test.is_parameterized():
		# to load parameter set and force validate
		var resolver := test.parameter_set_resolver()
		resolver.build_test_case_names(test)
		resolver.load_parameter_sets(test, true)
	assert_that(test.is_skipped()).is_true()
	return assert_str(test.skip_info())

func get_test_case(name: String) -> _TestCase:
	return find_child(name, true, false)
