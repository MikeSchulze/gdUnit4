class_name GdUnitMockerTest
extends GdUnitTestSuite

var resource_path := "res://addons/gdUnit4/test/mocker/resources/"

func before():
	# disable error pushing for testing
	GdUnitMockBuilder.do_push_errors(false)

func after():
	GdUnitMockBuilder.do_push_errors(true)

# small helper to verify last assert error
func assert_last_error(expected :String):
	var gd_assert := GdUnitAssertImpl.new(self, "")
	if Engine.has_meta(GdAssertReports.LAST_ERROR):
		gd_assert._current_error_message = Engine.get_meta(GdAssertReports.LAST_ERROR)
	gd_assert.has_failure_message(expected)

func test_is_mockable_godot_classes():
	# verify enigne classes
	for clazz_name in ClassDB.get_class_list():
		# mocking is not allowed for:
		# singleton classes
		# unregistered classes in ClassDB
		# protected classes (name starts with underscore)
		var is_mockable :bool = not Engine.has_singleton(clazz_name) and ClassDB.can_instantiate(clazz_name) and clazz_name.find("_") != 0
		assert_that(GdUnitMockBuilder.is_mockable(clazz_name)) \
			.override_failure_message("Class '%s' expect mockable %s" % [clazz_name, is_mockable]) \
			.is_equal(is_mockable)

func test_is_mockable_by_class_type():
	assert_that(GdUnitMockBuilder.is_mockable(Node)).is_true()
	assert_that(GdUnitMockBuilder.is_mockable(CSGBox3D)).is_true()

func test_is_mockable_custom_class_type():
	assert_that(GdUnitMockBuilder.is_mockable(CustomResourceTestClass)).is_true()
	assert_that(GdUnitMockBuilder.is_mockable(CustomNodeTestClass)).is_true()

func test_is_mockable_by_script_path():
	assert_that(GdUnitMockBuilder.is_mockable(resource_path + "CustomResourceTestClass.gd")).is_true()
	assert_that(GdUnitMockBuilder.is_mockable(resource_path + "CustomNodeTestClass.gd")).is_true()
	# verify for non scripts
	assert_that(GdUnitMockBuilder.is_mockable(resource_path + "capsuleshape2d.tres")).is_false()

func test_is_mockable__overriden_func_get_class():
	# test with class type
	assert_that(GdUnitMockBuilder.is_mockable(OverridenGetClassTestClass))\
		.override_failure_message("The class 'CustomResourceTestClass' should be mockable when 'func get_class()' is overriden")\
		.is_true()
	# test with resource path
	assert_that(GdUnitMockBuilder.is_mockable(resource_path + "OverridenGetClassTestClass.gd"))\
		.override_failure_message("The class 'CustomResourceTestClass' should be mockable when 'func get_class()' is overriden")\
		.is_true()

func test_mock_godot_class_fullcheck(fuzzer=GodotClassNameFuzzer.new(), fuzzer_iterations=200):
	var clazz_name = fuzzer.next_value()
	# try to create a mock
	if GdUnitMockBuilder.is_mockable(clazz_name):
		var mock = mock(clazz_name, CALL_REAL_FUNC)
		assert_that(mock)\
			.override_failure_message("The class %s should be mockable" % clazz_name)\
			.is_not_null()

func test_mock_by_script_path():
	assert_that(mock(resource_path + "CustomResourceTestClass.gd")).is_not_null()
	assert_that(mock(resource_path + "CustomNodeTestClass.gd")).is_not_null()

func test_mock_class__overriden_func_get_class():
	assert_that(mock(OverridenGetClassTestClass)).is_not_null()
	assert_that(mock(resource_path + "OverridenGetClassTestClass.gd")).is_not_null()

func test_mock_fail():
	# not godot class
	assert_that(mock("CustomResourceTestClass")).is_null()
	# invalid path to script
	assert_that(mock("invalid/CustomResourceTestClass.gd")).is_null()
	# try to mocking an existing instance is not allowed
	assert_that(mock(CustomResourceTestClass.new())).is_null()

func test_mock_special_classes():
	var mock = mock("JavaClass") as JavaClass
	assert_that(mock).is_not_null()

