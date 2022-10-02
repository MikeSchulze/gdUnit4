---
layout: default
title: Asserts
nav_order: 1
has_children: true
---

# Asserts

GdUnit3 is providing a set of assertions where give you helpful error messages and improves yor test code readability. Assertions are type organized and supports fluent syntax writing.<br>
The pattern for using asserts is defined as `assert_<type>(<current>).<comparison function>([expected])`.<br>
If you don't know the type of the current value, use the generic `assert_that(<current>)` instead.<br>

---

{% tabs assert-example %}
{% tab assert-example GdScript %}
Asserts are restricted by GdScript behavior and therefore do not fully support generics, i.e. you should prefer to use assert by type.<br>
That is, you must use **assert_str** for **string**, for example.
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

func test_hello_world() -> void:
    # using type save assert
    assert_str("Hello world").is_equal("Hello world")
    # using the common assert
    assert_that("Hello world").is_equal("Hello world")
```
{% endtab %}
{% tab assert-example C# %}
The C# assert are smart and switch to the equivalent assert implementation by auto-typing and should also be used preferentially.<br>
Alternatively, you can use the typed asserts if you want to<br>
To use the assert you have to import it via "static GdUnit3.Assertions".
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        [TestCase]
        public void HelloWorld()
        {
            AssertThat("Hello world").IsEqual("Hello world");
            // using explicit the typed version
            AssertString("Hello world").IsEqual("Hello world");
        }
    }
}
```
{% endtab %}
{% endtabs %}

---

{% include advice.html 
content="You should use the fluent syntax to keep your tests clearer"
%}

{% tabs assert-fluent-example %}
{% tab assert-fluent-example GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

# A bad example for the multiple use of `assert_str`.
func test_hello_world() -> void:
    var current := "Hello World"
    assert_str(current).is_equal("Hello World")
    assert_str(current).contains("World")
    assert_str(current).not_contains("Green")

# A good example of using fluent syntax to write more readable tests
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

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        // A bad example for the multiple use of `AssertThat`.
        [TestCase]
        public void HelloWorld()
        {
            string current = "Hello World";
            AssertThat(current).IsEqual("Hello World");
            AssertThat(current).Contains("World");
            AssertThat(current).NotContains("Green");
        }

        // A good example of using fluent syntax to write more readable tests
        [TestCase]
        public void HelloWorldFluent()
        {
            AssertThat("Hello World")
                .IsEqual("Hello World")
                .Contains("World")
                .NotContains("Green");
        }
    }
}    
```
{% endtab %}
{% endtabs %}


---

## The Generic Assert

{% tabs assert-that-types %}
{% tab assert-that-types GdScript %}
Can be used for all types and gives you access to the basic test functions of GdUnit Assert.<br>
However, I recommend to always use the type-safe Assert, because GdScript is not type-safe.

|Assert|Type|
|--|--|
|[assert_that](/gdUnit3/asserts/assert-that/)| auto typing|
{% endtab %}
{% tab assert-that-types C# %}
The C# assert are smart and switch to the equivalent assert implementation by auto-typing and should also be used preferentially.<br>

|Assert|Type|
|--|--|
|[AssertThat](/gdUnit3/asserts/assert-that/)| auto typing|
{% endtab %}
{% endtabs %}

---

## The Basic Build-In Type Asserts

{% tabs assert-basic-types %}
{% tab assert-basic-types GdScript %}
|Assert|Type|
|--|--|
|[assert_str](/gdUnit3/asserts/assert-string/) | string |
|[assert_bool](/gdUnit3/asserts/assert-bool/) | bool |
|[assert_int](/gdUnit3/asserts/assert-integer/) | int |
|[assert_float](/gdUnit3/asserts/assert-float/) | float |
{% endtab %}
{% tab assert-basic-types C# %}
|Assert|Type|
|--|--|
|[IStringAssert](/gdUnit3/asserts/assert-string/) | string |
|[IBoolAssert](/gdUnit3/asserts/assert-bool/) | bool |
|[INumberAssert](/gdUnit3/asserts/assert-number/) | number (sbyte,byte,short,ushort,int,uint,long,ulong,float,double,decimal) |
{% endtab %}
{% endtabs %}
For more details about Build-In types click here 
[Godot Build-In Types](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#basic-built-in-types){:target="_blank"}

---

## Container Built-In Type Asserts 

{% tabs assert-container-types %}
{% tab assert-container-types GdScript %}
|Assert|Type|
|--|--|
|[assert_array](/gdUnit3/asserts/assert-array/) | Array, PoolByteArray, PoolIntArray, PoolRealArray, PoolStringArray, PoolVector2Array, PoolVector3Array, PoolColorArray |
|[assert_dict](/gdUnit3/asserts/assert-dictionary/) | Dictionary |
{% endtab %}
{% tab assert-container-types C# %}
|Assert|Type|
|--|--|
|[IEnumerableAssert](/gdUnit3/asserts/assert-array/) | IEnumerable |
|[IDictionaryAssert](/gdUnit3/asserts/assert-dictionary/) | IDictionary |
{% endtab %}
{% endtabs %}

For more details about Build-In types click here
[Container built-in types](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#container-built-in-types){:target="_blank"}

---

## Engine Build-In Type Asserts

{% tabs assert-engine-types %}
{% tab assert-engine-types GdScript %}
|Type|Assert|
|--|--|
|[assert_object](/gdUnit3/asserts/assert-object/) | Object|
|[assert_vector2](/gdUnit3/asserts/assert-vector2/) | Vector2|
|[assert_vector3](/gdUnit3/asserts/assert-vector3/) | Vector3|
|[assert_file](/gdUnit3/asserts/assert-file/) | File|
{% endtab %}
{% tab assert-engine-types C# %}
|Type|Assert|
|--|--|
|[IObjectAssert](/gdUnit3/asserts/assert-object/) | Godot.Object, System.object|
|[IVector2Assert](/gdUnit3/asserts/assert-vector2/) | Godot.Vector2|
|[IVector3Assert](/gdUnit3/asserts/assert-vector3/) | Godot.Vector3|
{% endtab %}
{% endtabs %}

---