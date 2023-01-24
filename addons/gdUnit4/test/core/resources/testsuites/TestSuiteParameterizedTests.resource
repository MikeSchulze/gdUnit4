extends GdUnitTestSuite

@warning_ignore("unused_parameter")
@warning_ignore(return_value_discarded)

func test_parameterized_bool_value(a: int, expected :bool, test_parameters := [
	[0, false],
	[1, true]]):

	assert_that(bool(a)).is_equal(expected)

func test_parameterized_int_values(a: int, b :int, c :int, expected :int, test_parameters := [
	[1, 2, 3, 6],
	[3, 4, 5, 12],
	[6, 7, 8, 21] ]):

	assert_that(a+b+c).is_equal(expected)

func test_parameterized_int_values_fail(a: int, b :int, c :int, expected :int, test_parameters := [
	[1, 2, 3, 6],
	[3, 4, 5, 11],
	[6, 7, 8, 22] ]):

	assert_that(a+b+c).is_equal(expected)

func test_parameterized_float_values(a: float, b :float, expected :float, test_parameters := [
	[2.2, 2.2, 4.4],
	[2.2, 2.3, 4.5],
	[3.3, 2.2, 5.5] ]):

	assert_float(a+b).is_equal(expected)

func test_parameterized_string_values(a: String, b :String, expected :String, test_parameters := [
	["2.2", "2.2", "2.22.2"],
	["foo", "bar", "foobar"],
	["a", "b", "ab"] ]):

	assert_that(a+b).is_equal(expected)

func test_parameterized_Vector2_values(a: Vector2, b :Vector2, expected :Vector2, test_parameters := [
	[Vector2.ONE, Vector2.ONE, Vector2(2, 2)],
	[Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO],
	[Vector2.ZERO, Vector2.LEFT, Vector2.LEFT] ]):

	assert_that(a+b).is_equal(expected)

func test_parameterized_Vector3_values(a: Vector3, b :Vector3, expected :Vector3, test_parameters := [
	[Vector3.ONE, Vector3.ONE, Vector3(2, 2, 2)],
	[Vector3.LEFT, Vector3.RIGHT, Vector3.ZERO],
	[Vector3.ZERO, Vector3.LEFT, Vector3.LEFT] ]):

	assert_that(a+b).is_equal(expected)

class TestObj extends Resource:
	var _value :String

	func _init(value :String):
		_value = value

	func _to_string() -> String:
		return _value

func test_parameterized_obj_values(a: Object, b :Object, expected :String, test_parameters := [
	[TestObj.new("abc"), TestObj.new("def"), "abcdef"]]):

	assert_that(a.to_string()+b.to_string()).is_equal(expected)


func test_dictionary_div_number_types(
		value : Dictionary,
		expected : Dictionary,
		test_parameters : Array = [
			[{ top = 50.0,	bottom = 50.0,	left = 50.0,	right = 50.0},	{ top = 50, 	bottom = 50,	left = 50,  	right = 50}],
			[{ top = 50.0,	bottom = 50.0,	left = 50.0,	right = 50.0},	{ top = 50.0,	bottom = 50.0,	left = 50.0,	right = 50.0}],
			[{ top = 50,	bottom = 50,	left = 50,  	right = 50},	{ top = 50.0,	bottom = 50.0,	left = 50.0,	right = 50.0}],
			[{ top = 50,	bottom = 50,	left = 50,  	right = 50},	{ top = 50, 	bottom = 50,	left = 50,  	right = 50}],
		]
	) -> void:
		assert_that(value).is_equal(expected)
