# GdUnit generated TestSuite
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitArrayAssertImpl.gd'

# small value format helper
func format_value(value) -> String:
	if value is Color:
		return "Color%s" % value
	if value is float:
		return "%f" % value
	if GdObjects.is_array_type(value):
		return ", ".join(Array(value))
	return "%s" % value


@warning_ignore("unused_parameter")
func test_is_null(_test :String, array, test_parameters = [
	["Array", Array()],
	["PackedByteArray", PackedByteArray()],
	["PackedInt32Array", PackedInt32Array()],
	["PackedInt64Array", PackedInt64Array()],
	["PackedFloat32Array", PackedFloat32Array()],
	["PackedFloat64Array", PackedFloat64Array()],
	["PackedStringArray", PackedStringArray()],
	["PackedVector2Array", PackedVector2Array()],
	["PackedVector3Array", PackedVector3Array()],
	["PackedColorArray", PackedColorArray()] ]
	) -> void:
	assert_array(null).is_null()
	assert_failure(func(): assert_array(array).is_null()) \
		.is_failed() \
		.has_message("Expecting: '<null>' but was empty")


@warning_ignore("unused_parameter")
func test_is_not_null(_test :String, array, test_parameters = [
	["Array", Array()],
	["PackedByteArray", PackedByteArray()],
	["PackedInt32Array", PackedInt32Array()],
	["PackedInt64Array", PackedInt64Array()],
	["PackedFloat32Array", PackedFloat32Array()],
	["PackedFloat64Array", PackedFloat64Array()],
	["PackedStringArray", PackedStringArray()],
	["PackedVector2Array", PackedVector2Array()],
	["PackedVector3Array", PackedVector3Array()],
	["PackedColorArray", PackedColorArray()] ]
	) -> void:
	assert_array(PackedByteArray()).is_not_null()
	
	assert_failure(func(): assert_array(null).is_not_null()) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")

@warning_ignore("unused_parameter")
func test_is_equal(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
	
	var other = array.duplicate()
	assert_array(array).is_equal(other)
	# should fail because the array not contains same elements and has diff size
	other.append(array[2])
	assert_failure(func(): assert_array(array).is_equal(other)) \
		.is_failed()


@warning_ignore("unused_parameter")
func test_is_not_equal(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
	
	var other = array.duplicate()
	other.append(array[2])
	assert_array(array).is_not_equal(other)
	# should fail because the array  contains same elements
	assert_failure(func(): assert_array(array).is_not_equal(array.duplicate())) \
		.is_failed()


@warning_ignore("unused_parameter")
func test_is_empty(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
		
	var empty = array.duplicate()
	empty.clear()
	assert_array(empty).is_empty()
	# should fail because the array is not empty
	assert_failure(func(): assert_array(array).is_empty()) \
		.is_failed() \
		.starts_with_message("Expecting:\n must be empty but was")


@warning_ignore("unused_parameter")
func test_is_not_empty(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
	
	assert_array(array).is_not_empty()
	# should fail because the array is empty
	var empty = array.duplicate()
	empty.clear()
	assert_failure(func(): assert_array(empty).is_not_empty()) \
		.is_failed() \
		.has_message("Expecting:\n must not be empty")


@warning_ignore("unused_parameter")
func test_has_size(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
	
	assert_array(array).has_size(5)
	# should fail because the array has a size of 5
	assert_failure(func(): assert_array(array).has_size(4)) \
		.is_failed() \
		.has_message("Expecting size:\n '4'\n but was\n '5'")


@warning_ignore("unused_parameter")
func test_contains(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
	
	assert_array(array).contains([array[1], array[3], array[4]])
	# should fail because the array not contains 7 and 6
	var do_contains := [array[1], 7, 6]
	assert_failure(func(): assert_array(array).contains(do_contains)) \
		.is_failed() \
		.has_message("""
			Expecting contains elements:
			 $source
			 do contains (in any order)
			 $contains
			but could not find elements:
			 7, 6"""
			.dedent()
			.trim_prefix("\n")
			.replace("$source", format_value(array))
			.replace("$contains", format_value(do_contains))
		)


@warning_ignore("unused_parameter")
func test_contains_exactly(_test :String, array, test_parameters = [
	["Array", Array([1, 2, 3, 4, 5])],
	["PackedByteArray", PackedByteArray([1, 2, 3, 4, 5])],
	["PackedInt32Array", PackedInt32Array([1, 2, 3, 4, 5])],
	["PackedInt64Array", PackedInt64Array([1, 2, 3, 4, 5])],
	["PackedFloat32Array", PackedFloat32Array([1, 2, 3, 4, 5])],
	["PackedFloat64Array", PackedFloat64Array([1, 2, 3, 4, 5])],
	["PackedStringArray", PackedStringArray([1, 2, 3, 4, 5])],
	["PackedVector2Array", PackedVector2Array([Vector2.ZERO, Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])],
	["PackedVector3Array", PackedVector3Array([Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN])],
	["PackedColorArray", PackedColorArray([Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.BLACK])] ]
	) -> void:
	
	assert_array(array).contains_exactly(array.duplicate())
	# should fail because the array not contains same elements but in different order
	var shuffled = array.duplicate()
	shuffled[1] = array[3]
	shuffled[3] = array[1]
	assert_failure(func(): assert_array(array).contains_exactly(shuffled)) \
		.is_failed() \
		.has_message("""
			Expecting contains exactly elements:
			 $source
			 do contains (in same order)
			 $contains
			 but has different order at position '1'
			 '$A' vs '$B'"""
			.dedent()
			.trim_prefix("\n")
			.replace("$A", format_value(array[1]))
			.replace("$B", format_value(array[3]))
			.replace("$source", format_value(array))
			.replace("$contains", format_value(shuffled))
		)


func test_override_failure_message(_test :String, array, test_parameters = [
	["Array", Array()],
	["PackedByteArray", PackedByteArray()],
	["PackedInt32Array", PackedInt32Array()],
	["PackedInt64Array", PackedInt64Array()],
	["PackedFloat32Array", PackedFloat32Array()],
	["PackedFloat64Array", PackedFloat64Array()],
	["PackedStringArray", PackedStringArray()],
	["PackedVector2Array", PackedVector2Array()],
	["PackedVector3Array", PackedVector3Array()],
	["PackedColorArray", PackedColorArray()] ]
	) -> void:
	
	assert_failure(func(): assert_array(array) \
			.override_failure_message("Custom failure message") \
			.is_null()) \
		.is_failed() \
		.has_message("Custom failure message")


var _value = 0
func next_value() -> PackedByteArray:
	_value += 1
	return PackedByteArray([_value])


func test_with_value_provider() -> void:
	assert_array(CallBackValueProvider.new(self, "next_value"))\
		.is_equal([1]).is_equal([2]).is_equal([3])
