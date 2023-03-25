---
layout: default
title: Mocking
parent: Advanced Testing
nav_order: 2
---

# Mocking / Mocks

## ***Mocking is current only supported for GdScripts!***


### Definition
A *mocked* object is a dummy implementation for an class in which you define the output of certain function calls. Mocked objects are configured to perform a certain behavior during a test and tracks all function calls and their parameters to the mocked object.

This kind of testing is sometimes called behavior testing. Behavior testing does not check the result of a function call, but it checks that a function is called with the right parameters.

For detailed info about mocks you have [to read](https://en.wikipedia.org/wiki/Mock_object)

---

Here an small example to mock the class `TestClass`.
{% tabs mock-example %}
{% tab mock-example Example Class %}
```ruby
    class_name TestClass
    extends Node

        func message() -> String:
            return "a message"
```
{% endtab %}
{% tab mock-example Mock (RETURN_DEFAULTS) %}
```ruby
    func test_mock():
        # create a mock for class 'TestClass' by mock mode `RETURN_DEFAULTS` (default)
        var mock := mock(TestClass) as TestClass

        # inital the mock will return a default value, for string means an empty string
        assert_str(mock.message()).is_empty()

        # new we override the return value for `message()` to return 'custom message'
        do_return("custom message").on(mock).message()

        # the next call of `message()` will now return 'custom message'
        assert_str(mock.message()).is_equal("custom message")
```
{% endtab %}
{% tab mock-example Mock (CALL_REAL_FUNC) %}
```ruby
    func test_mock():
        # create a mock for class 'TestClass' using mode `CALL_REAL_FUNC`
        var mock := mock(TestClass, CALL_REAL_FUNC) as TestClass

        # inital the mock will return a original value (calles the real implementation)
        assert_str(mock.message()).is_equal("a message")

        # new we override the return value for `message()` to return 'custom message'
        do_return("custom message").on(mock).message()

        # the next call of `message()` will now return 'custom message'
        assert_str(mock.message()).is_equal("custom message")
```
{% endtab %}
{% endtabs %}

---

### How to use a Mock
To mock a class you only need to use **mock(\<class_name\>)** or **mock(\<resource_path\>)** to create a mocked object instance by given class name or path. A mocked instance is marked for auto free, you don't need to free it manually.

To enable creation a mock by class name you have to defined the *class_name* in your class otherwise the class must be mock by resource path.
```ruby
    # example class 
    class_name TestClass
    extends Node
        ...
```
```ruby
    # create a mocked instance of by class 'TestClass'
    var mock := mock(TestClass)
    # or create by using the full resource path if no `class_name` defined
    var mock := mock("res://project_name/src/TestClass.gd")
```

You can also mock inner classes by using **mock(\<class_name\>)** by some preconditions.


### How and Why we overwrite functions
With a mock you can override a specific function to return custom values.
This allows you to simulate a function and return an expected value without calling the actual implementation.

To override a function on your mocked class use **do_return(\<value\>)** to specify the return value.
#### Syntax
`do_return(<value>)` `.on(<mock>)` `.<function([args])>)`

First you have to define the return value, then the mock and finally the function you want to override.
```ruby
    var node := mock(Node) as Node
    do_return("NodeX").on(node).get_name()
```

#### Example
```ruby
    # create a mock from class `Node`
    var mocked_node := mock(Node) as Node

    # is return 0 by default
    mocked_node.get_child_count()
    # override function `get_child_count` to return 10
    do_return(10).on(mocked_node).get_child_count()
    # next call of `get_child_count` will now return 10
    mocked_node.get_child_count()
    
    # is return 'null' by default
    var node = mocked_node.get_child(0)
    assert_object(node).is_null()
    
    # override function `get_child` to return a mocked 'Camera' for child index 0
    do_return(mock(Camera)).on(mocked_node).get_child(0)
    # and a mocked 'Area' for child index 1
    do_return(mock(Area)).on(mocked_node).get_child(1)
    
    # it returns now on indec 0 the Camera node
    var node0 = mocked_node.get_child(0)
    assert_object(node0).is_instanceof(Camera)
    # and on index 1 the Area node
    var node1 = mocked_node.get_child(1)
    assert_object(node1).is_instanceof(Area)
```

---

### Verification of function calls
A mock keeps track of all the function calls and their arguments. Use **verify()** on the mock to verify that the specified conditions are met.
This way you can check if a certain function is called and how often it was called.

|Function |Description |
|---|---|
|[verify](/gdUnit4/advanced_testing/mock/#verify) | Verifies certain behavior happened at least once or exact number of times|
|[verify_no_interactions](/gdUnit4/advanced_testing/mock/#verify_no_interactions) | Verifies no interactions is happen on this mock|
|[verify_no_more_interactions](/gdUnit4/advanced_testing/mock/#verify_no_more_interactions) | Verifies the given mock has any unverified interaction|
|[reset](/gdUnit4/advanced_testing/mock/#reset) | Resets the saved function call counters on a mock|



### verify_no_interactions
Verifies no interactions is happen on this mock.

```ruby
    verify_no_interactions(<mock>)
```
```ruby
    var mocked_node := mock(Node) as Node
    
    # test we have initial no interactions on this mock
    verify_no_interactions(mocked_node)

    # interact by calling `get_name()`
    mocked_node.get_name()

    # now this verification will fail because we have interacted on this mock
    verify_no_interactions(mocked_node)
```

### verify_no_more_interactions
Checks whether the specified mock has no further interaction.

If the mock has recorded more interactions than you verified with `verify()`, an error is reported.


```ruby
    verify_no_more_interactions(<mock>)
```
```ruby
    var mocked_node := mock(Node) as Node
    
    # interact on two functions 
    mocked_node.is_a_parent_of(null)
    mocked_node.set_process(false)
    # verify if interacts
    verify(mocked_node).is_a_parent_of(null)
    verify(mocked_node).set_process(false)
    # finally we want to check no more interactions on this mock was happen
    verify_no_more_interactions(mocked_node)

    # simmulate a unexpected interaction on `set_process`
    mocked_node.set_process(false)
    # no the verify will fail because we have an interacted on `set_process(false)` where we not expected
    verify_no_more_interactions(mocked_node)
```

### verify
Verifies certain behavior happened at least once or exact number of times


```ruby
    verify(<mock>, <times>).function(<args>)
```
```ruby
    var mocked_node :Node = mock(Node)
    
    # verify we have no interactions currently on this instance
    verify_no_interactions(mocked_node)
    
    # call with different arguments
    mocked_node.set_process(false) # 1 times
    mocked_node.set_process(true) # 1 times
    mocked_node.set_process(true) # 2 times
    
    # verify how often we called the function with different argument 
    verify(mocked_node, 1).set_process(false)# in sum one time with false
    verify(mocked_node, 2).set_process(true) # in sum two times with true

    # verify will fail because we expect the function `set_process(true)` is called 3 times but was called 2 times
    verify(mocked_node, 3).set_process(true)
```

### reset
Resets the recorded function interactions of given mock.

Sometimes we want to reuse an already created mock for different test scenarios and have to reset the recorded interactions. 


```ruby
    reset(<mock>)
```
```ruby
    var mocked_node :Node = mock(Node)
    
    # first testing interact on two functions 
    mocked_node.is_a_parent_of(null)
    mocked_node.set_process(false)
    # verify if interacts,at this point two interactions are recorded
    verify(mocked_node).is_a_parent_of(null)
    verify(mocked_node).set_process(false)


    # now we want to test a other scenario and we need to reset the current recorded interactions
    reset(mocked_node)
    # we verify the previously recorded interactions have been removed
    verify_no_more_interactions(mocked_node)

    # continue testing ..
    mocked_node.set_process(true)
    verify(mocked_node).set_process(true)
    verify_no_more_interactions(mocked_node)
```

---

### Mock Working Modes 
When creating a mock, you can specify the working mode that defines the return value handling of function calls for a mock.

* RETURN_DEFAULTS (default)
* CALL_REAL_FUNC
* RETURN_DEEP_STUB (not yet implemented!)


{% tabs mock-modes %}
{% tab mock-modes RETURN_DEFAULTS %}

If *RETURN_DEFAULTS* is used, all unoverridden function calls return [default values](/gdUnit4/advanced_testing/mock/#default-values) for a mocked class.

```ruby
    var mock := mock(TestClass) as TestClass

    # returns a default value (for String an empty value)
    assert_str(mock.message()).is_equal("")

```
{% endtab %}
{% tab mock-modes CALL_REAL_FUNC %}

If *CALL_REAL_FUNC* is used, all unoverridden function calls return the value provided by the real implementation for a mocked class.
Helpful when you only want to mock partial functions of a class.

```ruby
    # build a mock with mode CALL_REAL_FUNC
    var mock := mock(TestClass, CALL_REAL_FUNC) as TestClass

    # returns the real implementation value
    assert_str(mock.message()).is_equal("a message")

    # set a the return value to 'custom message' for the function message()
    do_return("custom message").on(mock).message()

    # now the function message will return 'custom message'
    assert_str(mock.message()).is_equal("custom message")
```
{% endtab %}
{% tab mock-modes RETURN_DEEP_STUB %}
***WORK IN PROGRESS -- NOT SUPPORTED YET!!!***

If *RETURN_DEEP_STUB* is used, all unoverridden function calls return the value provided by the real implementation for a mocked class.
Use to return a default value for build-in types or a fully mocked value for Object types.
```ruby
    # build a mock with mode RETURN_DEEP_STUB
    var mock := mock(TestClass, RETURN_DEEP_STUB) as TestClass

    # returns a default value 
    assert_str(mock.message()).is_equal("")

    # returns a mocked Path value
    assert_object(mock.path()).is_not_null()
```
{% endtab %}
{% endtabs %}


### Default Values
Unconfigured function calls do return a *default* value for mock working mode **RETURN_DEFAULTS**

|Type| default value|
|---|---|
| TYPE_NIL | null |
| TYPE_BOOL | false |
| TYPE_INT | 0 |
| TYPE_REAL | 0.0 |
| TYPE_STRING | "" |
| TYPE_VECTOR2 | Vector2.ZERO |
| TYPE_RECT2 | Rect2() |
| TYPE_VECTOR3 | Vector3.ZERO |
| TYPE_TRANSFORM2D | Transform2D() |
| TYPE_PLANE | Plane() |
| TYPE_QUAT | Quat() |
| TYPE_AABB | AABB() |
| TYPE_BASIS | Basis() |
| TYPE_TRANSFORM | Transform() |
| TYPE_COLOR | Color() |
| TYPE_NODE_PATH | NodePath() |
| TYPE_RID | RID() |
| TYPE_OBJECT | null |
| TYPE_DICTIONARY | Dictionary() |
| TYPE_ARRAY | Array() |
| TYPE_RAW_ARRAY | PoolByteArray() |
| TYPE_INT_ARRAY | PoolIntArray() |
| TYPE_REAL_ARRAY | PoolRealArray() |
| TYPE_STRING_ARRAY | PoolStringArray() |
| TYPE_VECTOR2_ARRAY | PoolVector2Array() |
| TYPE_VECTOR3_ARRAY | PoolVector3Array() |
| TYPE_COLOR_ARRAY | PoolColorArray() |

---

### Argument Matchers and mocks
To simplify the verification of function calls, you can use an argument matcher.
This allows you to verify function calls by a specific type or class argument.


```ruby
    var mocked_node :Node = mock(Node)
    
    # call with different arguments
    mocked_node.set_process(false) # 1 times
    mocked_node.set_process(true) # 1 times
    mocked_node.set_process(true) # 2 times
    
    # verify how often we called the function with a boolean argument
    verify(mocked_node, 3).set_process(any_bool())
```
For more details please show at [Argument Matchers](/gdUnit4/advanced_testing/argument_matchers)
