class_name GdUnitSpyTest
extends GdUnitTestSuite


func test_spy_instance_id_is_unique():
	var m1  = spy(RefCounted.new())
	var m2  = spy(RefCounted.new())
	# test the internal instance id is unique
	assert_that(m1.__instance_id()).is_not_equal(m2.__instance_id())
	assert_object(m1).is_not_same(m2)


func test_cant_spy_is_not_a_instance():
	# returns null because spy needs an 'real' instance to by spy checked
	var spy_node = spy(Node)
	assert_object(spy_node).is_null()


func test_spy_on_Node():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	# verify we have no interactions currently checked this instance
	verify_no_interactions(spy_node)
	
	assert_object(spy_node)\
		.is_not_null()\
		.is_instanceof(Node)\
		.is_not_same(instance)
	
	# call first time
	spy_node.set_process(false)
	
	# verify is called one times
	verify(spy_node).set_process(false)
	# just double check that verify has no affect to the counter
	verify(spy_node).set_process(false)
	
	# call a scond time
	spy_node.set_process(false)
	# verify is called two times
	verify(spy_node, 2).set_process(false)
	verify(spy_node, 2).set_process(false)


func test_spy_source_with_class_name_by_resource_path() -> void:
	var instance = auto_free(load('res://addons/gdUnit4/test/mocker/resources/GD-256/world.gd').new())
	var m = spy(instance)
	var head :String = m.get_script().source_code.substr(0, 200)
	assert_str(head)\
		.contains("class_name DoubledMunderwoodPathingWorld")\
		.contains("extends 'res://addons/gdUnit4/test/mocker/resources/GD-256/world.gd'")


func test_spy_source_with_class_name_by_class() -> void:
	var m = spy(auto_free(Munderwood_Pathing_World.new()))
	var head :String = m.get_script().source_code.substr(0, 200)
	assert_str(head)\
		.contains("class_name DoubledMunderwoodPathingWorld")\
		.contains("extends 'res://addons/gdUnit4/test/mocker/resources/GD-256/world.gd'")


func test_spy_extends_godot_class() -> void:
	var m = spy(auto_free(World3D.new()))
	var head :String = m.get_script().source_code.substr(0, 200)
	assert_str(head)\
		.contains("class_name DoubledWorld")\
		.contains("extends World3D")


func test_spy_on_custom_class():
	var instance :AdvancedTestClass = auto_free(AdvancedTestClass.new())
	var spy_instance = spy(instance)
	
	# verify we have currently no interactions
	verify_no_interactions(spy_instance)
	
	assert_object(spy_instance)\
		.is_not_null()\
		.is_instanceof(AdvancedTestClass)\
		.is_not_same(instance)
	
	spy_instance.setup_local_to_scene()
	verify(spy_instance, 1).setup_local_to_scene()
	
	# call first time script func with different arguments
	spy_instance.get_area("test_a")
	spy_instance.get_area("test_b")
	spy_instance.get_area("test_c")
	
	# verify is each called only one time for different arguments
	verify(spy_instance, 1).get_area("test_a")
	verify(spy_instance, 1).get_area("test_b")
	verify(spy_instance, 1).get_area("test_c")
	# an second call with arg "test_c"
	spy_instance.get_area("test_c")
	verify(spy_instance, 1).get_area("test_a")
	verify(spy_instance, 1).get_area("test_b")
	verify(spy_instance, 2).get_area("test_c")
	
	# verify if a not used argument not counted
	verify(spy_instance, 0).get_area("test_no")


# GD-291 https://github.com/MikeSchulze/gdUnit4/issues/291
func test_spy_class_with_custom_formattings() -> void:
	var resource = load("res://addons/gdUnit4/test/mocker/resources/ClassWithCustomFormattings.gd")
	var do_spy = spy(auto_free(resource.new("test")))
	do_spy.a1("set_name", "", true)
	verify(do_spy, 1).a1("set_name", "", true)
	verify_no_more_interactions(do_spy)
	assert_failure(func(): verify_no_interactions(do_spy))\
		.is_failed() \
		.has_line(112)


