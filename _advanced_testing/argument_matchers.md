---
layout: default
title: Argument Matchers
parent: Advanced Testing
nav_order: 3
---

# Argument Matchers

## ***Argument Matchers is current only supported for GdScripts!***

---

## Definition
An argument matcher is designed to help verify the behavior of a function call by a specified argument type on a **mock** or **spy**.

That means we can test the call of a function without having to specify the exact argument value(s).

### Example
```ruby
    # we test if the function `set_message` is called two times with the argument `"This is a test"`
    verify(mock, 2).set_message("This is a test")
    # If you only interested the function is called 2 times by any string
    # you can simplify by by using instead the argument machter `any_string()`
    verify(mock, 2).set_message(any_string())
```

---

### Argument Matcher

```ruby
    verify(<mock>, <times>).function(<arg_matcher>)
    verify(<spy>, <times>).function(<arg_matcher>)
```


GdUnit provides a set of argument matchers that allow you to check the behavior of function calls with an argument of a certain type.

|Argument Matcher|Description|
|---|---|
|any | Argument matcher to match any argument|
|any_bool | Argument matcher to match any boolean value|
|any_int | Argument matcher to match any integer value|
|any_float | Argument matcher to match any float value|
|any_string | Argument matcher to match any string value|
|any_class | Argument matcher to match any instance of given class|
|any_color | Argument matcher to match any Color value|
|any_vector2 | Argument matcher to match any Vector2 value|
|any_vector3 | Argument matcher to match any Vector3 value|
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
|any_pool_byte_array | Argument matcher to match any PoolByteArray value|
|any_pool_int_array | Argument matcher to match any PoolIntArray value|
|any_pool_float_array | Argument matcher to match any PoolRealArray value|
|any_pool_string_array | Argument matcher to match any PoolStringArray value|
|any_pool_vector2_array | Argument matcher to match any PoolVector2Array value|
|any_pool_vector3_array | Argument matcher to match any PoolVector3Array value|
|any_pool_color_array | Argument matcher to match any PoolColorArray value|

---

### Build your own custom Argument Matcher
You can write your own argument matcher if necessary. You can do this by extend from class **GdUnitArgumentMatcher** and implement the **is_match** function.

```ruby
    # base class of all argument matchers
    class_name GdUnitArgumentMatcher
    extends Reference

        # the fuction you have to override in your custom matcher
        func is_match(value) -> bool:
            return true
```


Here is a simple example of how to write your own argument matcher.
{% tabs argument-matcher-custom-example %}
{% tab argument-matcher-custom-example Example Class %}
```ruby
    class_name MyClass
    extends Reference

        var _value:int

        func set_value(value :int):
            _value = value
```
{% endtab %}
{% tab argument-matcher-custom-example Custom Matcher %}
We want to only accept values that greater than defined peek
``` ruby
    class PeekMatcher extends GdUnitArgumentMatcher:
        var _peek :int
        
        func _init(peek :int):
            _peek = peek

        func is_match(value) -> bool:
            return value > _peek
```
{% endtab %}
{% tab argument-matcher-custom-example Example Test %}
```ruby
    func test_custom_matcher():
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
{% endtab %}
{% endtabs %}

