---
layout: default
title: Argument Matchers
parent: Advanced Testing
nav_order: 5
---

# Argument Matchers

## ***Note: Argument Matchers are currently only supported for GdScripts.***

---

## Definition
GdUnit provides a set of argument matchers that allow you to check the behavior of function calls with an argument of a certain type.<br>
An argument matcher is a tool that helps verify the behavior of a function call by a specified argument type on a **mock** or **spy** object. This means that you can test the call of a function without having to specify the exact argument value(s).


```ruby
    verify(<mock>, <times>).function(<arg_matcher>)
    verify(<spy>, <times>).function(<arg_matcher>)
```

For example, instead of verifying that a function was called with the exact string "This is a test" two times, you can use the argument matcher **any_string()** to verify that the function was called two times with any string argument.<br>
Here is an example:
```ruby
    # Verifying that the function `set_message` is called two times with the argument "This is a test"
    verify(mock, 2).set_message("This is a test")
    # Using the argument matcher `any_string()` to verify that the function is called two times with any string argument
    verify(mock, 2).set_message(any_string())
```

---

### Argument Matcher Overview
The following matchers are available:<br>

|Argument Matcher|Description|
|---|---|
|any | Argument matcher to match any argument|
|any_bool | Argument matcher to match any boolean value|
|any_int | Argument matcher to match any integer value|
|any_float | Argument matcher to match any float value|
|any_string | Argument matcher to match any string value|
|any_class | Argument matcher to match any instance of given class|
|any_color | Argument matcher to match any Color value|
|any_vector | Argument matcher to match any Vector value|
|any_vector2 | Argument matcher to match any Vector2 value|
|any_vector2i | Argument matcher to match any Vector2i value|
|any_vector3 | Argument matcher to match any Vector3 value|
|any_vector3i | Argument matcher to match any Vector3i value|
|any_vector4 | Argument matcher to match any Vector4 value|
|any_vector4i | Argument matcher to match any Vector4i value|
|any_rect2 | Argument matcher to match any Rect2 value|
|any_plane | Argument matcher to match any Plane value|
|any_quat | Argument matcher to match any Quat value|
|any_aabb | Argument matcher to match any AABB value|
|any_basis | Argument matcher to match any Basis value|
|any_transform | Argument matcher to match any Transform value|
|any_transform_2d | Argument matcher to match any Transform2D value|
|any_node_path | Argument matcher to match any NodePath value|
|any_rid | Argument matcher to match any RID value|
|any_object | Argument matcher to match any Object value|
|any_dictionary | Argument matcher to match any Dictionary value|
|any_array | Argument matcher to match any Array value|
|any_pool_byte_array | Argument matcher to match any PackedByteArray value|
|any_pool_int_array | Argument matcher to match any PackedIntArray value|
|any_pool_float_array | Argument matcher to match any PackedFloatArray value|
|any_pool_string_array | Argument matcher to match any PackedStringArray value|
|any_pool_vector2_array | Argument matcher to match any PackedVector2Array value|
|any_pool_vector3_array | Argument matcher to match any PackedVector3Array value|
|any_pool_color_array | Argument matcher to match any PackedColorArray value|

The any matcher matches any argument passed to the function. This is useful if you only want to check that the function was called with a certain number of arguments but don't care about their specific values. For example, `verify(mock, 2).function(any())` will check that the mock object's function was called exactly two times with any arguments.

---

## Build your own custom Argument Matcher
You can write your own argument matcher if necessary. You can do this by extend from class **GdUnitArgumentMatcher** and implement the **is_match** function.

```ruby
    # base class of all argument matchers
    class_name GdUnitArgumentMatcher
    extends Reference

        # the fuction you have to override in your custom matcher
        func is_match(value) -> bool:
            return true
```


Here is a simple example of how to write your own argument matcher.<br>
```ruby
    # a simple class we want to test
    class_name MyClass
    extends Reference

        var _value:int

        func set_value(value :int):
            _value = value
```

The custom argument matcher:
``` ruby
    class PeekMatcher extends GdUnitArgumentMatcher:
        var _peek :int
        
        func _init(peek :int):
            _peek = peek

        func is_match(value) -> bool:
            return value > _peek
```
Just to clarify, the `PeekMatcher` class is an implementation of the `GdUnitArgumentMatcher` abstract class, which provides the **is_match()** function. In this example, the is_match method checks if the argument is greater than the _peek value passed in the constructor.


The test:
```ruby
    func test_custom_matcher():
        # we mock the custom class here
        var mocked_test_class :MyClass = mock(MyClass)
        
        mocked_test_class.set_value(1000)
        mocked_test_class.set_value(1001)
        mocked_test_class.set_value(1002)
        mocked_test_class.set_value(2002)
        
        # counts 1001, 1002, 2002 = 3 times
        verify(mocked_test_class, 3).set_value(PeekMatcher.new(1000))
        # counts 2002 = 1 times
        verify(mocked_test_class, 1).set_value(PeekMatcher.new(2000))
```
Then in the test, we create a mocked_test_class object and call its **set_value** method with different arguments. Finally, we use verify to check if the method was called with arguments that meet the condition of the PeekMatcher.

---
<h4> document version v4.1.1 </h4>
