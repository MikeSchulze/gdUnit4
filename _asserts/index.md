---
layout: default
title: Asserts
nav_order: 1
has_children: true
---

## Asserts

GdUnit3 is providing a set of assertions where give you helpful error messages and improves yor test code readability. Assertions are type organized and supports fluent syntax writing.

The pattern for using asserts is defined as `assert_<type>(<current>).<comparison function>([expected])`.
If you don't know the type of the current value, use the generic `assert_that(<current>)` instead.

On GdScript the asserts are included over `GdUnitTestSuite` for CSharpScripts you have to import by `using static GdUnit3.Assertions;`

{% tabs assert-example %}
{% tab assert-example GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

func test_hello_world() -> void:
    # using type save assert
    assert_str("Hello world").is_equal("Hello world")
    # using common assert
    assert_that("Hello world").is_equal("Hello world")
```
{% endtab %}
{% tab assert-example C# %}
```cs
using GdUnit3;
using static GdUnit3.Assertions;

[TestSuite]
public class ExampleTest
{
    [TestCase]
    public void HelloWorld()
    {
        // using type save assert
        AssertString("Hello world").IsEqual("Hello world");
        // using common assert
        AssertThat("Hello world").IsEqual("Hello world");
    }
}
```
{% endtab %}
{% endtabs %}


### Using fluent syntax to write compact tests.
{% tabs assert-fluent-example %}
{% tab assert-fluent-example GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

# bad example of using many times `assert_str`
func test_hello_world() -> void:
    var current := "Hello World"
    assert_str(current).is_equal("Hello World")
    assert_str(current).contains("World")
    assert_str(current).not_contains("Green")

# example of using fluent syntax to write better readable tests
func test_hello_world_fluent() -> void:
    assert_str("Hello World")\
    	.is_equal("Hello World")\
    	.contains("World")\
    	.not_contains("Green")
```
{% endtab %}
{% tab assert-fluent-example C# %}
```cs
using GdUnit3;
using static GdUnit3.Assertions;

[TestSuite]
public class TestPersionTest
{
    // bad example of using many times `AssertString`
    [TestCase]
    public void HelloWorld()
    {
        string current = "Hello World";
        AssertString(current).IsEqual("Hello World");
        AssertString(current).Contains("World");
        AssertString(current).NotContains("Green");
    }

    // example of using fluent syntax to write better readable tests
    [TestCase]
    public void HelloWorldFluent()
    {
        AssertString("Hello World")
            .IsEqual("Hello World")
            .Contains("World")
            .NotContains("Green");
    }
}
```
{% endtab %}
{% endtabs %}


### Basic Build-In Type Asserts

{% tabs assert-basic-types %}
{% tab assert-basic-types GdScript %}
|Assert|Type|
|[assert_str](/gdUnit3/asserts/assert-string/) | string |
|[assert_bool](/gdUnit3/asserts/assert-bool/) | bool |
|[assert_int](/gdUnit3/asserts/assert-integer/) | int |
|[assert_float](/gdUnit3/asserts/assert-float/) | float |
{% endtab %}
{% tab assert-basic-types C# %}
|Assert|Type|
|[AssertString](/gdUnit3/asserts/assert-string/) | string |
|[AssertBool](/gdUnit3/asserts/assert-bool/) | bool |
|[AssertInt](/gdUnit3/asserts/assert-integer/) | int |
|[AssertFloat](/gdUnit3/asserts/assert-float/) | double |
{% endtab %}
{% endtabs %}
For more details about Build-In types click here 
[Godot Build-In Types](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#basic-built-in-types){:target="_blank"}


### Container Built-In Type Asserts 

{% tabs assert-container-types %}
{% tab assert-container-types GdScript %}
|Assert|Type|
|[assert_array](/gdUnit3/asserts/assert-array/) | Array, PoolByteArray, PoolIntArray, PoolRealArray, PoolStringArray, PoolVector2Array, PoolVector3Array, PoolColorArray |
|[assert_dict](/gdUnit3/asserts/assert-dictionary/) | Dictionary |
{% endtab %}
{% tab assert-container-types C# %}
|Assert|Type|
|[AssertArray](/gdUnit3/asserts/assert-array/) | IEnumerable |
|[AssertDictionary](/gdUnit3/asserts/assert-dictionary/) | Dictionary |
{% endtab %}
{% endtabs %}

For more details about Build-In types click here
[Container built-in types](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#container-built-in-types){:target="_blank"}

### Engine Build-In Type Asserts

{% tabs assert-engine-types %}
{% tab assert-engine-types GdScript %}
|Type|Assert|
|[assert_object](/gdUnit3/asserts/assert-object/) | Object|
|[assert_vector2](/gdUnit3/asserts/assert-vector2/) | Vector2|
|[assert_vector3](/gdUnit3/asserts/assert-vector3/) | Vector3|
|[assert_file](/gdUnit3/asserts/assert-file/) | File|
{% endtab %}
{% tab assert-engine-types C# %}
|Type|Assert|
|[AssertObject](/gdUnit3/asserts/assert-object/) | Godot.Object, System.object|
|[AssertVector2](/gdUnit3/asserts/assert-vector2/) | Godot.Vector2|
|[AssertVector3](/gdUnit3/asserts/assert-vector3/) | Godot.Vector3|
|[AssertFile](/gdUnit3/asserts/assert-file/) | File|
{% endtab %}
{% endtabs %}

### The Common Assert

{% tabs assert-that-types %}
{% tab assert-that-types GdScript %}
|Assert|Type|
|[assert_that](/gdUnit3/asserts/assert-that/)| auto typing|
{% endtab %}
{% tab assert-that-types C# %}
|Assert|Type|
|[AssertThat](/gdUnit3/asserts/assert-that/)| auto typing|
{% endtab %}
{% endtabs %}

Can be used for all types and gives you access to the basic test functions of GdUnit Assert. However, I recommend to always use the type-safe Assert for *GdScripts*, because GdScript is not type-safe.

