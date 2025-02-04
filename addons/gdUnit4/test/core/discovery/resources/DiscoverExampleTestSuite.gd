extends GdUnitTestSuite


var _test_seta := [
	[null],
	[Vector2.ONE],
	[Vector2i.ONE],
]

func test_case1() -> void:
	assert_bool(true).is_equal(true);


func test_case2() -> void:
	assert_bool(false).is_equal(false);


@warning_ignore("unused_parameter")
func test_parameterized_static(value: int, expected: int, test_parameters := [
	[1, 1],
	[2, 2],
	[3, 3]
]) -> void:
	assert_int(value).is_equal(expected);


@warning_ignore("unused_parameter")
func test_parameterized_static_external(value :Variant, test_parameters := _test_seta) -> void:
	assert_object(assert_vector(value))\
		.is_not_null()\
		.is_instanceof(GdUnitVectorAssert)


@warning_ignore("unused_parameter")
func test_parameterized_dynamic(value :Variant, test_parameters := data_set()) -> void:
	assert_object(assert_vector(value))\
		.is_not_null()\
		.is_instanceof(GdUnitVectorAssert)


func data_set() -> Array:
	var test_values := []
	for index in 3:
		test_values.append(_test_seta[index])
	return test_values