func test_spy_copied_class_members():
	var instance = auto_free(load("res://addons/gdUnit4/test/mocker/resources/TestPersion.gd").new("user-x", "street", 56616))
	assert_that(instance._name).is_equal("user-x")
	assert_that(instance._value).is_equal(1024)
	assert_that(instance._address._street).is_equal("street")
	assert_that(instance._address._code).is_equal(56616)
	
	# spy it
	var spy_instance = spy(instance)
	reset(spy_instance)
	
	# verify members are inital copied
	assert_that(spy_instance._name).is_equal("user-x")
	assert_that(spy_instance._value).is_equal(1024)
	assert_that(spy_instance._address._street).is_equal("street")
	assert_that(spy_instance._address._code).is_equal(56616)
	
	spy_instance._value = 2048
	assert_that(instance._value).is_equal(1024)
	assert_that(spy_instance._value).is_equal(2048)


func test_spy_copied_class_members_on_node():
	var node :Node = auto_free(Node.new())
	# checked a fresh node the name is empty and results into a error when copied at spy
	# E 0:00:01.518   set_name: Condition "name == """ is true.
	# C++ Source>  scene/main/node.cpp:934 @ set_name()
	# we set a placeholder instead
	assert_that(spy(node).name).is_equal("<empty>")
	
	node.set_name("foo")
	assert_that(spy(node).name).is_equal("foo")


func test_spy_on_inner_class():
	var instance :AdvancedTestClass.AtmosphereData = auto_free(AdvancedTestClass.AtmosphereData.new())
	var spy_instance :AdvancedTestClass.AtmosphereData = spy(instance)
	
	# verify we have currently no interactions
	verify_no_interactions(spy_instance)
	
	assert_object(spy_instance)\
		.is_not_null()\
		.is_instanceof(AdvancedTestClass.AtmosphereData)\
		.is_not_same(instance)
	
	spy_instance.set_data(AdvancedTestClass.AtmosphereData.SMOKY, 1.2)
	spy_instance.set_data(AdvancedTestClass.AtmosphereData.SMOKY, 1.3)
	verify(spy_instance, 1).set_data(AdvancedTestClass.AtmosphereData.SMOKY, 1.2)
	verify(spy_instance, 1).set_data(AdvancedTestClass.AtmosphereData.SMOKY, 1.3)


func test_spy_on_singleton():
	# setup monitor to collect expected push_error notifications
	var monitor := GodotGdErrorMonitor.new()
	monitor.start()
	# We not allow to spy on a singleton
	var spy_node = spy(Input)
	await await_idle_frame()
	monitor.stop()
	assert_object(spy_node).is_null()
	await monitor.scan(true)
	assert_array(monitor.to_reports()).has_size(1)
	if not is_failure():
		assert_str(monitor.to_reports()[0].message()).contains("Spy on a Singleton is not allowed! 'Input'")


func test_example_verify():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	# verify we have no interactions currently checked this instance
	verify_no_interactions(spy_node)
	
	# call with different arguments
	spy_node.set_process(false) # 1 times
	spy_node.set_process(true) # 1 times
	spy_node.set_process(true) # 2 times
	
	# verify how often we called the function with different argument
	verify(spy_node, 2).set_process(true) # in sum two times with true
	verify(spy_node, 1).set_process(false)# in sum one time with false
	
	# verify total sum by using an argument matcher
	verify(spy_node, 3).set_process(any_bool())


func test_verify_fail():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	# interact two time
	spy_node.set_process(true) # 1 times
	spy_node.set_process(true) # 2 times
	
	# verify we interacts two times
	verify(spy_node, 2).set_process(true)
	
	# verify should fail because we interacts two times and not one
	var expected_error := """
		Expecting interaction on:
			'set_process(true :bool)'	1 time's
		But found interactions on:
			'set_process(true :bool)'	2 time's""" \
			.dedent().trim_prefix("\n")
	assert_failure(func(): verify(spy_node, 1).set_process(true)) \
		.is_failed() \
		.has_line(222) \
		.has_message(expected_error)


func test_verify_func_interaction_wiht_PoolStringArray():
	var spy_instance :ClassWithPoolStringArrayFunc = spy(ClassWithPoolStringArrayFunc.new())
	
	spy_instance.set_values(PackedStringArray())
	
	verify(spy_instance).set_values(PackedStringArray())
	verify_no_more_interactions(spy_instance)


