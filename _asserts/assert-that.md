---
layout: default
title: AssertThat
parent: Asserts
nav_order: 20
---

## AssertThat Assertions

The assert_that is useful when you don't know the type of the value you want to test. You can use this assertion on all types you want, but for better readability of the test (GdScript) I prefer to use type store asserts.
For C# you should prefer to use AssertThat, under C# the type of a variable is always known therefore it allows to find the right assert.


---
## AssertThat Assert Examples

{% tabs assert-that-example %}
{% tab assert-that-example GdScript %}
```ruby
    func assert_that(<current>)
```
```ruby
    # using type save asserts
    assert_str("This is a test message").is_equal("This is a test message")
    assert_int(23).is_greater(20)

    # can optional replaced by
    assert_that("This is a test message").is_equal("This is a test message")
    assert_that(23).is_greater(20)
```
{% endtab %}
{% tab assert-that-example C# %}
```cs
    // auto type assertion
    public static IAssertBase<Type> AssertThat<Type>(<current>);
```
```cs
    // using type save asserts
    AssertString("This is a test message").IsEqual("This is a test message");
    AssertInt(23).IsGreater(20)

    // sould be replaced by AssertThat
    AssertThat("This is a test message").is_equal("This is a test message");
    AssertThat(23).IsGreater(20);
```
{% endtab %}
{% endtabs %}