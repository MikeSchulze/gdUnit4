---
layout: default
title: Asserts
nav_order: 1
has_children: true
---

# Assertions

## Definition
Test assertions are conditions used in automated tests to check whether an expected result or behavior in a software application has been achieved. They are used to validate that the output of a test matches the expected result, and to identify any discrepancies or bugs in the application. Test assertions can be used for a variety of purposes, such as verifying the correctness of calculations, checking the behavior of user interfaces, or ensuring that data is properly stored and retrieved. Test assertions typically involve comparing actual results with expected results using comparison operators, such as equal to, greater than, less than, etc. If the assertion fails, it means that the test has identified a problem or bug in the application, and further investigation is needed to determine the cause and fix the issue.

GdUnit4 provides a set of assertions that give you helpful error messages and improve the readability of your test code. Assertions are organized by type and support fluent syntax writing.<br>
The pattern for using asserts is defined as `assert_<type>(<current>).<comparison function>([expected])`. If you don't know the type of the current value, use the generic `assert_that(<current>)` instead.



Here is an example:
{% tabs assert-example %}
{% tab assert-example GdScript %}
Asserts are restricted by GdScript behavior and therefore do not fully support generics. Therefore, you should prefer to use assert by type.

For example, use **assert_str** for string.
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

func test_hello_world() -> void:
    # Using type save assert
    assert_str("Hello world").is_equal("Hello world")
    # Using the generic assert
    assert_that("Hello world").is_equal("Hello world")
```
{% endtab %}
{% tab assert-example C# %}
The C# assert is smart and switches to the equivalent assert implementation by auto-typing and should also be used preferentially. Alternatively, you can use the typed asserts if you want to. To use the assert, you have to import it via `static GdUnit4.Assertions`.
```cs
using GdUnit4;
using static GdUnit4.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        [TestCase]
        public void HelloWorld()
        {
            AssertThat("Hello world").IsEqual("Hello world");
            // Using explicit the typed version
            AssertString("Hello world").IsEqual("Hello world");
        }
    }
}
```
{% endtab %}
{% endtabs %}


{% include advice.html 
content="You should use the fluent syntax to keep your tests clearer."
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
using GdUnit4;
using static GdUnit4.Assertions;

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

## How to Override the Failure Message
By default, GdUnit generates a failure report based on the used assert, according to the expected vs. current value scheme. However, in some cases, the default failure message may not be specific enough or helpful to the reader. In those cases, you can override the default failure message using the **override_failure_message function**.

To use this function, simply call it on the assertion and pass in a custom failure message as a string. For example:
```ruby
    func test_custom_failure_message() -> void:
        assert_str("Hello World")\
            # Override the default failure message with a custom one
            .override_failure_message("This is a customized failure message!")\
            # Let the test fail
            .is_empty()
```

---

## The Generic Assert
The generic assert, assert_that (in GdScript) and AssertThat (in C#), can be used for all types and gives you access to the basic test functions of GdUnit Assert.<br> However, it is recommended to use the type-safe asserts whenever possible to ensure type safety in your tests.

|Assert|Type|
|--|--|
|[assert_that](/gdUnit4/asserts/assert-that/)| auto typing (not type-safe) |
|[AssertThat](/gdUnit4/asserts/assert-that/)| auto typing (type-safe) |

---

## The Basic Build-In Type Asserts

{% tabs assert-basic-types %}
{% tab assert-basic-types GdScript %}
|Assert|Type|
|--|--|
|[assert_str](/gdUnit4/asserts/assert-string/) | string |
|[assert_bool](/gdUnit4/asserts/assert-bool/) | bool |
|[assert_int](/gdUnit4/asserts/assert-integer/) | int |
|[assert_float](/gdUnit4/asserts/assert-float/) | float |
{% endtab %}
{% tab assert-basic-types C# %}
|Assert|Type|
|--|--|
|[IStringAssert](/gdUnit4/asserts/assert-string/) | string |
|[IBoolAssert](/gdUnit4/asserts/assert-bool/) | bool |
|[INumberAssert](/gdUnit4/asserts/assert-number/) | number (sbyte,byte,short,ushort,int,uint,long,ulong,float,double,decimal) |
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
|[assert_array](/gdUnit4/asserts/assert-array/) | for all Godot Array types |
|[assert_dict](/gdUnit4/asserts/assert-dictionary/) | Dictionary |
{% endtab %}
{% tab assert-container-types C# %}
|Assert|Type|
|--|--|
|[IEnumerableAssert](/gdUnit4/asserts/assert-array/) | IEnumerable |
|[IDictionaryAssert](/gdUnit4/asserts/assert-dictionary/) | IDictionary |
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
|[assert_object](/gdUnit4/asserts/assert-object/) | Object|
|[assert_vector2](/gdUnit4/asserts/assert-vector2/) | Vector2 |
|[assert_vector3](/gdUnit4/asserts/assert-vector3/) | Vector3 |
|[assert_file](/gdUnit4/asserts/assert-file/) | File|
{% endtab %}
{% tab assert-engine-types C# %}
|Type|Assert|
|--|--|
|[IObjectAssert](/gdUnit4/asserts/assert-object/) | Godot.Object, System.object|
|[IVector2Assert](/gdUnit4/asserts/assert-vector2/) | Godot.Vector2|
|[IVector3Assert](/gdUnit4/asserts/assert-vector3/) | Godot.Vector3|
|[IVector4Assert](/gdUnit4/asserts/assert-vector4/) | Godot.Vector4|
{% endtab %}
{% endtabs %}

---