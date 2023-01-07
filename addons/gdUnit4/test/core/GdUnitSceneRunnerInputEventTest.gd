# GdUnit generated TestSuite
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitSceneRunner.gd'


var _runner :GdUnitSceneRunner
var _scene_spy :Node


func before():
	# TODO verify input position and global_position if failing when the view is shown
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	DisplayServer.window_set_current_screen(0)
	DisplayServer.window_set_position(Vector2i.ZERO)
	DisplayServer.window_set_size(Vector2(1024, 800))
	DisplayServer.window_set_min_size(Vector2(1024, 800))
	#DisplayServer.window_set_max_size(Vector2(1024, 800))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_move_to_foreground()


func before_test():
	# reset global mouse position back to inital state
	var max_iteration_to_wait = 0
	while mouse_global_position() > Vector2.ZERO and max_iteration_to_wait < 1000:
		Input.warp_mouse(Vector2.ZERO)
		await await_idle_frame()
		max_iteration_to_wait += 1
	assert_inital_mouse_state()
	assert_inital_key_state()
	_scene_spy = spy("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	_runner = scene_runner(_scene_spy)


func after_test():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)


func mouse_global_position() -> Vector2:
	return get_tree().root.get_mouse_position()


# asserts to KeyList Enums
func assert_inital_key_state():
	# scacode 4194304-4194415
	for key in range(KEY_SPECIAL, KEY_LAUNCHF):
		assert_that(Input.is_key_pressed(key)).is_false()
		assert_that(Input.is_physical_key_pressed(key)).is_false()
	# keycode 32-255
	for key in range(KEY_SPACE, KEY_SECTION):
		assert_that(Input.is_key_pressed(key)).is_false()
		assert_that(Input.is_physical_key_pressed(key)).is_false()


#asserts to Mouse ButtonList Enums
func assert_inital_mouse_state():
	for button in [
		MOUSE_BUTTON_LEFT,
		MOUSE_BUTTON_MIDDLE,
		MOUSE_BUTTON_RIGHT,
		MOUSE_BUTTON_XBUTTON1,
		MOUSE_BUTTON_XBUTTON2,
		MOUSE_BUTTON_WHEEL_UP,
		MOUSE_BUTTON_WHEEL_DOWN,
		MOUSE_BUTTON_WHEEL_LEFT,
		MOUSE_BUTTON_WHEEL_RIGHT,
		]:
		assert_that(Input.is_mouse_button_pressed(button)).is_false()
	assert_that(Input.get_mouse_button_mask()).is_equal(0)


func test_reset_to_inital_state_on_release():
	var runner = scene_runner("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	# simulate mouse buttons and key press but we never released it
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_MIDDLE)
	runner.simulate_key_press(KEY_0)
	runner.simulate_key_press(KEY_X)
	await await_idle_frame()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_true()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)).is_true()
	assert_that(Input.is_key_pressed(KEY_0)).is_true()
	assert_that(Input.is_key_pressed(KEY_X)).is_true()
	# unreference the scene runner to enforce reset to initial Input state
	runner._notification(NOTIFICATION_PREDELETE)
	await await_idle_frame()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_false()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_false()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)).is_false()
	assert_that(Input.is_key_pressed(KEY_0)).is_false()
	assert_that(Input.is_key_pressed(KEY_X)).is_false()


func test_simulate_key_press() -> void:
	# iterate over some example keys
	for key in [KEY_A, KEY_D, KEY_X, KEY_0]:
		_runner.simulate_key_press(key)
		await await_idle_frame()
		
		var event := InputEventKey.new()
		event.keycode = key
		event.physical_keycode = key
		event.pressed = true
		verify(_scene_spy, 1)._input(event)
		assert_that(Input.is_key_pressed(key)).is_true()
	# verify all this keys are still handled as pressed
	assert_that(Input.is_key_pressed(KEY_A)).is_true()
	assert_that(Input.is_key_pressed(KEY_D)).is_true()
	assert_that(Input.is_key_pressed(KEY_X)).is_true()
	assert_that(Input.is_key_pressed(KEY_0)).is_true()
	# other keys are not pressed
	assert_that(Input.is_key_pressed(KEY_B)).is_false()
	assert_that(Input.is_key_pressed(KEY_G)).is_false()
	assert_that(Input.is_key_pressed(KEY_Z)).is_false()
	assert_that(Input.is_key_pressed(KEY_1)).is_false()


func test_simulate_key_press_with_modifiers() -> void:
	# press shift key + A
	_runner.simulate_key_press(KEY_SHIFT)
	_runner.simulate_key_press(KEY_A)
	await await_idle_frame()
	
	# results in two events, first is the shift key is press
	var event := InputEventKey.new()
	event.keycode = KEY_SHIFT
	event.physical_keycode = KEY_SHIFT
	event.pressed = true
	event.shift_pressed = true
	verify(_scene_spy, 1)._input(event)
	
	# second is the comnbination of current press shift and key A
	event = InputEventKey.new()
	event.keycode = KEY_A
	event.physical_keycode = KEY_A
	event.pressed = true
	event.shift_pressed = true
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_key_pressed(KEY_SHIFT)).is_true()
	assert_that(Input.is_key_pressed(KEY_A)).is_true()


