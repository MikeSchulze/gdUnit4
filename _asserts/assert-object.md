---
layout: default
title: Object Assert
parent: Asserts
nav_order: 7
---

## Object Assertions

An assertion tool to verify Objects.

{% tabs assert-obj-overview %}
{% tab assert-obj-overview GdScript %}
|Function|Description|
|[is_null](/gdUnit3/asserts/assert-object/#is_null) | Verifies that the current value is null.|
|[is_not_null](/gdUnit3/asserts/assert-object/#is_not_null) | Verifies that the current value is not null.|
|[is_equal](/gdUnit3/asserts/assert-object/#is_equal) | Verifies that the current value is equal to expected one.|
|[is_not_equal](/gdUnit3/asserts/assert-object/#is_not_equal) | Verifies that the current value is not equal to expected one.|
|[is_same](/gdUnit3/asserts/assert-object/#is_same) | Verifies that the current value is the same as the given one.|
|[is_not_same](/gdUnit3/asserts/assert-object/#is_not_same) | Verifies that the current value is not the same as the given one.|
|[is_instanceof](/gdUnit3/asserts/assert-object/#is_instanceof) | Verifies that the current value is an instance of the given type.|
|[is_not_instanceof](/gdUnit3/asserts/assert-object/#is_not_instanceof) | Verifies that the current value is not an instance of the given type.|
{% endtab %}
{% tab assert-obj-overview C# %}
|Function|Description|
|[IsNull](/gdUnit3/asserts/assert-object/#is_null) | Verifies that the current value is null.|
|[IsNotNull](/gdUnit3/asserts/assert-object/#is_not_null) | Verifies that the current value is not null.|
|[IsEqual](/gdUnit3/asserts/assert-object/#is_equal) | Verifies that the current value is equal to expected one.|
|[IsNotRqual](/gdUnit3/asserts/assert-object/#is_not_equal) | Verifies that the current value is not equal to expected one.|
|[IsSame](/gdUnit3/asserts/assert-object/#is_same) | Verifies that the current value is the same as the given one.|
|[IsNotSame](/gdUnit3/asserts/assert-object/#is_not_same) | Verifies that the current value is not the same as the given one.|
|[IsInstanceOf](/gdUnit3/asserts/assert-object/#is_instanceof) | Verifies that the current value is an instance of the given type.|
|[IsNotInstanceOf](/gdUnit3/asserts/assert-object/#is_not_instanceof) | Verifies that the current value is not an instance of the given type.|
{% endtab %}
{% endtabs %}



---
## Object Assert Examples

### is_equal
Verifies that the current value is equal to expected one.
{% tabs assert-obj-is_equal %}
{% tab assert-obj-is_equal GdScript %}
```ruby
    func assert_object(<current>).is_equal(<expected>) -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    assert_object(Mesh.new()).is_equal(Mesh.new())

    # should fail because the current is an Mesh and we expect equal to a Skin
    assert_object(Mesh.new()).is_equal(Skin.new())
```
{% endtab %}
{% tab assert-obj-is_equal C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertObject(new Godot.Mesh()).IsEqual(new Godot.Mesh());

    // should fail because the current is an Mesh and we expect equal to a Skin
    AssertObject(new Godot.Mesh()).IsEqual(new Godot.Skin());
```
{% endtab %}
{% endtabs %}

### is_not_equal
Verifies that the current value is not equal to expected one.
{% tabs assert-obj-is_not_equal %}
{% tab assert-obj-is_not_equal GdScript %}
```ruby
    func assert_object(<current>).is_not_equal(<expected>) -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    assert_object(Mesh.new()).is_not_equal(Skin.new())

    # should fail because the current is an Mesh and we expect not equal to a Mesh
    assert_object(Mesh.new()).is_not_equal(Mesh.new())
```
{% endtab %}
{% tab assert-obj-is_not_equal C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsNotEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertObject(new Godot.Mesh()).IsNotEqual(new Godot.Skin());

    // should fail because the current is an Mesh and we expect not equal to a Mesh
    AssertObject(new Godot.Mesh()).IsNotEqual(new Godot.Mesh());
```
{% endtab %}
{% endtabs %}

### is_null
Verifies that the current value is null.
{% tabs assert-obj-is_null %}
{% tab assert-obj-is_null GdScript %}
```ruby
    func assert_object(<current>).is_null() -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    assert_object(null).is_null()

    # should fail because it the current value is an Mesh and not null
    assert_object(Mesh.new()).is_null()
```
{% endtab %}
{% tab assert-obj-is_null C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsNull();
```
```cs
    // this assertion succeeds
    AssertObject(null).IsNull();

    // should fail because it the current value is an Mesh and not null
    AssertObject(new Godot.Mesh()).IsNull();
```
{% endtab %}
{% endtabs %}

### is_not_null
Verifies that the current value is not null.
{% tabs assert-obj-is_not_null %}
{% tab assert-obj-is_not_null GdScript %}
```ruby
    func assert_object(<current>).is_not_null() -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    assert_object(Mesh.new()).is_not_null()

    # should fail because the current value is null
    assert_object(null).is_not_null()
```
{% endtab %}
{% tab assert-obj-is_not_null C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsNotNull();
```
```cs
    // this assertion succeeds
    AssertObject(new Godot.Mesh()).IsNotNull();

    // should fail because the current value is null
    AssertObject(null).IsNotNull();
```
{% endtab %}
{% endtabs %}

### is_same
Verifies that the current value is the same as the given one.
{% tabs assert-obj-is_same %}
{% tab assert-obj-is_same GdScript %}
```ruby
    func assert_object(<current>).is_same(<expected>) -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    var obj1 = Node.new()
    var obj2 = obj1
    var obj3 = obj1.duplicate()
    assert_object(obj1).is_same(obj1)
    assert_object(obj1).is_same(obj2)
    assert_object(obj2).is_same(obj1)

    # should fail because because the current is not same instance as expected value
    assert_object(null).is_same(obj1)
    assert_object(obj1).is_same(obj3)
    assert_object(obj3).is_same(obj1)
    assert_object(obj3).is_same(obj2)
```
{% endtab %}
{% tab assert-obj-is_same C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsSame();
```
```cs
    // this assertion succeeds
    var obj1 = new Godot.Node();
    var obj2 = obj1;
    var obj3 = obj1.Duplicate();
    AssertObject(obj1).IsSame(obj1);
    AssertObject(obj1).IsSame(obj2);
    AssertObject(obj2).IsSame(obj1);

    // should fail because because the current is not same instance as expected value
    AssertObject(null).IsSame(obj1);
    AssertObject(obj1).IsSame(obj3);
    AssertObject(obj3).IsSame(obj1);
    AssertObject(obj3).IsSame(obj2);
```
{% endtab %}
{% endtabs %}

### is_not_same
Verifies that the current value is not the same as the given one.
{% tabs assert-obj-is_not_same %}
{% tab assert-obj-is_not_same GdScript %}
```ruby
    func assert_object(<current>).is_not_same(<expected>) -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    var obj1 = Node.new()
    var obj2 = obj1
    var obj3 = obj1.duplicate()
    assert_object(null).is_not_same(obj1)
    assert_object(obj1).is_not_same(obj3)
    assert_object(obj3).is_not_same(obj1)
    assert_object(obj3).is_not_same(obj2)

    # should fail because because the current is the same instance as expected value
    assert_object(obj1).is_not_same(obj1)
    assert_object(obj1).is_not_same(obj2)
    assert_object(obj2).is_not_same(obj1)
```
{% endtab %}
{% tab assert-obj-is_not_same C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsNotSame();
```
```cs
    // this assertion succeeds
    var obj1 = new Godot.Node();
    var obj2 = obj1;
    var obj3 = obj1.Duplicate();
    AssertObject(null).IsNotSame(obj1);
    AssertObject(obj1).IsNotSame(obj3);
    AssertObject(obj3).IsNotSame(obj1);
    AssertObject(obj3).IsNotSame(obj2);

    // should fail because because the current is the same instance as expected value
    AssertObject(obj1).IsNotSame(obj1)
    AssertObject(obj1).IsNotSame(obj2)
    AssertObject(obj2).IsNotSame(obj1)
```
{% endtab %}
{% endtabs %}

### is_instanceof
Verifies that the current value is an instance of the given type.
{% tabs assert-obj-is_instanceof %}
{% tab assert-obj-is_instanceof GdScript %}
```ruby
    func assert_object(<current>).is_instanceof(<expected>) -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    assert_object(Path.new()).is_instanceof(Node)

    # should fail because the current is not a instance of class Tree
    assert_object(Path.new()).is_instanceof(Tree)
```
{% endtab %}
{% tab assert-obj-is_instanceof C# %}
```cs
    public static IObjectAssert AssertObject(<current>).IsInstanceOf<Type>();
```
```cs
    // this assertion succeeds
    AssertObject(new Godot.Path()).IsInstanceOf<Node>();

    // should fail because the current is not a instance of class Tree
    AssertObject(new Godot.Path()).IsInstanceOf<Tree>();
```
{% endtab %}
{% endtabs %}

### is_not_instanceof
Verifies that the current value is not an instance of the given type.
{% tabs assert-obj-is_not_instanceof %}
{% tab assert-obj-is_not_instanceof GdScript %}
```ruby
    func assert_object(<current>).is_not_instanceof(<expected>) -> GdUnitObjectAssert
```
```ruby
    # this assertion succeeds
    assert_object(Path.new()).is_not_instanceof(Tree)

    # should fail because Path is a instance of class Node (Path < Spatial < Node < Object)
    assert_object(Path.new()).is_not_instanceof(Node)
```
{% endtab %}
{% tab assert-obj-is_not_instanceof C# %}
```cs
     public static IObjectAssert AssertObject(<current>).IsNotInstanceOf<Type>();
```
```cs
    // this assertion succeeds
    AssertObject(new Godot.Path()).IsNotInstanceOf<Tree>();

    // should fail because Path is a instance of class Node (Path < Spatial < Node < Object)
    AssertObject(new Godot.Path()).IsNotInstanceOf<Node>();
```
{% endtab %}
{% endtabs %}