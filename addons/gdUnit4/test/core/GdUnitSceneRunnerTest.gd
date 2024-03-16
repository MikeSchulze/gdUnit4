# GdUnit generated TestSuite
class_name GdUnitSceneRunnerTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitSceneRunnerImpl.gd'


# loads the test runner and register for auto freeing after test
func load_test_scene() -> Node:
	return auto_free(load("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn").instantiate())


func before():
	# use a dedicated FPS because we calculate frames by time
	Engine.set_max_fps(60)


func after():
	Engine.set_max_fps(0)


## Utility to check if a test has failed in a particular line and if there is an error message
func assert_failed_at(line_number :int, expected_failure :String) -> bool:
	var is_failed = is_failure()
	var last_failure = GdAssertReports.current_failure()
	var last_failure_line = GdAssertReports.get_last_error_line_number()
	assert_str(last_failure).is_equal(expected_failure)
	assert_int(last_failure_line).is_equal(line_number)
	GdAssertReports.expect_fail(true)
	return is_failed


func test_get_property() -> void:
	var runner := scene_runner(load_test_scene())

	assert_that(runner.get_property("_box1")).is_instanceof(ColorRect)
	assert_that(runner.get_property("_invalid")).is_equal("The property '_invalid' not exist checked loaded scene.")
	assert_that(runner.get_property("_nullable")).is_null()


func test_set_property() -> void:
	var runner := scene_runner(load_test_scene())

	assert_that(runner.set_property("_invalid", 42)).is_equal(false)

	assert_that(runner.set_property("_nullable", RefCounted.new())).is_equal(true)
	assert_that(runner.get_property("_nullable")).is_instanceof(RefCounted)

func test_invoke_method() -> void:
	var runner := scene_runner(load_test_scene())

	assert_that(runner.invoke("add", 10, 12)).is_equal(22)
	assert_that(runner.invoke("sub", 10, 12)).is_equal("The method 'sub' not exist checked loaded scene.")


@warning_ignore("unused_parameter")
func test_simulate_frames(timeout = 5000) -> void:
	var runner := scene_runner(load_test_scene())
	var box1 :ColorRect = runner.get_property("_box1")
	# initial is white
	assert_object(box1.color).is_equal(Color.WHITE)

	# start color cycle by invoke the function 'start_color_cycle'
	runner.invoke("start_color_cycle")

	# we wait for 10 frames
	await runner.simulate_frames(10)
	# after 10 frame is still white
	assert_object(box1.color).is_equal(Color.WHITE)

	# we wait 30 more frames
	await runner.simulate_frames(30)
	# after 40 frames the box one should be changed to red
	assert_object(box1.color).is_equal(Color.RED)


@warning_ignore("unused_parameter")
func test_simulate_frames_withdelay(timeout = 4000) -> void:
	var runner := scene_runner(load_test_scene())
	var box1 :ColorRect = runner.get_property("_box1")
	# initial is white
	assert_object(box1.color).is_equal(Color.WHITE)

	# start color cycle by invoke the function 'start_color_cycle'
	runner.invoke("start_color_cycle")

	# we wait for 10 frames each with a 50ms delay
	await runner.simulate_frames(10, 50)
	# after 10 frame and in sum 500ms is should be changed to red
	assert_object(box1.color).is_equal(Color.RED)


@warning_ignore("unused_parameter")
func test_run_scene_colorcycle(timeout=2000) -> void:
	var runner := scene_runner(load_test_scene())
	var box1 :ColorRect = runner.get_property("_box1")
	# verify inital color
	assert_object(box1.color).is_equal(Color.WHITE)

	# start color cycle by invoke the function 'start_color_cycle'
	runner.invoke("start_color_cycle")

	# await for each color cycle is emited
	await runner.await_signal("panel_color_change", [box1, Color.RED])
	assert_object(box1.color).is_equal(Color.RED)
	await runner.await_signal("panel_color_change", [box1, Color.BLUE])
	assert_object(box1.color).is_equal(Color.BLUE)
	await runner.await_signal("panel_color_change", [box1, Color.GREEN])
	assert_object(box1.color).is_equal(Color.GREEN)


func test_simulate_scene_inteaction_by_press_enter(timeout=2000) -> void:
	var runner := scene_runner(load_test_scene())

	# inital no spell is fired
	assert_object(runner.find_child("Spell")).is_null()

	# fire spell be pressing enter key
	runner.simulate_key_pressed(KEY_ENTER)
	# wait until next frame
	await await_idle_frame()

	# verify a spell is created
	assert_object(runner.find_child("Spell")).is_not_null()

	# wait until spell is explode after around 1s
	var spell = runner.find_child("Spell")
	if spell == null:
		return
	await await_signal_on(spell, "spell_explode", [spell], timeout)

	# verify spell is removed when is explode
	assert_object(runner.find_child("Spell")).is_null()


