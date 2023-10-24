# GdUnit generated TestSuite
class_name GdUnitFuncAssertImplTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")


# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitFuncAssertImpl.gd'
const GdUnitTools = preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")


# we need to skip await fail test because of an bug in Godot 4.0 stable
func is_skip_fail_await() -> bool:
	return Engine.get_version_info().hex < 0x40002


# using this helper to await for the given callable and assert the failure
func verify_failed(cb :Callable) -> GdUnitStringAssert:
	GdAssertReports.expect_fail(true)
	await cb.call()
	GdAssertReports.expect_fail(false)
	
	var error = GdAssertReports.current_failure()
	return assert_str(GdUnitTools.richtext_normalize(error))


class TestValueProvider:
	var _max_iterations :int
	var _current_itteration := 0
	
	func _init(iterations := 0):
		_max_iterations = iterations
	
	func bool_value() -> bool:
		_current_itteration += 1
		if _current_itteration == _max_iterations:
			return true
		return false
	
	func int_value() -> int:
		return 0
	
	func float_value() -> float:
		return 0.0
	
	func string_value() -> String:
		return "value"
	
	func object_value() -> Object:
		return Resource.new()
	
	func array_value() -> Array:
		return []
	
	func dict_value() -> Dictionary:
		return {}
	
	func vec2_value() -> Vector2:
		return Vector2.ONE
	
	func vec3_value() -> Vector3:
		return Vector3.ONE
	
	func no_value() -> void:
		pass
	
	func unknown_value():
		return Vector3.ONE


class ValueProvidersWithArguments:
	
	func is_type(_type :int) -> bool:
		return true
	
	func get_index(_instance :Object, _name :String) -> int:
		return 1
	
	func get_index2(_instance :Object, _name :String, _recursive := false) -> int:
		return 1


class TestIterativeValueProvider:
	var _max_iterations :int
	var _current_itteration := 0
	var _inital_value
	var _final_value
	
	func _init(inital_value, iterations :int, final_value):
		_max_iterations = iterations
		_inital_value = inital_value
		_final_value = final_value
	
	func bool_value() -> bool:
		_current_itteration += 1
		if _current_itteration >= _max_iterations:
			return _final_value
		return _inital_value
	
	func int_value() -> int:
		_current_itteration += 1
		if _current_itteration >= _max_iterations:
			return _final_value
		return _inital_value
	
	func obj_value() -> Variant:
		_current_itteration += 1
		if _current_itteration >= _max_iterations:
			return _final_value
		return _inital_value
		
	func has_type(type :int, _recursive :bool = true) -> int:
		_current_itteration += 1
		#await Engine.get_main_loop().idle_frame
		if type == _current_itteration:
			return _final_value
		return _inital_value
	
	func await_value() -> int:
		_current_itteration += 1
		await Engine.get_main_loop().process_frame
		prints("yielded_value", _current_itteration)
		if _current_itteration >= _max_iterations:
			return _final_value
		return _inital_value
	
	func reset() -> void:
		_current_itteration = 0
	
	func iteration() -> int:
		return _current_itteration


@warning_ignore("unused_parameter")
func test_is_null(timeout = 2000) -> void:
	var value_provider := TestIterativeValueProvider.new(RefCounted.new(), 5, null)
	# without default timeout od 2000ms
	assert_func(value_provider, "obj_value").is_not_null()
	await assert_func(value_provider, "obj_value").is_null()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "obj_value").is_not_null()
	await assert_func(value_provider, "obj_value").wait_until(5000).is_null()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# failure case
	if is_skip_fail_await():
		return
	value_provider = TestIterativeValueProvider.new(RefCounted.new(), 1, RefCounted.new())
	(await verify_failed(func(): await assert_func(value_provider, "obj_value", []).wait_until(100).is_null())) \
		.is_equal("Expected: is null but timed out after 100ms")


@warning_ignore("unused_parameter")
func test_is_not_null(timeout = 2000) -> void:
	var value_provider := TestIterativeValueProvider.new(null, 5, RefCounted.new())
	# without default timeout od 2000ms
	assert_func(value_provider, "obj_value").is_null()
	await assert_func(value_provider, "obj_value").is_not_null()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "obj_value").is_null()
	await assert_func(value_provider, "obj_value").wait_until(5000).is_not_null()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# failure case
	value_provider = TestIterativeValueProvider.new(null, 1, null)
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(value_provider, "obj_value", []).wait_until(100).is_not_null()))\
		.is_equal("Expected: is not null but timed out after 100ms")


@warning_ignore("unused_parameter")
func test_is_true(timeout = 2000) -> void:
	var value_provider := TestIterativeValueProvider.new(false, 5, true)
	# without default timeout od 2000ms
	assert_func(value_provider, "bool_value").is_false()
	await assert_func(value_provider, "bool_value").is_true()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "bool_value").is_false()
	await assert_func(value_provider, "bool_value").wait_until(5000).is_true()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# failure case
	value_provider = TestIterativeValueProvider.new(false, 1, false)
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(value_provider, "bool_value", []).wait_until(100).is_true()))\
		.is_equal("Expected: is true but timed out after 100ms")


@warning_ignore("unused_parameter")
func test_is_false(timeout = 2000) -> void:
	var value_provider := TestIterativeValueProvider.new(true, 5, false)
	# without default timeout od 2000ms
	assert_func(value_provider, "bool_value").is_true()
	await assert_func(value_provider, "bool_value").is_false()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "bool_value").is_true()
	await assert_func(value_provider, "bool_value").wait_until(5000).is_false()
	assert_int(value_provider.iteration()).is_equal(5)
	
	# failure case
	value_provider = TestIterativeValueProvider.new(true, 1, true)
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(value_provider, "bool_value", []).wait_until(100).is_false())) \
		.is_equal("Expected: is false but timed out after 100ms")


