# GdUnit generated TestSuite
class_name GdUnitObjectAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitObjectAssertImpl.gd'


func test_is_equal():
	assert_object(Mesh.new()).is_equal(Mesh.new())
	
	assert_failure(func(): assert_object(Mesh.new()).is_equal(Skin.new())) \
		.is_failed()
	assert_failure(func(): assert_object(null).is_equal(Skin.new())) \
		.is_failed() \
		.has_message("Expecting:\n"
			+ " <Skin>\n"
			+ " but was\n"
			+ " '<null>'")


func test_is_not_equal():
	assert_object(null).is_not_equal(Skin.new())
	assert_object(Mesh.new()).is_not_equal(Skin.new())
	
	assert_failure(func(): assert_object(Mesh.new()).is_not_equal(Mesh.new())) \
		.is_failed()


func test_is_instanceof():
	# engine class test
	assert_object(auto_free(Path3D.new())).is_instanceof(Node)
	assert_object(auto_free(Camera3D.new())).is_instanceof(Camera3D)
	# script class test
	assert_object(auto_free(Udo.new())).is_instanceof(Person)
	# inner class test
	assert_object(auto_free(CustomClass.InnerClassA.new())).is_instanceof(Node)
	assert_object(auto_free(CustomClass.InnerClassB.new())).is_instanceof(CustomClass.InnerClassA)
	
	assert_failure(func(): assert_object(auto_free(Path3D.new())).is_instanceof(Tree)) \
		.is_failed() \
		.has_message("Expected instance of:\n 'Tree'\n But it was 'Path3D'")
	assert_failure(func(): assert_object(null).is_instanceof(Tree)) \
		.is_failed() \
		.has_message("Expected instance of:\n 'Tree'\n But it was '<null>'")


func test_is_not_instanceof():
	assert_object(null).is_not_instanceof(Tree)
	# engine class test
	assert_object(auto_free(Path3D.new())).is_not_instanceof(Tree)
	# script class test
	assert_object(auto_free(City.new())).is_not_instanceof(Person)
	# inner class test
	assert_object(auto_free(CustomClass.InnerClassA.new())).is_not_instanceof(Tree)
	assert_object(auto_free(CustomClass.InnerClassB.new())).is_not_instanceof(CustomClass.InnerClassC)
	
	assert_failure(func(): assert_object(auto_free(Path3D.new())).is_not_instanceof(Node)) \
		.is_failed() \
		.has_message("Expected not be a instance of <Node>")


func test_is_null():
	assert_object(null).is_null()
	
	assert_failure(func(): assert_object(auto_free(Node.new())).is_null()) \
		.is_failed() \
		.starts_with_message("Expecting: '<null>' but was <Node>")


func test_is_not_null():
	assert_object(auto_free(Node.new())).is_not_null()
	
	assert_failure(func(): assert_object(null).is_not_null()) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_is_same():
	var obj1 = auto_free(Node.new())
	var obj2 = obj1
	var obj3 = auto_free(obj1.duplicate())
	assert_object(obj1).is_same(obj1)
	assert_object(obj1).is_same(obj2)
	assert_object(obj2).is_same(obj1)
	
	assert_failure(func(): assert_object(null).is_same(obj1)) \
		.is_failed() \
		.has_message("Expecting:\n"
			+ " <Node>\n"
			+ " to refer to the same object\n"
			+ " '<null>'")
	assert_failure(func(): assert_object(obj1).is_same(obj3)) \
		.is_failed()
	assert_failure(func(): assert_object(obj3).is_same(obj1)) \
		.is_failed()
	assert_failure(func(): assert_object(obj3).is_same(obj2)) \
		.is_failed()


func test_is_not_same():
	var obj1 = auto_free(Node.new())
	var obj2 = obj1
	var obj3 = auto_free(obj1.duplicate())
	assert_object(null).is_not_same(obj1)
	assert_object(obj1).is_not_same(obj3)
	assert_object(obj3).is_not_same(obj1)
	assert_object(obj3).is_not_same(obj2)

	assert_failure(func(): assert_object(obj1).is_not_same(obj1)) \
		.is_failed() \
		.has_message("""
			Expecting not same:
			 <Node>"""
			.dedent()
			.trim_prefix("\n"))
	assert_failure(func(): assert_object(obj1).is_not_same(obj2)) \
		.is_failed() \
		.has_message("""
			Expecting not same:
			 <Node>"""
			.dedent()
			.trim_prefix("\n"))
	assert_failure(func(): assert_object(obj2).is_not_same(obj1)) \
		.is_failed() \
		.has_message("""
			Expecting not same:
			 <Node>"""
			.dedent()
			.trim_prefix("\n"))


func test_must_fail_has_invlalid_type():
	assert_failure(func(): assert_object(1)) \
		.is_failed() \
		.has_message("GdUnitObjectAssert inital error, unexpected type <int>")
	assert_failure(func(): assert_object(1.3)) \
		.is_failed() \
		.has_message("GdUnitObjectAssert inital error, unexpected type <float>")
	assert_failure(func(): assert_object(true)) \
		.is_failed() \
		.has_message("GdUnitObjectAssert inital error, unexpected type <bool>")
	assert_failure(func(): assert_object("foo")) \
		.is_failed() \
		.has_message("GdUnitObjectAssert inital error, unexpected type <String>")


func test_override_failure_message() -> void:
	assert_failure(func(): assert_object(auto_free(Node.new())) \
			.override_failure_message("Custom failure message") \
			.is_null()) \
		.is_failed() \
		.has_message("Custom failure message")


# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()
	
	# checked success assert
	assert_object(null).is_null()
	assert_bool(is_failure()).is_false()
	
	# checked faild assert
	assert_failure(func(): assert_object(RefCounted.new()).is_null()) \
		.is_failed()
	assert_bool(is_failure()).is_true()
	
	# checked next success assert
	assert_object(null).is_null()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()
	
	# should abort here because we had an failing assert
	if is_failure():
		return
	assert_bool(true).override_failure_message("This line shold never be called").is_false()