# mock on a runner and spy on created spell
func test_simulate_scene_inteaction_in_combination_with_spy():
	var spy_ = spy(load_test_scene())
	# create a runner runner
	var runner := scene_runner(spy_)

	# simulate a key event to fire a spell
	runner.simulate_key_pressed(KEY_ENTER)
	verify(spy_).create_spell()

	var spell = runner.find_child("Spell")
	assert_that(spell).is_not_null()
	assert_that(spell.is_connected("spell_explode", Callable(spy_, "_destroy_spell"))).is_true()


func test_simulate_scene_interact_with_buttons():
	var spyed_scene = spy("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	var runner := scene_runner(spyed_scene)
	# test button 1 interaction
	await await_millis(1000)
	runner.set_mouse_pos(Vector2(60, 20))
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	verify(spyed_scene)._on_panel_color_changed(spyed_scene._box1, Color.RED)
	verify(spyed_scene)._on_panel_color_changed(spyed_scene._box1, Color.GRAY)
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box2, any_color())
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box3, any_color())

	# test button 2 interaction
	reset(spyed_scene)
	await await_millis(1000)
	runner.set_mouse_pos(Vector2(160, 20))
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box1, any_color())
	verify(spyed_scene)._on_panel_color_changed(spyed_scene._box2, Color.RED)
	verify(spyed_scene)._on_panel_color_changed(spyed_scene._box2, Color.GRAY)
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box3, any_color())

	# test button 3 interaction (is changed after 1s to gray)
	reset(spyed_scene)
	await await_millis(1000)
	runner.set_mouse_pos(Vector2(260, 20))
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box1, any_color())
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box2, any_color())
	# is changed to red
	verify(spyed_scene)._on_panel_color_changed(spyed_scene._box3, Color.RED)
	# no gray
	verify(spyed_scene, 0)._on_panel_color_changed(spyed_scene._box3, Color.GRAY)
	# after one second is changed to gray
	await await_millis(1200)
	verify(spyed_scene)._on_panel_color_changed(spyed_scene._box3, Color.GRAY)


func test_await_func_without_time_factor() -> void:
	var runner := scene_runner(load_test_scene())
	await runner.await_func("color_cycle").is_equal("black")


func test_await_func_with_time_factor() -> void:
	var runner := scene_runner(load_test_scene())

	# set max time factor to minimize waiting time checked `runner.wait_func`
	runner.set_time_factor(10)
	await runner.await_func("color_cycle").wait_until(200).is_equal("black")


func test_await_signal_without_time_factor() -> void:
	var runner := scene_runner(load_test_scene())
	var box1 :ColorRect = runner.get_property("_box1")

	runner.invoke("start_color_cycle")
	await runner.await_signal("panel_color_change", [box1, Color.RED])
	await runner.await_signal("panel_color_change", [box1, Color.BLUE])
	await runner.await_signal("panel_color_change", [box1, Color.GREEN])

	# should be interrupted is will never change to Color.KHAKI
	GdAssertReports.expect_fail()
	await runner.await_signal( "panel_color_change", [box1, Color.KHAKI], 300)
	if assert_failed_at(201, "await_signal_on(panel_color_change, [%s, %s]) timed out after 300ms" % [str(box1), str(Color.KHAKI)]):
		return
	fail("test should failed after 300ms checked 'await_signal'")


func test_await_signal_with_time_factor() -> void:
	var runner := scene_runner(load_test_scene())
	var box1 :ColorRect = runner.get_property("_box1")
	# set max time factor to minimize waiting time checked `runner.wait_func`
	runner.set_time_factor(10)
	runner.invoke("start_color_cycle")

	await runner.await_signal("panel_color_change", [box1, Color.RED], 100)
	await runner.await_signal("panel_color_change", [box1, Color.BLUE], 100)
	await runner.await_signal("panel_color_change", [box1, Color.GREEN], 100)

	# should be interrupted is will never change to Color.KHAKI
	GdAssertReports.expect_fail()
	await runner.await_signal("panel_color_change", [box1, Color.KHAKI], 30)
	if assert_failed_at(220, "await_signal_on(panel_color_change, [%s, %s]) timed out after 30ms" % [str(box1), str(Color.KHAKI)]):
		return
	fail("test should failed after 30ms checked 'await_signal'")


func test_simulate_until_signal() -> void:
	var runner := scene_runner(load_test_scene())
	var box1 :ColorRect = runner.get_property("_box1")

	# set max time factor to minimize waiting time checked `runner.wait_func`
	runner.invoke("start_color_cycle")

	await runner.simulate_until_signal("panel_color_change", box1, Color.RED)
	await runner.simulate_until_signal("panel_color_change", box1, Color.BLUE)
	await runner.simulate_until_signal("panel_color_change", box1, Color.GREEN)