func test_simulate_many_keys_press() -> void:
	# press and hold keys W and Z
	_runner.simulate_key_press(KEY_W)
	_runner.simulate_key_press(KEY_Z)
	await await_idle_frame()
	
	assert_that(Input.is_key_pressed(KEY_W)).is_true()
	assert_that(Input.is_physical_key_pressed(KEY_W)).is_true()
	assert_that(Input.is_key_pressed(KEY_Z)).is_true()
	assert_that(Input.is_physical_key_pressed(KEY_Z)).is_true()
	
	#now release key w
	_runner.simulate_key_release(KEY_W)
	await await_idle_frame()
	
	assert_that(Input.is_key_pressed(KEY_W)).is_false()
	assert_that(Input.is_physical_key_pressed(KEY_W)).is_false()
	assert_that(Input.is_key_pressed(KEY_Z)).is_true()
	assert_that(Input.is_physical_key_pressed(KEY_Z)).is_true()


func test_simulate_set_mouse_pos():
	
	await await_millis(5000)
	
	# set mouse to pos 100, 100
	_runner.set_mouse_pos(Vector2(100, 100))
	await await_idle_frame()
	var event := InputEventMouseMotion.new()
	event.position = Vector2(100, 100)
	event.global_position = mouse_global_position()
	verify(_scene_spy, 1)._input(event)
	
	# set mouse to pos 800, 400
	_runner.set_mouse_pos(Vector2(800, 400))
	await await_idle_frame()
	event = InputEventMouseMotion.new()
	event.position = Vector2(800, 400)
	event.global_position = mouse_global_position()
	verify(_scene_spy, 1)._input(event)
	
	# and again back to 100,100
	_runner.set_mouse_pos(Vector2(100, 100))
	await await_idle_frame()
	event = InputEventMouseMotion.new()
	event.position = Vector2(100, 100)
	event.global_position = mouse_global_position()
	verify(_scene_spy, 2)._input(event)


func test_simulate_set_mouse_pos_with_modifiers():
	var is_alt := false
	var is_control := false
	var is_shift := false
	
	for modifier in [KEY_SHIFT, KEY_CTRL, KEY_ALT]:
		is_alt = is_alt or KEY_ALT == modifier
		is_control = is_control or KEY_CTRL == modifier
		is_shift = is_shift or KEY_SHIFT == modifier
		
		for mouse_button in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]:
			# simulate press shift, set mouse pos and final press mouse button
			_runner.simulate_key_press(modifier)
			_runner.set_mouse_pos(Vector2(10, 10))
			_runner.simulate_mouse_button_press(mouse_button)
			await await_idle_frame()
			
			var event := InputEventMouseButton.new()
			event.position = Vector2(10, 10)
			event.global_position = mouse_global_position()
			event.alt_pressed = is_alt
			event.ctrl_pressed = is_control
			event.shift_pressed = is_shift
			event.pressed = true
			event.button_index = mouse_button
			event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(mouse_button)
			verify(_scene_spy, 1)._input(event)
			assert_that(Input.is_mouse_button_pressed(mouse_button)).is_true()
			# finally release it
			_runner.simulate_mouse_button_pressed(mouse_button)
			await await_idle_frame()


func test_simulate_mouse_move():
	_runner.set_mouse_pos(Vector2(10, 10))
	_runner.simulate_mouse_move(Vector2(400, 100))
	await await_idle_frame()
	
	var event = InputEventMouseMotion.new()
	event.position = Vector2(400, 100)
	event.global_position = mouse_global_position()
	event.relative = Vector2(400, 100) - Vector2(10, 10)
	verify(_scene_spy, 1)._input(event)
	
	# move mouse to next pos
	_runner.simulate_mouse_move(Vector2(55, 42))
	await await_idle_frame()
	
	event = InputEventMouseMotion.new()
	event.position = Vector2(55, 42)
	event.global_position = mouse_global_position()
	event.relative = Vector2(55, 42) - Vector2(400, 100)
	verify(_scene_spy, 1)._input(event)


func test_simulate_mouse_move_relative():
	#OS.window_minimized = false
	_runner.set_mouse_pos(Vector2(10, 10))
	await await_idle_frame()
	#assert_that(_runner.get_mouse_position()).is_equal(Vector2(10, 10))
	
	await _runner.simulate_mouse_move_relative(Vector2(900, 400), Vector2(.2, 1))
	await await_idle_frame()
	assert_that(_runner.get_mouse_position()).is_equal(Vector2(910, 410))

func test_simulate_mouse_button_press_left():
	# simulate mouse button press and hold
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	
	var event := InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(MOUSE_BUTTON_LEFT)
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()


func test_simulate_mouse_button_press_left_doubleclick():
	# simulate mouse button press double_click
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT, true)
	await await_idle_frame()
	
	var event := InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.double_click = true
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(MOUSE_BUTTON_LEFT)
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()