func test_mock_Node():
	var mocked_node = mock(Node)
	assert_that(mocked_node).is_not_null()
	
	# test we have initial no interactions checked this mock
	verify_no_interactions(mocked_node)
	
	# verify we have never called 'get_child_count()'
	verify(mocked_node, 0).get_child_count()
	
	# call 'get_child_count()' once 
	mocked_node.get_child_count()
	# verify we have called at once
	verify(mocked_node).get_child_count()
	
	# call function 'get_child_count' a second time 
	mocked_node.get_child_count()
	# verify we have called at twice
	verify(mocked_node, 2).get_child_count()
	
	# test mocked function returns default typed value
	assert_that(mocked_node.get_child_count()).is_equal(0)
	# now mock return value for function 'foo' to 'overwriten value'
	do_return(24).checked(mocked_node).get_child_count()
	# verify the return value is overwritten
	assert_that(mocked_node.get_child_count()).is_equal(24)

func test_mock_source_with_class_name_by_resource_path() -> void:
	var resource_path := 'res://addons/gdUnit4/test/mocker/resources/GD-256/world.gd'
	var m = mock(resource_path)
	var head :String = m.get_script().source_code.substr(0, 200)
	assert_str(head)\
		.contains("class_name DoubledMunderwoodPathingWorld")\
		.contains("extends '%s'" % resource_path)

func test_mock_source_with_class_name_by_class() -> void:
	var resource_path := 'res://addons/gdUnit4/test/mocker/resources/GD-256/world.gd'
	var m = mock(Munderwood_Pathing_World)
	var head :String = m.get_script().source_code.substr(0, 200)
	assert_str(head)\
		.contains("class_name DoubledMunderwoodPathingWorld")\
		.contains("extends '%s'" % resource_path)

func test_mock_extends_godot_class() -> void:
	var m = mock(World3D)
	var head :String = m.get_script().source_code.substr(0, 200)
	assert_str(head)\
		.contains("class_name DoubledWorld")\
		.contains("extends World3D")

var _test_signal_is_emited := false
func _emit_ready(a, b, c):
	prints("_emit_ready", a, b, c)
	_test_signal_is_emited = true

func test_mock_Node_use_real_func_vararg():
	var mocked_node = mock(Node, CALL_REAL_FUNC)
	assert_that(mocked_node).is_not_null()
	
	assert_bool(_test_signal_is_emited).is_false()
	var err := mocked_node.connect("ready", Callable(self, "_emit_ready"))
	prints(error_as_string(err))
	err = mocked_node.emit_signal("ready", "aa", "bb", "cc")
	prints(error_as_string(err))
	
	# sync signal is emited
	await get_tree().process_frame
	assert_bool(_test_signal_is_emited).is_true()

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

func _test_mock_verify_emit_signal():
	var mocked_node = mock(ClassWithSignal, CALL_REAL_FUNC)
	assert_that(mocked_node).is_not_null()
	
	mocked_node.foo(0)
	verify(mocked_node, 1).emit_signal("test_signal_a", "aa")
	verify(mocked_node, 0).emit_signal("test_signal_b", "bb", true)
	reset(mocked_node)

	mocked_node.foo(1)
	verify(mocked_node, 0).emit_signal("test_signal_a", "aa")
	verify(mocked_node, 1).emit_signal("test_signal_b", "bb", true)
	reset(mocked_node)
	
	mocked_node.bar(0)
	verify(mocked_node, 1).emit_signal("test_signal_a", "aa")
	verify(mocked_node, 0).emit_signal("test_signal_b", "bb", true)
	reset(mocked_node)
	
	mocked_node.bar(1)
	verify(mocked_node, 0).emit_signal("test_signal_a", "aa")
	verify(mocked_node, 1).emit_signal("test_signal_b", "bb", true)

func test_mock_custom_class_by_class_name():
	var mock = mock(CustomResourceTestClass)
	assert_that(mock).is_not_null()
	
	# test we have initial no interactions checked this mock
	verify_no_interactions(mock)
	# test mocked function returns default typed value
	assert_that(mock.foo()).is_equal("")
	
	# now mock return value for function 'foo' to 'overwriten value'
	do_return("overriden value").checked(mock).foo()
	# verify the return value is overwritten
	assert_that(mock.foo()).is_equal("overriden value")
	
	# now mock return values by custom arguments
	do_return("arg_1").checked(mock).bar(1)
	do_return("arg_2").checked(mock).bar(2)
	
	assert_that(mock.bar(1)).is_equal("arg_1")
	assert_that(mock.bar(2)).is_equal("arg_2")

func test_mock_custom_class_by_resource_path():
	var mock = mock("res://addons/gdUnit4/test/mocker/resources/CustomResourceTestClass.gd")
	assert_that(mock).is_not_null()
	
	# test we have initial no interactions checked this mock
	verify_no_interactions(mock)
	# test mocked function returns default typed value
	assert_that(mock.foo()).is_equal("")
	
	# now mock return value for function 'foo' to 'overwriten value'
	do_return("overriden value").checked(mock).foo()
	# verify the return value is overwritten
	assert_that(mock.foo()).is_equal("overriden value")
	
	# now mock return values by custom arguments
	do_return("arg_1").checked(mock).bar(1)
	do_return("arg_2").checked(mock).bar(2)
	
	assert_that(mock.bar(1)).is_equal("arg_1")
	assert_that(mock.bar(2)).is_equal("arg_2")