@warning_ignore("unused_parameter")
func test_simulate_until_object_signal(timeout=2000) -> void:
	var runner := scene_runner(load_test_scene())

	# inital no spell is fired
	assert_object(runner.find_child("Spell")).is_null()

	# fire spell be pressing enter key
	runner.simulate_key_pressed(KEY_ENTER)
	# wait until next frame
	await await_idle_frame()
	var spell = runner.find_child("Spell")
	prints(spell)

	# simmulate scene until the spell is explode
	await runner.simulate_until_object_signal(spell, "spell_explode", spell)

	# verify spell is removed when is explode
	assert_object(runner.find_child("Spell")).is_null()


func test_runner_by_null_instance() -> void:
	var runner := scene_runner(null)
	assert_object(runner._current_scene).is_null()


func test_runner_by_invalid_resource_path() -> void:
	# not existing scene
	assert_object(scene_runner("res://test_scene.tscn")._current_scene).is_null()
	# not a path to a scene
	assert_object(scene_runner("res://addons/gdUnit4/test/core/resources/scenes/simple_scene.gd")._current_scene).is_null()


func test_runner_by_resource_path() -> void:
	var runner = scene_runner("res://addons/gdUnit4/test/core/resources/scenes/simple_scene.tscn")
	assert_object(runner.scene()).is_instanceof(Node2D)

	# verify the scene is freed when the runner is freed
	var scene = runner.scene()
	assert_bool(is_instance_valid(scene)).is_true()
	runner._notification(NOTIFICATION_PREDELETE)
	# give engine time to free the resources
	await await_idle_frame()
	# verify runner and scene is freed
	assert_bool(is_instance_valid(scene)).is_false()


func test_runner_by_invalid_scene_instance() -> void:
	var scene = RefCounted.new()
	var runner := scene_runner(scene)
	assert_object(runner._current_scene).is_null()


func test_runner_by_scene_instance() -> void:
	var scene = load("res://addons/gdUnit4/test/core/resources/scenes/simple_scene.tscn").instantiate()
	var runner := scene_runner(scene)
	assert_object(runner.scene()).is_instanceof(Node2D)

	# verify the scene is freed when the runner is freed
	runner._notification(NOTIFICATION_PREDELETE)
	# give engine time to free the resources
	await await_idle_frame()
	# scene runner using external scene do not free the scene at exit
	assert_bool(is_instance_valid(scene)).is_true()
	# needs to be manually freed
	scene.free()


func test_mouse_drag_and_drop() -> void:
	var spy_scene = spy("res://addons/gdUnit4/test/core/resources/scenes/drag_and_drop/DragAndDropTestScene.tscn")
	var runner := scene_runner(spy_scene)

	var slot_left :TextureRect = $"/root/DragAndDropScene/left/TextureRect"
	var slot_right :TextureRect = $"/root/DragAndDropScene/right/TextureRect"

	var save_mouse_pos := get_tree().root.get_mouse_position()
	# set inital mouse pos over the left slot
	var mouse_pos := slot_left.global_position + Vector2(10, 10)
	runner.set_mouse_pos(mouse_pos)
	await await_millis(1000)

	await await_idle_frame()
	var event := InputEventMouseMotion.new()
	event.position = mouse_pos
	event.global_position = save_mouse_pos
	verify(spy_scene, 1)._gui_input(event)

	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	assert_bool(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)).is_true()

	# start drag&drop to left pannel
	for i in 20:
		runner.simulate_mouse_move(mouse_pos + Vector2(i*.5*i, 0))
		await await_millis(40)

	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	assert_that(slot_right.texture).is_equal(slot_left.texture)


func test_runner_GD_356() -> void:
	# to avoid reporting the expected push_error as test failure we disable it
	ProjectSettings.set_setting(GdUnitSettings.REPORT_PUSH_ERRORS, false)
	var runner = scene_runner("res://addons/gdUnit4/test/core/resources/scenes/simple_scene.tscn")
	var player = runner.invoke("find_child", "Player", true, false)
	assert_that(player).is_not_null()
	await assert_func(player, "is_on_floor").wait_until(500).is_true()
	assert_that(runner.scene()).is_not_null()
	# run simulate_mouse_move_relative without await to reproduce https://github.com/MikeSchulze/gdUnit4/issues/356
	# this results into releasing the scene while `simulate_mouse_move_relative` is processing the mouse move
	runner.simulate_mouse_move_relative(Vector2(100, 100), 1.0)
	assert_that(runner.scene()).is_not_null()


# we override the scene runner function for test purposes to hide push_error notifications
func scene_runner(scene, verbose := false) -> GdUnitSceneRunner:
	return auto_free(GdUnitSceneRunnerImpl.new(scene, verbose, true))
