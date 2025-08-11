---
layout: default
title: Asserts
nav_order: 10
has_children: true
has_toc: false
---

# Assertions

## Definition

Test assertions are conditions used in automated tests to check whether an expected result or behavior in a software application has been achieved.
They are used to validate that the output of a test matches the expected result, and to identify any discrepancies or bugs in the application.
Test assertions can be used for a variety of purposes, such as verifying the correctness of calculations, checking the behavior of user interfaces,
or ensuring that data is properly stored and retrieved.
Test assertions typically involve comparing actual results with expected results using comparison operators, such as equal to, greater than, less than, etc.
If the assertion fails, it means that the test has identified a problem or bug in the application,
and further investigation is needed to determine the cause and fix the issue.

---

## How GdUnit Asserts compares Objects

In GdUnit, asserts generally compare objects based on parameter equality. This means that two objects of different instances are considered equal
if they are of the same type and have the same parameter values.

For object reference comparison, GdUnit provides separate validation functions such as `is_same` and `is_not_same`, as well as assert-specific
functions that handle reference comparison, such as `contains_same` or `not_contains_same`.
These functions allow you to specifically check if two objects refer to the same instance or not.

Here is an example of using assert to compare objects:

```ruby
extends GdUnitTestSuite

class TestClass:
 var _value :int
 
 func _init(value :int):
  _value = value


func test_typ_and_parameter_comparison():
 var obj1 = TestClass.new(1)
 var obj2 = TestClass.new(1)
 var obj3 = TestClass.new(2)
  
 # Using is_equal to check if obj1 and obj2 are equal but not same
 assert_object(obj1).is_equal(obj2)
  
 # Using is_not_equal to check if obj1 and obj3 do not equal, the value are different
 assert_object(obj1).is_not_equal(obj3)


func test_object_reference_comparison():
 var obj1 = TestClass.new(1)
 var obj2 = obj1
 var obj3 = TestClass.new(2)
  
 # Using is_same to check if obj1 and obj2 refer to the same instance
 assert_object(obj1).is_same(obj2)
  
 # Using is_not_same to check if obj1 and obj3 do not refer to the same instance
 assert_object(obj1).is_not_same(obj3)

```

---

## How to use GdUnit assets to verify things

GdUnit4 provides a set of assertions that give you helpful error messages and improve the readability of your test code.
Assertions are organized by type and support fluent syntax writing.<br>
The pattern for using asserts is defined as `assert_<type>(<current>).<comparison function>([expected])`.
If you don't know the type of the current value, use the generic `assert_that(<current>)` instead.

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
The C# assert is smart and switches to the equivalent assert implementation by auto-typing and should also be used preferentially.
Alternatively, you can use the typed asserts if you want to. To use the assert, you have to import it via `static GdUnit4.Assertions`.

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

## Use Fail Fast with Multiple Assertions

When you have multiple assertions in a single test case, it’s important to consider using fail fast techniques to avoid unnecessary test execution
and get clearer failure reports.
In debug mode, accessing properties on null objects will cause the debugger to break with runtime errors,
stopping test execution unexpectedly.

For more detailed information about fail fast techniques, see [How to fail fast](/gdUnit4/testing/first-test/#multiple-assertions-fail-fast).

---

## How to Override the Failure Message

By default, GdUnit generates a failure report based on the used assert, according to the expected vs. current value scheme.
However, in some cases, the default failure message may not be specific enough or helpful to the reader.
In those cases, you can override the default failure message using the **override_failure_message function**.

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

The generic assert, assert_that (in GdScript) and AssertThat (in C#), can be used for all types and gives you access to the basic test functions
of GdUnit Assert.<br>
However, it is recommended to use the type-safe asserts whenever possible to ensure type safety in your tests.

|Assert|Type|
|--|--|
|[assert_that](/gdUnit4/testing/assert-that/)| auto typing (not type-safe) |
|[AssertThat](/gdUnit4/testing/assert-that/)| auto typing (type-safe) |

---

## The Basic Build-In Type Asserts

{% tabs assert-basic-types %}
{% tab assert-basic-types GdScript %}

|Assert|Type|
|--|--|
|[assert_str](/gdUnit4/testing/assert-string/) | string |
|[assert_bool](/gdUnit4/testing/assert-bool/) | bool |
|[assert_int](/gdUnit4/testing/assert-integer/) | int |
|[assert_float](/gdUnit4/testing/assert-float/) | float |

{% endtab %}
{% tab assert-basic-types C# %}

|Assert|Type|
|--|--|
|[IStringAssert](/gdUnit4/testing/assert-string/) | string |
|[IBoolAssert](/gdUnit4/testing/assert-bool/) | bool |
|[INumberAssert](/gdUnit4/testing/assert-number/) | number (sbyte,byte,short,ushort,int,uint,long,ulong,float,double,decimal) |

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
|[assert_array](/gdUnit4/testing/assert-array/) | All Godot Array Types |
|[assert_dict](/gdUnit4/testing/assert-dictionary/) | Dictionary |

{% endtab %}
{% tab assert-container-types C# %}

|Assert|Type|
|--|--|
|[IEnumerableAssert](/gdUnit4/testing/assert-array/) | IEnumerable |
|[IDictionaryAssert](/gdUnit4/testing/assert-dictionary/) | IDictionary |

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
|[assert_object](/gdUnit4/testing/assert-object/) | Object|
|[assert_vector](/gdUnit4/testing/assert-vector/) | All Godot Vector Types |
|[assert_file](/gdUnit4/testing/assert-file/) | File|

{% endtab %}
{% tab assert-engine-types C# %}

|Type|Assert|
|--|--|
|[IObjectAssert](/gdUnit4/testing/assert-object/) | Godot.Object, System.object|
|[IVectorAssert](/gdUnit4/testing/assert-vector/) | Godot.Vector2|

{% endtab %}
{% endtabs %}

---

## Engine Tool Asserts

{% tabs assert-tool-types %}
{% tab assert-tool-types GdScript %}

|Type|Assert|
|--|--|
|[assert_signal](/gdUnit4/testing/assert-signal/) | Signals |
|[assert_error](/gdUnit4/testing/assert-error/) | Godot Errors |

{% endtab %}
{% tab assert-tool-types C# %}

|Type|Assert|
|--|--|
|[ISignalAssert](/gdUnit4/testing/assert-signal/) | Signals |
|[IErrorAssert](/gdUnit4/testing/assert-error/) | Godot Errors |

{% endtab %}
{% endtabs %}
