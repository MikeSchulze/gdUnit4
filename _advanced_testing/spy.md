---
layout: default
title: Spying
parent: Advanced Testing
nav_order: 3
---

# Spy

## ***Spy is current only supported for GdScripts!***

### Definition
A Spy is used to verify a certain behavior during a test and tracks all function calls and their parameters of an instance.

`var to_spy := spy(<instance>)`

### *What is the difference between a spy and an mock?*

In difference to a mock on a spy the real implementation is called. It will still behave in the same way as the normal instance.

---

### How to use a Spy
To spy on a object you only need to use **spy(\<instance\>)**. A spyed instance is marked for auto free, you don't need to free it manually.

```ruby
    var spy:= spy(auto_free(Node.new()))
```


Here a small example to use the spy on a instance of the class 'TestClass'.
```ruby
    class_name TestClass
    extends Node

        func message() -> String:
            return "a message"
```
``` python
    func test_spy():
        var instance = auto_free(TestClass.new())
        # build a spy on the instance
        var spy:= spy(instance)
        # call function `message` on the spy to track the interaction
        spy.message()
        # verify the function 'message' is called one times
        verify(spy, 1).message()
```

### Verification of function calls
A spy keeps track of all the function calls and their arguments. Use **verify()** on the spy to verify that the specified conditions are met.
This way you can check if a certain function is called and how often it was called.

|Function |Description |
|---|---|
|[verify](/gdUnit3/advanced_testing/spy/#verify) | Verifies certain behavior happened at least once or exact number of times|
|[verify_no_interactions](/gdUnit3/advanced_testing/spy/#verify_no_interactions) | Verifies no interactions is happen on this spy|
|[verify_no_more_interactions](/gdUnit3/advanced_testing/spy/#verify_no_more_interactions) | Verifies the given spy has any unverified interaction|
|[reset](/gdUnit3/advanced_testing/spy/#reset) | Resets the saved function call counters on a spy|


### verify_no_interactions
Verifies no interactions is happen on this spy.

```ruby
    verify_no_interactions(<spy>)
```
```ruby
    var spyed_node := spy(Node.new()) as Node
    
    # test we have initial no interactions on this spy
    verify_no_interactions(spyed_node)

    # interact by calling `get_name()`
    spyed_node.get_name()

    # now this verification will fail because we have interacted on this spy
    verify_no_interactions(spyed_node)
```

### verify_no_more_interactions
Checks whether the specified spy has no further interaction.

If the spy has recorded more interactions than you verified with `verify()`, an error is reported.


```ruby
    verify_no_more_interactions(<spy>)
```
```ruby
    var spyed_node := spy(Node.new()) as Node
    
    # interact on two functions 
    spyed_node.is_a_parent_of(null)
    spyed_node.set_process(false)
    # verify if interacts
    verify(spyed_node).is_a_parent_of(null)
    verify(spyed_node).set_process(false)
    # finally we want to check no more interactions on this spy was happen
    verify_no_more_interactions(spyed_node)

    # simmulate a unexpected interaction on `set_process`
    spyed_node.set_process(false)
    # no the verify will fail because we have an interacted on `set_process(false)` where we not expected
    verify_no_more_interactions(spyed_node)
```

### verify
Verifies certain behavior happened at least once or exact number of times


```ruby
    verify(<spy>, <times>).function(<args>)
```
```ruby
    var spyed_node :Node = spy(Node.new())
    
    # verify we have no interactions currently on this instance
    verify_no_interactions(spyed_node)
    
    # call with different arguments
    spyed_node.set_process(false) # 1 times
    spyed_node.set_process(true) # 1 times
    spyed_node.set_process(true) # 2 times
    
    # verify how often we called the function with different argument 
    verify(spyed_node, 1).set_process(false)# in sum one time with false
    verify(spyed_node, 2).set_process(true) # in sum two times with true

    # verify will fail because we expect the function `set_process(true)` is called 3 times but was called 2 times
    verify(spyed_node, 3).set_process(true)
```

### reset
Resets the recorded function interactions of given spy.

Sometimes we want to reuse an already created spy for different test scenarios and have to reset the recorded interactions. 


```ruby
    reset(<spy>)
```
```ruby
    var spyed_node :Node = spy(Node.new())
    
    # first testing interact on two functions 
    spyed_node.is_a_parent_of(null)
    spyed_node.set_process(false)
    # verify if interacts,at this point two interactions are recorded
    verify(spyed_node).is_a_parent_of(null)
    verify(spyed_node).set_process(false)


    # now we want to test a other scenario and we need to reset the current recorded interactions
    reset(spyed_node)
    # we verify the previously recorded interactions have been removed
    verify_no_more_interactions(spyed_node)

    # continue testing ..
    spyed_node.set_process(true)
    verify(spyed_node).set_process(true)
    verify_no_more_interactions(spyed_node)
```

---

### Argument Matchers and spys
To simplify the verification of function calls, you can use an argument matcher.
This allows you to verify function calls by a specific type or class argument.


```ruby
    var spyed_node :Node = spy(Node.new())
    
    # call with different arguments
    spyed_node.set_process(false) # 1 times
    spyed_node.set_process(true) # 1 times
    spyed_node.set_process(true) # 2 times
    
    # verify how often we called the function with a boolean argument
    verify(spyed_node, 3).set_process(any_bool())
```
For more details please show at [Argument Matchers](/gdUnit3/advanced_testing/argument_matchers)