func test_mock_custom_class_func_foo_use_real_func():
	var mock = mock(CustomResourceTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	# test mocked function returns value from real function
	assert_that(mock.foo()).is_equal("foo")
	# now mock return value for function 'foo' to 'overwriten value'
	do_return("overridden value").checked(mock).foo()
	# verify the return value is overwritten
	assert_that(mock.foo()).is_equal("overridden value")


func test_mock_custom_class_void_func():
	var mock = mock(CustomResourceTestClass)
	assert_that(mock).is_not_null()
	# test mocked void function returns null by default
	assert_that(mock.foo_void()).is_null()
	# try now mock return value for a void function. results into an error
	do_return("overridden value").checked(mock).foo_void()
	# verify it has no affect for void func
	assert_that(mock.foo_void()).is_null()

func test_mock_custom_class_void_func_real_func():
	var mock = mock(CustomResourceTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	# test mocked void function returns null by default
	assert_that(mock.foo_void()).is_null()
	# try now mock return value for a void function. results into an error
	do_return("overridden value").checked(mock).foo_void()
	# verify it has no affect for void func
	assert_that(mock.foo_void()).is_null()

func test_mock_custom_class_func_foo_call_times():
	var mock = mock(CustomResourceTestClass)
	assert_that(mock).is_not_null()
	verify(mock, 0).foo()
	mock.foo()
	verify(mock, 1).foo()
	mock.foo()
	verify(mock, 2).foo()
	mock.foo()
	mock.foo()
	verify(mock, 4).foo()

func test_mock_custom_class_func_foo_call_times_real_func():
	var mock = mock(CustomResourceTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	verify(mock, 0).foo()
	mock.foo()
	verify(mock, 1).foo()
	mock.foo()
	verify(mock, 2).foo()
	mock.foo()
	mock.foo()
	verify(mock, 4).foo()

func test_mock_custom_class_func_foo_full_test():
	var mock = mock(CustomResourceTestClass)
	assert_that(mock).is_not_null()
	verify(mock, 0).foo()
	assert_that(mock.foo()).is_equal("")
	verify(mock, 1).foo()
	do_return("new value").checked(mock).foo()
	verify(mock, 1).foo()
	assert_that(mock.foo()).is_equal("new value")
	verify(mock, 2).foo()

func test_mock_custom_class_func_foo_full_test_real_func():
	var mock = mock(CustomResourceTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	verify(mock, 0).foo()
	assert_that(mock.foo()).is_equal("foo")
	verify(mock, 1).foo()
	do_return("new value").checked(mock).foo()
	verify(mock, 1).foo()
	assert_that(mock.foo()).is_equal("new value")
	verify(mock, 2).foo()

func test_mock_custom_class_func_bar():
	var mock = mock(CustomResourceTestClass)
	assert_that(mock).is_not_null()
	assert_that(mock.bar(10)).is_equal("")
	# verify 'bar' with args [10] is called one time at this point
	verify(mock, 1).bar(10)
	# verify 'bar' with args [10, 20] is never called at this point
	verify(mock, 0).bar(10, 29)
	# verify 'bar' with args [23] is never called at this point
	verify(mock, 0).bar(23)

	# now mock return value for function 'bar' with args [10] to 'overwriten value'
	do_return("overridden value").checked(mock).bar(10)
	# verify the return value is overwritten
	assert_that(mock.bar(10)).is_equal("overridden value")
	# finally verify function call times
	verify(mock, 2).bar(10)
	verify(mock, 0).bar(10, 29)
	verify(mock, 0).bar(23)

func test_mock_custom_class_func_bar_real_func():
	var mock = mock(CustomResourceTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	assert_that(mock.bar(10)).is_equal("test_33")
	# verify 'bar' with args [10] is called one time at this point
	verify(mock, 1).bar(10)
	# verify 'bar' with args [10, 20] is never called at this point
	verify(mock, 0).bar(10, 29)
	# verify 'bar' with args [23] is never called at this point
	verify(mock, 0).bar(23)

	# now mock return value for function 'bar' with args [10] to 'overwriten value'
	do_return("overridden value").checked(mock).bar(10)
	# verify the return value is overwritten
	assert_that(mock.bar(10)).is_equal("overridden value")
	# verify the real implementation is used
	assert_that(mock.bar(10, 29)).is_equal("test_39")
	assert_that(mock.bar(10, 20, "other")).is_equal("other_30")
	# finally verify function call times
	verify(mock, 2).bar(10)
	verify(mock, 1).bar(10, 29)
	verify(mock, 0).bar(10, 20)
	verify(mock, 1).bar(10, 20, "other")

func test_mock_custom_class_extends_Node():
	var mock = mock(CustomNodeTestClass)
	assert_that(mock).is_not_null()
	
	# test mocked function returns null as default
	assert_that(mock.get_child_count()).is_equal(0)
	assert_that(mock.get_children()).contains_exactly([])
	# test seters has no affect
	var node = auto_free(Node.new())
	mock.add_child(node)
	assert_that(mock.get_child_count()).is_equal(0)
	assert_that(mock.get_children()).contains_exactly([])
	verify(mock, 1).add_child(node)
	verify(mock, 2).get_child_count()
	verify(mock, 2).get_children()

func test_mock_custom_class_extends_Node_real_func():
	var mock = mock(CustomNodeTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	# test mocked function returns default mock value
	assert_that(mock.get_child_count()).is_equal(0)
	assert_that(mock.get_children()).is_equal([])
	# test real seters used
	var nodeA = auto_free(Node.new())
	var nodeB = auto_free(Node.new())
	var nodeC = auto_free(Node.new())
	mock.add_child(nodeA)
	mock.add_child(nodeB)
	assert_that(mock.get_child_count()).is_equal(2)
	assert_that(mock.get_children()).contains_exactly([nodeA, nodeB])
	verify(mock, 1).add_child(nodeA)
	verify(mock, 1).add_child(nodeB)
	verify(mock, 0).add_child(nodeC)
	verify(mock, 2).get_child_count()
	verify(mock, 2).get_children()

func test_mock_custom_class_extends_other_custom_class():
	var mock = mock(CustomClassExtendsCustomClass)
	assert_that(mock).is_not_null()
	
	# foo() form parent class
	verify(mock, 0).foo()
	# foo2() overriden 
	verify(mock, 0).foo2()
	# bar2() from class 
	verify(mock, 0).bar2()
	
	assert_that(mock.foo()).is_empty()
	assert_that(mock.foo2()).is_null()
	assert_that(mock.bar2()).is_empty()
	
	verify(mock, 1).foo()
	verify(mock, 1).foo2()
	verify(mock, 1).bar2()
	
	# override returns
	do_return("abc1").checked(mock).foo()
	do_return("abc2").checked(mock).foo2()
	do_return("abc3").checked(mock).bar2()
	
	assert_that(mock.foo()).is_equal("abc1")
	assert_that(mock.foo2()).is_equal("abc2")
	assert_that(mock.bar2()).is_equal("abc3")

func test_mock_custom_class_extends_other_custom_class_call_real_func():
	var mock = mock(CustomClassExtendsCustomClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	
	# foo() form parent class
	verify(mock, 0).foo()
	# foo2() overriden 
	verify(mock, 0).foo2()
	# bar2() from class 
	verify(mock, 0).bar2()
	
	assert_that(mock.foo()).is_equal("foo")
	assert_that(mock.foo2()).is_equal("foo2 overriden")
	assert_that(mock.bar2()).is_equal("test_65")
	
	verify(mock, 1).foo()
	verify(mock, 1).foo2()
	verify(mock, 1).bar2()
	
	# override returns
	do_return("abc1").checked(mock).foo()
	do_return("abc2").checked(mock).foo2()
	do_return("abc3").checked(mock).bar2()
	
	assert_that(mock.foo()).is_equal("abc1")
	assert_that(mock.foo2()).is_equal("abc2")
	assert_that(mock.bar2()).is_equal("abc3")

func test_mock_static_func():
	var mock = mock(CustomNodeTestClass)
	assert_that(mock).is_not_null()
	# initial not called
	verify(mock, 0).static_test()
	verify(mock, 0).static_test_void()

	assert_that(mock.static_test()).is_equal("")
	assert_that(mock.static_test_void()).is_null()

	verify(mock, 1).static_test()
	verify(mock, 1).static_test_void()
	mock.static_test()
	mock.static_test_void()
	mock.static_test_void()
	verify(mock, 2).static_test()
	verify(mock, 3).static_test_void()

func test_mock_static_func_real_func():
	var mock = mock(CustomNodeTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	# initial not called
	verify(mock, 0).static_test()
	verify(mock, 0).static_test_void()

	assert_that(mock.static_test()).is_equal(CustomNodeTestClass.STATIC_FUNC_RETURN_VALUE)
	assert_that(mock.static_test_void()).is_null()

	verify(mock, 1).static_test()
	verify(mock, 1).static_test_void()
	mock.static_test()
	mock.static_test_void()
	mock.static_test_void()
	verify(mock, 2).static_test()
	verify(mock, 3).static_test_void()

func _test_mock_mode_deep_stub():
	var mocked_shape = mock(DeepStubTestClass.XShape)
	#var t := DeepStubTestClass.new()
	#t.add(mocked_shape)
	#assert_bool(t.validate()).is_true()

func test_mock_custom_class_assert_has_no_side_affect():
	var mock = mock(CustomNodeTestClass)
	assert_that(mock).is_not_null()
	var node = Node.new()
	# verify the assertions has no side affect checked mocked object
	verify(mock, 0).add_child(node)
	# expect no change checked childrens
	assert_that(mock.get_children()).contains_exactly([])

	mock.add_child(node)
	# try thre times 'assert_called' to see it has no affect to the mock
	verify(mock, 1).add_child(node)
	verify(mock, 1).add_child(node)
	verify(mock, 1).add_child(node)
	assert_that(mock.get_children()).contains_exactly([])
	# needs to be manually freed
	node.free()

func test_mock_custom_class_assert_has_no_side_affect_real_func():
	var mock = mock(CustomNodeTestClass, CALL_REAL_FUNC)
	assert_that(mock).is_not_null()
	var node = Node.new()
	# verify the assertions has no side affect checked mocked object
	verify(mock, 0).add_child(node)
	# expect no change checked childrens
	assert_that(mock.get_children()).contains_exactly([])

	mock.add_child(node)
	# try thre times 'assert_called' to see it has no affect to the mock
	verify(mock, 1).add_child(node)
	verify(mock, 1).add_child(node)
	verify(mock, 1).add_child(node)
	assert_that(mock.get_children()).contains_exactly([node])

# This test verifies a function is calling other internally functions
# to collect the access times and the override return value is working as expected
func test_mock_advanced_func_path():
	var mock = mock(AdvancedTestClass, CALL_REAL_FUNC)
	# initial nothing is called
	verify(mock, 0).select(AdvancedTestClass.A)
	verify(mock, 0).select(AdvancedTestClass.B)
	verify(mock, 0).select(AdvancedTestClass.C)
	verify(mock, 0).a()
	verify(mock, 0).b()
	verify(mock, 0).c()
	
	# the function select() swiches based checked input argument to function a(), b() or c()
	# call select where called internally func a() and returned "a"
	assert_that(mock.select(AdvancedTestClass.A)).is_equal("a")
	# verify when call select() is also calling original func a()
	verify(mock, 1).select(AdvancedTestClass.A)
	verify(mock, 1).a()
	
	# call select again wiht overriden return value for func a()
	do_return("overridden a func").checked(mock).a()
	assert_that(mock.select(AdvancedTestClass.A)).is_equal("overridden a func")
	
	# verify at this time select() and a() is called two times
	verify(mock, 2).select(AdvancedTestClass.A)
	verify(mock, 0).select(AdvancedTestClass.B)
	verify(mock, 0).select(AdvancedTestClass.C)
	verify(mock, 2).a()
	verify(mock, 0).b()
	verify(mock, 0).c()
	
	# finally use select to switch to internally func c()
	assert_that(mock.select(AdvancedTestClass.C)).is_equal("c")
	verify(mock, 2).select(AdvancedTestClass.A)
	verify(mock, 0).select(AdvancedTestClass.B)
	verify(mock, 1).select(AdvancedTestClass.C)
	verify(mock, 2).a()
	verify(mock, 0).b()
	verify(mock, 1).c()

func _test_mock_godot_class_calls_sub_function():
	var mock = mock(MeshInstance3D, CALL_REAL_FUNC)
	verify(mock, 0)._mesh_changed()
	mock.set_mesh(QuadMesh.new())
	verify(mock, 1).set_mesh(any_class(Mesh))
	verify(mock, 1)._mesh_changed()

func test_mock_class_with_inner_classs():
	var mock_advanced = mock(AdvancedTestClass)
	assert_that(mock_advanced).is_not_null()

	var mock_a := mock(AdvancedTestClass.SoundData) as AdvancedTestClass.SoundData
	assert_object(mock_a).is_not_null()

	var mock_b := mock(AdvancedTestClass.AtmosphereData) as AdvancedTestClass.AtmosphereData
	assert_object(mock_b).is_not_null()
	
	var mock_c := mock(AdvancedTestClass.Area4D) as AdvancedTestClass.Area4D
	assert_object(mock_c).is_not_null()

func test_example_do_return():
	var mocked_node = mock(Node)

	# is return 0 by default
	mocked_node.get_child_count()
	# configure to return 10 when 'get_child_count()' is called
	do_return(10).checked(mocked_node).get_child_count()
	# will now return 10
	mocked_node.get_child_count()
	
	# is return 'null' by default
	var node = mocked_node.get_child(0)
	assert_object(node).is_null()
	
	# configure to return a mocked 'Camera3D' for child 0
	do_return(mock(Camera3D)).checked(mocked_node).get_child(0)
	# configure to return a mocked 'Area3D' for child 1
	do_return(mock(Area3D)).checked(mocked_node).get_child(1)
	
	# will now return the Camera3D node
	var node0 = mocked_node.get_child(0)
	assert_object(node0).is_instanceof(Camera3D)
	# will now return the Area3D node
	var node1 = mocked_node.get_child(1)
	assert_object(node1).is_instanceof(Area3D)

func test_example_verify():
	var mocked_node = mock(Node)
	
	# verify we have no interactions currently checked this instance
	verify_no_interactions(mocked_node)
	
	# call with different arguments
	mocked_node.set_process(false) # 1 times
	mocked_node.set_process(true) # 1 times
	mocked_node.set_process(true) # 2 times
	
	# verify how often we called the function with different argument 
	verify(mocked_node, 2).set_process(true) # in sum two times with true
	verify(mocked_node, 1).set_process(false)# in sum one time with false

	# verify total sum by using an argument matcher 
	verify(mocked_node, 3).set_process(any_bool())

func test_verify_fail():
	var mocked_node = mock(Node)
	
	# interact two time
	mocked_node.set_process(true) # 1 times
	mocked_node.set_process(true) # 2 times
	
	# verify we interacts two times
	verify(mocked_node, 2).set_process(true)
	
	# verify should fail because we interacts two times and not one
	verify(mocked_node, 1, GdUnitAssert.EXPECT_FAIL).set_process(true)
	var expected_error := """Expecting interacion checked:
	'set_process(true :bool)'	1 time's
But found interactions checked:
	'set_process(true :bool)'	2 time's"""
	expected_error = GdScriptParser.to_unix_format(expected_error)
	assert_last_error(expected_error)

func test_verify_func_interaction_wiht_PoolStringArray():
	var mocked = mock(ClassWithPoolStringArrayFunc)
	
	mocked.set_values(PackedStringArray())
	
	verify(mocked).set_values(PackedStringArray())
	verify_no_more_interactions(mocked)

func test_verify_func_interaction_wiht_PoolStringArray_fail():
	var mocked = mock(ClassWithPoolStringArrayFunc)
	
	mocked.set_values(PackedStringArray())
	
	# try to verify with default array type instead of PackedStringArray type
	verify(mocked, 1, GdUnitAssert.EXPECT_FAIL).set_values([])
	var expected_error := """Expecting interacion checked:
	'set_values([] :Array)'	1 time's
But found interactions checked:
	'set_values([] :PackedStringArray)'	1 time's"""
	expected_error = GdScriptParser.to_unix_format(expected_error)
	assert_last_error(expected_error)
	
	reset(mocked)
	# try again with called two times and different args
	mocked.set_values(PackedStringArray())
	mocked.set_values(PackedStringArray(["a", "b"]))
	mocked.set_values([1, 2])
	verify(mocked, 1, GdUnitAssert.EXPECT_FAIL).set_values([])
	expected_error = """Expecting interacion checked:
	'set_values([] :Array)'	1 time's
But found interactions checked:
	'set_values([] :PackedStringArray)'	1 time's
	'set_values(["a", "b"] :PackedStringArray)'	1 time's
	'set_values([1, 2] :Array)'	1 time's"""
	expected_error = GdScriptParser.to_unix_format(expected_error)
	assert_last_error(expected_error)

func test_reset():
	var mocked_node = mock(Node)
	
	# call with different arguments
	mocked_node.set_process(false) # 1 times
	mocked_node.set_process(true) # 1 times
	mocked_node.set_process(true) # 2 times
	
	verify(mocked_node, 2).set_process(true)
	verify(mocked_node, 1).set_process(false)
	
	# now reset the mock
	reset(mocked_node)
	# verify all counters have been reset
	verify_no_interactions(mocked_node)

func test_verify_no_interactions():
	var mocked_node = mock(Node)
	
	# verify we have no interactions checked this mock
	verify_no_interactions(mocked_node)

func test_verify_no_interactions_fails():
	var mocked_node = mock(Node)
	
	# interact
	mocked_node.set_process(false) # 1 times
	mocked_node.set_process(true) # 1 times
	mocked_node.set_process(true) # 2 times
	
	var expected_error ="""Expecting no more interacions!
But found interactions checked:
	'set_process(false :bool)'	1 time's
	'set_process(true :bool)'	2 time's"""
	expected_error = GdScriptParser.to_unix_format(expected_error)
	# it should fail because we have interactions 
	verify_no_interactions(mocked_node, GdUnitAssert.EXPECT_FAIL)\
		.has_failure_message(expected_error)

func test_verify_no_more_interactions():
	var mocked_node = mock(Node)
	
	mocked_node.is_ancestor_of(null)
	mocked_node.set_process(false)
	mocked_node.set_process(true)
	mocked_node.set_process(true)
	
	# verify for called functions
	verify(mocked_node, 1).is_ancestor_of(null)
	verify(mocked_node, 2).set_process(true)
	verify(mocked_node, 1).set_process(false)
	
	# There should be no more interactions checked this mock
	verify_no_more_interactions(mocked_node)

func test_verify_no_more_interactions_but_has():
	var mocked_node = mock(Node)
	
	mocked_node.is_ancestor_of(null)
	mocked_node.set_process(false)
	mocked_node.set_process(true)
	mocked_node.set_process(true)
	
	# now we simulate extra calls that we are not explicit verify
	mocked_node.is_inside_tree()
	mocked_node.is_inside_tree()
	# a function with default agrs
	mocked_node.find_child("mask")
	# same function again with custom agrs
	mocked_node.find_child("mask", false, false)
	
	# verify 'all' exclusive the 'extra calls' functions
	verify(mocked_node, 1).is_ancestor_of(null)
	verify(mocked_node, 2).set_process(true)
	verify(mocked_node, 1).set_process(false)
	
	# now use 'verify_no_more_interactions' to check we have no more interactions checked this mock
	# but should fail with a collecion of all not validated interactions
	var expected_error ="""Expecting no more interacions!
But found interactions checked:
	'is_inside_tree()'	2 time's
	'find_child(mask :String, true :bool, true :bool)'	1 time's
	'find_child(mask :String, false :bool, false :bool)'	1 time's"""
	expected_error = GdScriptParser.to_unix_format(expected_error)
	verify_no_more_interactions(mocked_node, GdUnitAssert.EXPECT_FAIL)\
		.has_failure_message(expected_error)

func test_mock_snake_case_named_class_by_resource_path():
	var mock_a = mock("res://addons/gdUnit4/test/mocker/resources/snake_case.gd")
	assert_object(mock_a).is_not_null()
	
	mock_a._ready()
	verify(mock_a)._ready()
	verify_no_more_interactions(mock_a)
	
	var mock_b = mock("res://addons/gdUnit4/test/mocker/resources/snake_case_class_name.gd")
	assert_object(mock_b).is_not_null()
	
	mock_b._ready()
	verify(mock_b)._ready()
	verify_no_more_interactions(mock_b)
	
func test_mock_snake_case_named_godot_class_by_name():
	# try checked Godot class
	var mocked_tcp_server = mock("TCPServer")
	assert_object(mocked_tcp_server).is_not_null()
	
	mocked_tcp_server.is_listening()
	mocked_tcp_server.is_connection_available()
	verify(mocked_tcp_server).is_listening()
	verify(mocked_tcp_server).is_connection_available()
	verify_no_more_interactions(mocked_tcp_server)

func test_mock_snake_case_named_class_by_class():
	var mock = mock(snake_case_class_name)
	assert_object(mock).is_not_null()
	
	mock._ready()
	verify(mock)._ready()
	verify_no_more_interactions(mock)
	
	# try checked Godot class
	var mocked_tcp_server = mock(TCPServer)
	assert_object(mocked_tcp_server).is_not_null()
	
	mocked_tcp_server.is_listening()
	mocked_tcp_server.is_connection_available()
	verify(mocked_tcp_server).is_listening()
	verify(mocked_tcp_server).is_connection_available()
	verify_no_more_interactions(mocked_tcp_server)

func test_mock_func_with_default_build_in_type():
	var mock = mock(ClassWithDefaultBuildIntTypes)
	assert_object(mock).is_not_null()
	# call with default arg
	mock.foo("abc")
	mock.bar("def")
	verify(mock).foo("abc", Color.RED)
	verify(mock).bar("def", Vector3.FORWARD, AABB())
	verify_no_more_interactions(mock)
	
	# call with custom color arg
	mock.foo("abc", Color.BLUE)
	mock.bar("def", Vector3.DOWN, AABB(Vector3.ONE, Vector3.ZERO))
	verify(mock).foo("abc", Color.BLUE)
	verify(mock).bar("def", Vector3.DOWN, AABB(Vector3.ONE, Vector3.ZERO))
	verify_no_more_interactions(mock)

func _test_mock_virtual_function_is_not_called_twice() -> void:
	# this test verifies the special handling of virtual functions by Godot
	# virtual functions are handeld in a special way 
	# node.cpp
	# case NOTIFICATION_READY: {
	#
	#    if (get_script_instance()) {
	#
	#       Variant::CallError err;
	#       get_script_instance()->call_multilevel_reversed(SceneStringNames::get_singleton()->_ready,NULL,0);
	#    }

	var mock = mock(ClassWithOverridenVirtuals, CALL_REAL_FUNC)
	assert_object(mock).is_not_null()
	
	# inital state
	assert_int(mock._x).is_equal(200)
	
	# add_child calls internally by "default" _ready() where is a virtual function
	# mock has to not call real implementation at twice for virtual functions
	add_child(mock)
	
	# verify it by member _x is only one time doubled
	# the _ready func is multiply the inital x value by two
	assert_int(mock._x).is_equal(400)
	
	# now simulate an input event calls '_input'
	var action = InputEventKey.new()
	action.pressed = false
	action.keycode = KEY_ENTER
	get_tree().root.push_input(action)
	assert_int(mock._x).is_equal(410)

func test_mock_scene_by_path():
	var mocked_scene = mock("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	assert_object(mocked_scene).is_not_null()
	assert_object(mocked_scene.get_script()).is_not_null()
	assert_str(mocked_scene.get_script().resource_name).is_equal("MockTestScene.gd")
	# check is mocked scene registered for auto freeing
	assert_bool(GdUnitMemoryPool.is_auto_free_registered(mocked_scene, get_meta("MEMORY_POOL"))).is_true()

func test_mock_scene_by_resource():
	var resource := load("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	var mocked_scene = mock(resource)
	assert_object(mocked_scene).is_not_null()
	assert_object(mocked_scene.get_script()).is_not_null()
	assert_str(mocked_scene.get_script().resource_name).is_equal("MockTestScene.gd")
	# check is mocked scene registered for auto freeing
	assert_bool(GdUnitMemoryPool.is_auto_free_registered(mocked_scene, get_meta("MEMORY_POOL"))).is_true()

func test_mock_scene_by_instance():
	var resource := load("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	var instance :Control = auto_free(resource.instantiate())
	var mocked_scene = mock(instance)
	# must fail mock an instance is not allowed
	assert_object(mocked_scene).is_null()

func test_mock_scene_by_path_fail_has_no_script_attached():
	var mocked_scene = mock("res://addons/gdUnit4/test/mocker/resources/scenes/TestSceneWithoutScript.tscn")
	assert_object(mocked_scene).is_null()

func test_mock_scene_variables_is_set():
	var mocked_scene = mock("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	assert_object(mocked_scene).is_not_null()
	
	# Add as child to a node to trigger _ready to initalize all variables
	add_child(mocked_scene)
	assert_object(mocked_scene._box1).is_not_null()
	assert_object(mocked_scene._box2).is_not_null()
	assert_object(mocked_scene._box3).is_not_null()
	
	# check signals are connected
	assert_bool(mocked_scene.is_connected("panel_color_change", Callable(mocked_scene, "_on_panel_color_changed")))
	
	# check exports
	assert_str(mocked_scene._initial_color.to_html()).is_equal(Color.RED.to_html())

func test_mock_scene_execute_func_yielded() -> void:
	var mocked_scene = mock("res://addons/gdUnit4/test/mocker/resources/scenes/TestScene.tscn")
	assert_object(mocked_scene).is_not_null()
	add_child(mocked_scene)
	# execute the 'color_cycle' func where emits three signals
	# using yield to wait for function is completed
	var result = await mocked_scene.color_cycle()
	# verify the return value of 'color_cycle'
	assert_str(result).is_equal("black")
	
	verify(mocked_scene)._on_panel_color_changed(mocked_scene._box1, Color.RED)
	verify(mocked_scene)._on_panel_color_changed(mocked_scene._box1, Color.BLUE)
	verify(mocked_scene)._on_panel_color_changed(mocked_scene._box1, Color.GREEN)

class Base:
	func _init(value :String):
		pass

class Foo extends Base:
	func _init():
		super("test")
		pass

func test_mock_with_inheritance_method() -> void:
	var foo = mock(Foo)
	assert_object(foo).is_not_null()