func test_simulate_mouse_button_press_right():
	# simulate mouse button press and hold
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
	await await_idle_frame()
	
	var event := InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_RIGHT
	event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(MOUSE_BUTTON_RIGHT)
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_true()


func test_simulate_mouse_button_press_left_and_right():
	# simulate mouse button press left+right
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
	await await_idle_frame()
	
	# results in two events, first is left mouse button
	var event := InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT
	verify(_scene_spy, 1)._input(event)
	
	# second is left+right and combined mask
	event = InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_RIGHT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT|MOUSE_BUTTON_MASK_RIGHT
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_true()
	assert_that(Input.get_mouse_button_mask()).is_equal(MOUSE_BUTTON_MASK_LEFT|MOUSE_BUTTON_MASK_RIGHT)


func test_simulate_mouse_button_press_left_and_right_and_release():
	# simulate mouse button press left+right
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	_runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
	await await_idle_frame()
	
	# will results into two events
	# first for left mouse button
	var event := InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT
	verify(_scene_spy, 1)._input(event)
	
	# second is left+right and combined mask
	event = InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_RIGHT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT|MOUSE_BUTTON_MASK_RIGHT
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_true()
	assert_that(Input.get_mouse_button_mask()).is_equal(MOUSE_BUTTON_MASK_LEFT|MOUSE_BUTTON_MASK_RIGHT)
	
	# now release the right button
	_runner.simulate_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	await await_idle_frame()
	# will result in right button press false but stay with mask for left pressed
	event = InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = false
	event.button_index = MOUSE_BUTTON_RIGHT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_false()
	assert_that(Input.get_mouse_button_mask()).is_equal(MOUSE_BUTTON_MASK_LEFT)
	
	# finally relase left button
	_runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	# will result in right button press false but stay with mask for left pressed
	event = InputEventMouseButton.new()
	event.position = Vector2.ZERO
	event.global_position = mouse_global_position()
	event.pressed = false
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = 0
	verify(_scene_spy, 1)._input(event)
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_false()
	assert_that(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)).is_false()
	assert_that(Input.get_mouse_button_mask()).is_equal(0)


func test_simulate_mouse_button_pressed():
	for mouse_button in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]:
		# simulate mouse button press and release
		_runner.simulate_mouse_button_pressed(mouse_button)
		await await_idle_frame()
		
		# it genrates two events, first for press and second as released
		var event := InputEventMouseButton.new()
		event.position = Vector2.ZERO
		event.global_position = mouse_global_position()
		event.pressed = true
		event.button_index = mouse_button
		event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(mouse_button)
		verify(_scene_spy, 1)._input(event)
		
		event = InputEventMouseButton.new()
		event.position = Vector2.ZERO
		event.global_position = mouse_global_position()
		event.pressed = false
		event.button_index = mouse_button
		event.button_mask = 0
		verify(_scene_spy, 1)._input(event)
		assert_that(Input.is_mouse_button_pressed(mouse_button)).is_false()
		verify(_scene_spy, 2)._input(any_class(InputEventMouseButton))
		reset(_scene_spy)

func test_simulate_mouse_button_pressed_doubleclick():
	for mouse_button in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]:
		# simulate mouse button press and release by double_click
		_runner.simulate_mouse_button_pressed(mouse_button, true)
		await await_idle_frame()
		
		# it genrates two events, first for press and second as released
		var event := InputEventMouseButton.new()
		event.position = Vector2.ZERO
		event.global_position = mouse_global_position()
		event.pressed = true
		event.double_click = true
		event.button_index = mouse_button
		event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(mouse_button)
		verify(_scene_spy, 1)._input(event)
		
		event = InputEventMouseButton.new()
		event.position = Vector2.ZERO
		event.global_position = mouse_global_position()
		event.pressed = false
		event.double_click = false
		event.button_index = mouse_button
		event.button_mask = 0
		verify(_scene_spy, 1)._input(event)
		assert_that(Input.is_mouse_button_pressed(mouse_button)).is_false()
		verify(_scene_spy, 2)._input(any_class(InputEventMouseButton))
		reset(_scene_spy)

func test_simulate_mouse_button_press_and_release():
	for mouse_button in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT]:
		# simulate mouse button press and release
		_runner.simulate_mouse_button_press(mouse_button)
		await await_idle_frame()
		
		var event := InputEventMouseButton.new()
		event.position = Vector2.ZERO
		event.global_position = mouse_global_position()
		event.pressed = true
		event.button_index = mouse_button
		event.button_mask = GdUnitSceneRunnerImpl.MAP_MOUSE_BUTTON_MASKS.get(mouse_button)
		verify(_scene_spy, 1)._input(event)
		assert_that(Input.is_mouse_button_pressed(mouse_button)).is_true()
		
		# now simulate mouse button release
		_runner.simulate_mouse_button_release(mouse_button)
		await await_idle_frame()
		
		event = InputEventMouseButton.new()
		event.position = Vector2.ZERO
		event.global_position = mouse_global_position()
		event.pressed = false
		event.button_index = mouse_button
		event.button_mask = 0
		verify(_scene_spy, 1)._input(event)
		assert_that(Input.is_mouse_button_pressed(mouse_button)).is_false()
