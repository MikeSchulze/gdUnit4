---
layout: default
title: Boolean Assert
parent: Asserts
nav_order: 2
---

# Boolean Assertions

An assertion tool to verify boolean values.

{% tabs assert-bool %}
{% tab assert-bool GdScript %}
**GdUnitBoolAssert**<br>

|Function|Description|
|--- | --- |
|[is_true](/gdUnit3/asserts/assert-bool/#is_true)| Verifies that the current value is true.|
|[is_false](/gdUnit3/asserts/assert-bool/#is_false)| Verifies that the current value is false.|
|[is_equal](/gdUnit3/asserts/assert-bool/#is_equal)| Verifies that the current value is equal to the given one.|
|[is_not_equal](/gdUnit3/asserts/assert-bool/#is_not_equal)| Verifies that the current value is not equal to the given one.|
{% endtab %}
{% tab assert-bool C# %}
**IBoolAssert**<br>

|Function|Description|
|--- | --- |
|[IsTrue](/gdUnit3/asserts/assert-bool/#is_true)| Verifies that the current value is true.|
|[IsFalse](/gdUnit3/asserts/assert-bool/#is_false)| Verifies that the current value is false.|
|[IsEqual](/gdUnit3/asserts/assert-bool/#is_equal)| Verifies that the current value is equal to the given one.|
|[IsNotEqual](/gdUnit3/asserts/assert-bool/#is_not_equal)| Verifies that the current value is not equal to the given one.|
{% endtab %}
{% endtabs %}

---
## Boolean Assert Examples

### is_true
Verifies that the current value is true.

{% tabs assert-bool-is_true %}
{% tab assert-bool-is_true GdScript %}
```ruby
    func assert_str(<current>).is_true() -> GdUnitBoolAssert
```
```ruby
    # this assertion succeeds
    assert_bool(true).is_true()

    # this assertion fails because the value is false and not true
    assert_bool(false).is_true()
```
{% endtab %}
{% tab assert-bool-is_true C# %}
```cs
    public static IBoolAssert AssertThat(<current>).IsTrue()
```
```cs
    // this assertion succeeds
    AssertThat(true).IsTrue();

    // this assertion fails because the value is false and not true
    AssertThat(false).IsTrue();
```
{% endtab %}
{% endtabs %}

### is_false
Verifies that the current value is false.
{% tabs assert-bool-is_false %}
{% tab assert-bool-is_false GdScript %}
```ruby
    func assert_bool(<current>).is_false() -> GdUnitBoolAssert
```
```ruby
    # this assertion succeeds
    assert_bool(false).is_false()

    # this assertion fails because the value is true and not false
    assert_bool(true).is_false()
```
{% endtab %}
{% tab assert-bool-is_false C# %}
```cs
    public static IBoolAssert AssertThat(<current>).IsFalse();
```
```cs
    // this assertion succeeds
    AssertThat(false).IsFalse();

    // this assertion fails because the value is true and not false
    AssertThat(true).IsFalse();
```
{% endtab %}
{% endtabs %}


### is_equal
Verifies that the current value is equal to the given one.
{% tabs assert-bool-is_equal %}
{% tab assert-bool-is_equal GdScript %}
```ruby
    func assert_str(<current>).is_equal(<expected>) -> GdUnitBoolAssert
```
```ruby
    # this assertion succeeds
    assert_bool(false).is_equal(false)

    # this assertion fails because the value is false and not true
    assert_bool(false).is_equal(true)
```
{% endtab %}
{% tab assert-bool-is_equal C# %}
```cs
    public static IBoolAssert AssertThat(<current>).IsEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(false).IsEqual(false);

    // this assertion fails because the value is false and not true
    AssertThat(false).IsEqual(true);
```
{% endtab %}
{% endtabs %}


### is_not_equal
Verifies that the current value is not equal to the given one.
{% tabs assert-bool-is_not_equal %}
{% tab assert-bool-is_not_equal GdScript %}
```ruby
    func assert_str(<current>).is_not_equal(<expected>) -> GdUnitBoolAssert
```
```ruby
    # this assertion succeeds
    assert_bool(false).is_not_equal(true)

    # this assertion fails because the value is false and should not be false
    assert_bool(false).is_not_equal(false)
```
{% endtab %}
{% tab assert-bool-is_not_equal C# %}
```cs
    public static IBoolAssert AssertThat(<current>).IsNotEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(false).IsNotEqual(true);

    // this assertion fails because the value is false and should not be false
    AssertThat(false).IsNotEqual(false);
```
{% endtab %}
{% endtabs %}