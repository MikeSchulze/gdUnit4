extends GdUnitTestSuite

class TestClass:
	var _value :int
	
	func _init(value :int):
		_value = value


func test_parameter_comparison():
	var obj1 = TestClass.new(1)
	var obj2 = TestClass.new(1)
	var obj3 = TestClass.new(2)
  
	# Using is_equal to check if obj1 and obj2 are equal
	assert_object(obj1).is_equal(obj2)
  
	# Using is_not_equal to check if obj1 and obj3 do not equal, the value are different
	assert_object(obj1).is_not_equal(obj3)


func test_object_comparison():
	var obj1 = TestClass.new(1)
	var obj2 = obj1
	var obj3 = TestClass.new(2)
  
	# Using is_same to check if obj1 and obj2 refer to the same instance
	assert_object(obj1).is_same(obj2)
  
	# Using is_not_same to check if obj1 and obj3 do not refer to the same instance
	assert_object(obj1).is_not_same(obj3)