func test_verify_func_interaction_wiht_PackedStringArray_fail():
	var spy_instance :ClassWithPoolStringArrayFunc = spy(ClassWithPoolStringArrayFunc.new())
	
	spy_instance.set_values(PackedStringArray())
	
	# try to verify with default array type instead of PackedStringArray type
	var expected_error := """
		Expecting interaction on:
			'set_values([] :Array)'	1 time's
		But found interactions on:
			'set_values([] :PackedStringArray)'	1 time's""" \
			.dedent().trim_prefix("\n")
	assert_failure(func(): verify(spy_instance, 1).set_values([])) \
		.is_failed() \
		.has_line(249) \
		.has_message(expected_error)
	
	reset(spy_instance)
	# try again with called two times and different args
	spy_instance.set_values(PackedStringArray())
	spy_instance.set_values(PackedStringArray(["a", "b"]))
	spy_instance.set_values([1, 2])
	expected_error = """
		Expecting interaction on:
			'set_values([] :Array)'	1 time's
		But found interactions on:
			'set_values([] :PackedStringArray)'	1 time's
			'set_values(["a", "b"] :PackedStringArray)'	1 time's
			'set_values([1, 2] :Array)'	1 time's""" \
			.dedent().trim_prefix("\n")
	assert_failure(func(): verify(spy_instance, 1).set_values([])) \
		.is_failed() \
		.has_line(267) \
		.has_message(expected_error)


func test_reset():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	# call with different arguments
	spy_node.set_process(false) # 1 times
	spy_node.set_process(true) # 1 times
	spy_node.set_process(true) # 2 times
	
	verify(spy_node, 2).set_process(true)
	verify(spy_node, 1).set_process(false)
	
	# now reset the spy
	reset(spy_node)
	# verify all counters have been reset
	verify_no_interactions(spy_node)


func test_verify_no_interactions():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	# verify we have no interactions checked this mock
	verify_no_interactions(spy_node)


func test_verify_no_interactions_fails():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	# interact
	spy_node.set_process(false) # 1 times
	spy_node.set_process(true) # 1 times
	spy_node.set_process(true) # 2 times
	
	var expected_error ="""
		Expecting no more interactions!
		But found interactions on:
			'set_process(false :bool)'	1 time's
			'set_process(true :bool)'	2 time's""" \
			.dedent().trim_prefix("\n")
	# it should fail because we have interactions
	assert_failure(func(): verify_no_interactions(spy_node)) \
		.is_failed() \
		.has_line(315) \
		.has_message(expected_error)


func test_verify_no_more_interactions():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	spy_node.is_ancestor_of(instance)
	spy_node.set_process(false)
	spy_node.set_process(true)
	spy_node.set_process(true)
	
	# verify for called functions
	verify(spy_node, 1).is_ancestor_of(instance)
	verify(spy_node, 2).set_process(true)
	verify(spy_node, 1).set_process(false)
	
	# There should be no more interactions checked this mock
	verify_no_more_interactions(spy_node)


func test_verify_no_more_interactions_but_has():
	var instance :Node = auto_free(Node.new())
	var spy_node = spy(instance)
	
	spy_node.is_ancestor_of(instance)
	spy_node.set_process(false)
	spy_node.set_process(true)
	spy_node.set_process(true)
	
	# now we simulate extra calls that we are not explicit verify
	spy_node.is_inside_tree()
	spy_node.is_inside_tree()
	# a function with default agrs
	spy_node.find_child("mask")
	# same function again with custom agrs
	spy_node.find_child("mask", false, false)
	
	# verify 'all' exclusive the 'extra calls' functions
	verify(spy_node, 1).is_ancestor_of(instance)
	verify(spy_node, 2).set_process(true)
	verify(spy_node, 1).set_process(false)
	
	# now use 'verify_no_more_interactions' to check we have no more interactions checked this mock
	# but should fail with a collecion of all not validated interactions
	var expected_error ="""
		Expecting no more interactions!
		But found interactions on:
			'is_inside_tree()'	2 time's
			'find_child(mask :String, true :bool, true :bool)'	1 time's
			'find_child(mask :String, false :bool, false :bool)'	1 time's""" \
			.dedent().trim_prefix("\n")
	assert_failure(func(): verify_no_more_interactions(spy_node)) \
		.is_failed() \
		.has_line(370) \
		.has_message(expected_error)


class ClassWithStaticFunctions:
	
	static func foo() -> void:
		pass
	
	static func bar():
		pass


func test_create_spy_static_func_untyped():
	var instance = spy(ClassWithStaticFunctions.new())
	assert_object(instance).is_not_null()