@warning_ignore("unused_parameter")
func test_is_equal(timeout = 2000) -> void:
	var value_provider := TestIterativeValueProvider.new(42, 5, 23)
	# without default timeout od 2000ms
	assert_func(value_provider, "int_value").is_equal(42)
	await assert_func(value_provider, "int_value").is_equal(23)
	assert_int(value_provider.iteration()).is_equal(5)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "int_value").is_equal(42)
	await assert_func(value_provider, "int_value").wait_until(5000).is_equal(23)
	assert_int(value_provider.iteration()).is_equal(5)
	
	# failing case
	value_provider = TestIterativeValueProvider.new(23, 1, 23)
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(value_provider, "int_value", []).wait_until(100).is_equal(25))) \
		.is_equal("Expected: is equal '25' but timed out after 100ms")


@warning_ignore("unused_parameter")
func test_is_not_equal(timeout = 2000) -> void:
	var value_provider := TestIterativeValueProvider.new(42, 5, 23)
	# without default timeout od 2000ms
	assert_func(value_provider, "int_value").is_equal(42)
	await assert_func(value_provider, "int_value").is_not_equal(42)
	assert_int(value_provider.iteration()).is_equal(5)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "int_value").is_equal(42)
	await assert_func(value_provider, "int_value").wait_until(5000).is_not_equal(42)
	assert_int(value_provider.iteration()).is_equal(5)
	
	# failing case
	value_provider = TestIterativeValueProvider.new(23, 1, 23)
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(value_provider, "int_value", []).wait_until(100).is_not_equal(23))) \
		.is_equal("Expected: is not equal '23' but timed out after 100ms")


@warning_ignore("unused_parameter")
func test_is_equal_wiht_func_arg(timeout = 1300) -> void:
	var value_provider := TestIterativeValueProvider.new(42, 10, 23)
	# without default timeout od 2000ms
	assert_func(value_provider, "has_type", [1]).is_equal(42)
	await assert_func(value_provider, "has_type", [10]).is_equal(23)
	assert_int(value_provider.iteration()).is_equal(10)
	
	# with a timeout of 5s
	value_provider.reset()
	assert_func(value_provider, "has_type", [1]).is_equal(42)
	await assert_func(value_provider, "has_type", [10]).wait_until(5000).is_equal(23)
	assert_int(value_provider.iteration()).is_equal(10)


# abort test after 500ms to fail
@warning_ignore("unused_parameter")
func test_timeout_and_assert_fails(timeout = 500) -> void:
	# disable temporary the timeout errors for this test
	discard_error_interupted_by_timeout()
	var value_provider := TestIterativeValueProvider.new(1, 10, 10)
	# wait longer than test timeout, the value will be never '42' 
	await assert_func(value_provider, "int_value").wait_until(1000).is_equal(42)
	fail("The test must be interrupted after 500ms")


func timed_function() -> Color:
	var color = Color.RED
	await await_millis(20)
	color = Color.GREEN
	await await_millis(20)
	color = Color.BLUE
	await await_millis(20)
	color = Color.BLACK
	return color


func test_timer_yielded_function() -> void:
	await assert_func(self, "timed_function").is_equal(Color.BLACK)
	# will be never red
	await assert_func(self, "timed_function").wait_until(100).is_not_equal(Color.RED)
	# failure case
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(self, "timed_function", []).wait_until(100).is_equal(Color.RED))) \
		.is_equal("Expected: is equal 'Color(1, 0, 0, 1)' but timed out after 100ms")


func test_timer_yielded_function_timeout() -> void:
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(self, "timed_function", []).wait_until(40).is_equal(Color.BLACK)))\
		.is_equal("Expected: is equal 'Color()' but timed out after 40ms")


func yielded_function() -> Color:
	var color = Color.RED
	await get_tree().process_frame
	color = Color.GREEN
	await get_tree().process_frame
	color = Color.BLUE
	await get_tree().process_frame
	color = Color.BLACK
	return color


func test_idle_frame_yielded_function() -> void:
	await assert_func(self, "yielded_function").is_equal(Color.BLACK)
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(self, "yielded_function", []).wait_until(500).is_equal(Color.RED))) \
		.is_equal("Expected: is equal 'Color(1, 0, 0, 1)' but timed out after 500ms")


func test_has_failure_message() -> void:
	if is_skip_fail_await():
		return
	var value_provider := TestIterativeValueProvider.new(10, 1, 10)
	(await verify_failed(func(): await assert_func(value_provider, "int_value", []).wait_until(500).is_equal(42))) \
		.is_equal("Expected: is equal '42' but timed out after 500ms")


func test_override_failure_message() -> void:
	if is_skip_fail_await():
		return
	var value_provider := TestIterativeValueProvider.new(10, 1, 20)
	(await verify_failed(func(): await assert_func(value_provider, "int_value", []) \
			.override_failure_message("Custom failure message") \
			.wait_until(100) \
			.is_equal(42))) \
		.is_equal("Custom failure message")


@warning_ignore("unused_parameter")
func test_invalid_function(timeout = 100):
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_func(self, "invalid_func_name", [])\
		.wait_until(1000)\
		.is_equal(42)))\
		.starts_with("The function 'invalid_func_name' do not exists checked instance")
