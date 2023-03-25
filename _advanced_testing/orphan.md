---
layout: default
title: Orphan Nodes
parent: Advanced Testing
nav_order: 7
---

# Orphan Nodes or leaking Memory
In Godot, objects that are not freed are called *orphan nodes*. When you start writing a test, you often have no way of knowing whether all of the objects you created were properly shared after the test was run.
One helping tool is using **auto_free** to manage your object.

---

### How to fix detected orphan nodes
With GdUnit you can easily identify orphaned nodes, these are marked as WARNING in the GdUnit inspector.
I recommend repairing any orphaned nodes discovered to make sure your project does not leak memory over time.


### How do I recognize orphan nodes in my code?
Finding the code location where the orphaned nodes are located is a little difficult and often time consuming.

If you are not an expert and have no idea what the problem is, I recommend a step-by-step approach.

Here an small example of an class with an orphan node.

```ruby
  class_name MyTestClass
  extends Resource


  class PathX extends Path:
    var _valid :bool
    
    func _init():
      _valid = false
      
    func validate() -> PathX:
      _valid = true
      return self

  var _path : PathX = PathX.new()

  func calculate_path() -> Path:
    return _path.validate()
```


And a small test
```ruby
  class_name MyTes
  extends GdUnitTestSuite


  func test_get_pathx():
    var t := DeepStubTestClass.new()
    assert_object(t).is_not_null()
    assert_object(t.get_pathx()).is_instanceof(DeepStubTestClass.PathX)
```


After test run the test ends with success but it has detects one orphan node.

![](/gdUnit4/assets/images/monitoring/orphan_nodes_example.png)

Now you can review your implementation, if you don't know where the orphaned node is, take it step by step.
Means to comment out line by line or a series of lines and run the test again. 
```ruby
  func test_get_pathx():
    var t := DeepStubTestClass.new()
    assert_object(t).is_not_null()
    #assert_object(t.get_pathx()).is_instanceof(DeepStubTestClass.PathX)
```

Try again after the orphaned node is rediscovered.
```ruby
  func test_get_pathx():
    var t := DeepStubTestClass.new()
    #assert_object(t).is_not_null()
    #assert_object(t.get_pathx()).is_instanceof(DeepStubTestClass.PathX)
```

Since only one line is now active, the error must be located in the constructor.
Ok let us check the constructor.

The class *MyTestClass* has no cunstructor, you miss the _init() function?

This means that the class has a default constructor and we are not making a mistake here.

So let take a deeper look on the used member variables.
```ruby
  ...
  var _path : PathX = PathX.new()

  func calculate_path() -> Path:
    return _path.validate()
```


Here we assign a variable with an instance of XPath. The XPath class inherits from a Path where also inherits from a Node.
A Node is not a reference that is automatically released when it is no longer used (I recomment to read the offical Godot documentation about References vs Objects).

Looks like we've found the problem, but how to fix it?

The example class inherits from a Resource, which implicitly means that all resources should be automatically freed.

We have to now to override the *_notification* func where is called when a resource is freed.

```ruby
  func _notification(what):
          # we notified for freeing your resources
    if what == NOTIFICATION_PREDELETE:
                  # check if _path a valid object (not already freed)
      if _path:
        _path.free()
```

Rerun your test and you see the orpahn nodes is fixed.

Finally activate the commented-out lines and run the test again.