func test_spy_snake_case_named_class_by_resource_path():
	var instance_a = load("res://addons/gdUnit4/test/mocker/resources/snake_case.gd").new()
	var spy_a = spy(instance_a)
	assert_object(spy_a).is_not_null()
	
	spy_a.custom_func()
	verify(spy_a).custom_func()
	verify_no_more_interactions(spy_a)
	
	var instance_b = load("res://addons/gdUnit4/test/mocker/resources/snake_case_class_name.gd").new()
	var spy_b = spy(instance_b)
	assert_object(spy_b).is_not_null()
	
	spy_b.custom_func()
	verify(spy_b).custom_func()
	verify_no_more_interactions(spy_b)


func test_spy_snake_case_named_class_by_class():
	var do_spy = spy(snake_case_class_name.new())
	assert_object(do_spy).is_not_null()
	
	do_spy.custom_func()
	verify(do_spy).custom_func()
	verify_no_more_interactions(do_spy)
	
	# try checked Godot class
	var spy_tcp_server = spy(TCPServer.new())
	assert_object(spy_tcp_server).is_not_null()
	
	spy_tcp_server.is_listening()
	spy_tcp_server.is_connection_available()
	verify(spy_tcp_server).is_listening()
	verify(spy_tcp_server).is_connection_available()
	verify_no_more_interactions(spy_tcp_server)


const Issue = preload("res://addons/gdUnit4/test/resources/issues/gd-166/issue.gd")
const Type = preload("res://addons/gdUnit4/test/resources/issues/gd-166/types.gd")


func test_spy_preload_class_GD_166() -> void:
	var instance = auto_free(Issue.new())
	var spy_instance = spy(instance)
	
	spy_instance.type = Type.FOO
	verify(spy_instance, 1)._set_type_name(Type.FOO)
	assert_int(spy_instance.type).is_equal(Type.FOO)
	assert_str(spy_instance.type_name).is_equal("FOO")


var _test_signal_args := Array()
func _emit_ready(a, b, c = null):
	_test_signal_args = [a, b, c]


# https://github.com/MikeSchulze/gdUnit4/issues/38
func test_spy_Node_use_real_func_vararg():
	# setup
	var instance := Node.new()
	instance.connect("ready", _emit_ready)
	assert_that(_test_signal_args).is_empty()
	var spy_node = spy(auto_free(instance))
	assert_that(spy_node).is_not_null()
	
	# test emit it
	spy_node.emit_signal("ready", "aa", "bb", "cc")
	# verify is emitted
	verify(spy_node).emit_signal("ready", "aa", "bb", "cc")
	await get_tree().process_frame
	assert_that(_test_signal_args).is_equal(["aa", "bb", "cc"])
	
	# test emit it
	spy_node.emit_signal("ready", "aa", "xxx")
	# verify is emitted
	verify(spy_node).emit_signal("ready", "aa", "xxx")
	await get_tree().process_frame
	assert_that(_test_signal_args).is_equal(["aa", "xxx", null])


class ClassWithSignal:
	signal test_signal_a
	signal test_signal_b
	
	func foo(arg :int) -> void:
		if arg == 0:
			emit_signal("test_signal_a", "aa")
		else:
			emit_signal("test_signal_b", "bb", true)
	
	func bar(arg :int) -> bool:
		if arg == 0:
			emit_signal("test_signal_a", "aa")
		else:
			emit_signal("test_signal_b", "bb", true)
		return true


# https://github.com/MikeSchulze/gdUnit4/issues/14
func _test_spy_verify_emit_signal():
	var spy_instance = spy(ClassWithSignal.new())
	assert_that(spy_instance).is_not_null()
	
	spy_instance.foo(0)
	verify(spy_instance, 1).emit_signal("test_signal_a", "aa")
	verify(spy_instance, 0).emit_signal("test_signal_b", "bb", true)
	reset(spy_instance)
	
	spy_instance.foo(1)
	verify(spy_instance, 0).emit_signal("test_signal_a", "aa")
	verify(spy_instance, 1).emit_signal("test_signal_b", "bb", true)
	reset(spy_instance)
	
	spy_instance.bar(0)
	verify(spy_instance, 1).emit_signal("test_signal_a", "aa")
	verify(spy_instance, 0).emit_signal("test_signal_b", "bb", true)
	reset(spy_instance)
	
	spy_instance.bar(1)
	verify(spy_instance, 0).emit_signal("test_signal_a", "aa")
	verify(spy_instance, 1).emit_signal("test_signal_b", "bb", true)


