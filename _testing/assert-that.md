---
layout: default
title: AssertThat
parent: Asserts
nav_order: 20
---

# AssertThat Assertions

The assert_that is useful when you don't know the type of the value you want to test.<br>
You can use this assertion on all types you want, but for better readability of the test (GdScript) I prefer to use type store asserts.
For C# you should prefer to use AssertThat, under C# the type of a variable is always known therefore it allows to find the right assert.

---
## AssertThat Example

{% tabs assert-that-example %}
{% tab assert-that-example GdScript %}
Asserts are restricted by GdScript behavior and therefore do not fully support generics, i.e. you should prefer to use assert by type.<br>
```ruby
    func assert_that(<current>)
```
```ruby
    assert_that("This is a test message").is_equal("This is a test message")
    assert_that(23).is_greater(20)
```
{% endtab %}
{% tab assert-that-example C# %}
The C# assert are smart and switch to the equivalent assert implementation by auto-typing and should also be used preferentially.<br>
```cs
    // auto type assertion
    public static IAssertBase<Type> AssertThat(<current>);
```
```cs
    AssertThat("This is a test message").is_equal("This is a test message");
    AssertThat(23).IsGreater(20);
```
{% endtab %}
{% endtabs %}