func test_spy_func_with_default_build_in_type():
	var spy_instance :ClassWithDefaultBuildIntTypes = spy(ClassWithDefaultBuildIntTypes.new())
	assert_object(spy_instance).is_not_null()
	# call with default arg
	spy_instance.foo("abc")
	spy_instance.bar("def")
	verify(spy_instance).foo("abc", Color.RED)
	verify(spy_instance).bar("def", Vector3.FORWARD, AABB())
	verify_no_more_interactions(spy_instance)
	
	# call with custom args
	spy_instance.foo("abc", Color.BLUE)
	spy_instance.bar("def", Vector3.DOWN, AABB(Vector3.ONE, Vector3.ZERO))
	verify(spy_instance).foo("abc", Color.BLUE)
	verify(spy_instance).bar("def", Vector3.DOWN, AABB(Vector3.ONE, Vector3.ZERO))
	verify_no_more_interactions(spy_instance)


func test_spy_scene_by_resource_path():
	var spy_scene = spy("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	assert_object(spy_scene)\
		.is_not_null()\
		.is_not_instanceof(PackedScene)\
		.is_instanceof(Control)
	assert_str(spy_scene.get_script().resource_name).is_equal("SpyTestScene.gd")
	# check is spyed scene registered for auto freeing
	assert_bool(GdUnitMemoryObserver.is_marked_auto_free(spy_scene)).is_true()


func test_spy_on_PackedScene():
	var resource := load("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	var original_script = resource.get_script()
	assert_object(resource).is_instanceof(PackedScene)
	
	var spy_scene = spy(resource)
	
	assert_object(spy_scene)\
		.is_not_null()\
		.is_not_instanceof(PackedScene)\
		.is_not_same(resource)
	assert_object(spy_scene.get_script())\
		.is_not_null()\
		.is_instanceof(GDScript)\
		.is_not_same(original_script)
	assert_str(spy_scene.get_script().resource_name).is_equal("SpyTestScene.gd")
	# check is spyed scene registered for auto freeing
	assert_bool(GdUnitMemoryObserver.is_marked_auto_free(spy_scene)).is_true()


func test_spy_scene_by_instance():
	var resource := load("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	var instance :Control = resource.instantiate()
	var original_script = instance.get_script()
	var spy_scene = spy(instance)
	
	assert_object(spy_scene)\
		.is_not_null()\
		.is_same(instance)\
		.is_instanceof(Control)
	assert_object(spy_scene.get_script())\
		.is_not_null()\
		.is_instanceof(GDScript)\
		.is_not_same(original_script)
	assert_str(spy_scene.get_script().resource_name).is_equal("SpyTestScene.gd")
	# check is mocked scene registered for auto freeing
	assert_bool(GdUnitMemoryObserver.is_marked_auto_free(spy_scene)).is_true()


func test_spy_scene_by_path_fail_has_no_script_attached():
	var resource := load("res://addons/gdUnit4/test/mocker/resources/scenes/TestSceneWithoutScript.tscn")
	var instance :Control = auto_free(resource.instantiate())
	
	# has to fail and return null
	var spy_scene = spy(instance)
	assert_object(spy_scene).is_null()


func test_spy_scene_initalize():
	var spy_scene = spy("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	assert_object(spy_scene).is_not_null()
	
	# Add as child to a scene tree to trigger _ready to initalize all variables
	add_child(spy_scene)
	# ensure _ready is recoreded and onyl once called
	verify(spy_scene, 1)._ready()
	verify(spy_scene, 1).only_one_time_call()
	assert_object(spy_scene._box1).is_not_null()
	assert_object(spy_scene._box2).is_not_null()
	assert_object(spy_scene._box3).is_not_null()
	
	# check signals are connected
	assert_bool(spy_scene.is_connected("panel_color_change",Callable(spy_scene,"_on_panel_color_changed")))
	
	# check exports
	assert_str(spy_scene._initial_color.to_html()).is_equal(Color.RED.to_html())


class CustomNode extends Node:
	
	func _ready():
		# we call this function to verify the _ready is only once called
		# this is need to verify `add_child` is calling the original implementation only once
		only_one_time_call()
	
	func only_one_time_call() -> void:
		pass


func test_spy_ready_called_once():
	var spy_node = spy(auto_free(CustomNode.new()))
	
	# Add as child to a scene tree to trigger _ready to initalize all variables
	add_child(spy_node)
	
	# ensure _ready is recoreded and onyl once called
	verify(spy_node, 1)._ready()
	verify(spy_node, 1).only_one_time_call()
