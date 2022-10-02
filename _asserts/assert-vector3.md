---
layout: default
title: Vector3 Assert
parent: Asserts
nav_order: 9
---

# Vector3 Assertions

An assertion tool to verify Vector3 values.

{% tabs assert-vec3-overview %}
{% tab assert-vec3-overview GdScript %}
**GdUnitVector3Assert**<br>

|Function|Description|
|--- | --- |
|[is_null](/gdUnit3/asserts/assert-vector3/#is_null) | Verifies that the current value is null.|
|[is_not_null](/gdUnit3/asserts/assert-vector3/#is_not_null) | Verifies that the current value is not null.|
|[is_equal](/gdUnit3/asserts/assert-vector3/#is_equal) | Verifies that the current value is equal to the given one.|
|[is_not_equal](/gdUnit3/asserts/assert-vector3/#is_not_equal) | Verifies that the current value is not equal to the given one.|
|[is_equal_approx](/gdUnit3/asserts/assert-vector3/#is_equal_approx) | Verifies that the current and expected value are approximately equal.|
|[is_less](/gdUnit3/asserts/assert-vector3/#is_less) | Verifies that the current value is less than the given one.|
|[is_less_equal](/gdUnit3/asserts/assert-vector3/#is_less_equal) | Verifies that the current value is less than or equal the given one.|
|[is_greater](/gdUnit3/asserts/assert-vector3/#is_greater) | Verifies that the current value is greater than the given one.|
|[is_greater_equal](/gdUnit3/asserts/assert-vector3/#is_greater_equal) | Verifies that the current value is greater than or equal the given one.|
|[is_between](/gdUnit3/asserts/assert-vector3/#is_between) | Verifies that the current value is between the given boundaries (inclusive).|
|[is_not_between](/gdUnit3/asserts/assert-vector3/#is_not_between) | Verifies that the current value is not between the given boundaries (inclusive).|
{% endtab %}
{% tab assert-vec3-overview C# %}
**IVector3Assert**<br>

|Function|Description|
|--- | --- |
|[IsNull](/gdUnit3/asserts/assert-vector3/#is_null) | Verifies that the current value is null.|
|[IsNotNull](/gdUnit3/asserts/assert-vector3/#is_not_null) | Verifies that the current value is not null.|
|[IsEqual](/gdUnit3/asserts/assert-vector3/#is_equal) | Verifies that the current value is equal to the given one.|
|[IsNotEqual](/gdUnit3/asserts/assert-vector3/#is_not_equal) | Verifies that the current value is not equal to the given one.|
|[IsEqualApprox](/gdUnit3/asserts/assert-vector3/#is_equal_approx) | Verifies that the current and expected value are approximately equal.|
|[IsLess](/gdUnit3/asserts/assert-vector3/#is_less) | Verifies that the current value is less than the given one.|
|[IsLessEqual](/gdUnit3/asserts/assert-vector3/#is_less_equal) | Verifies that the current value is less than or equal the given one.|
|[IsGreater](/gdUnit3/asserts/assert-vector3/#is_greater) | Verifies that the current value is greater than the given one.|
|[IsGreaterEqual](/gdUnit3/asserts/assert-vector3/#is_greater_equal) | Verifies that the current value is greater than or equal the given one.|
|[IsBetween](/gdUnit3/asserts/assert-vector3/#is_between) | Verifies that the current value is between the given boundaries (inclusive).|
|[IsNotBetween](/gdUnit3/asserts/assert-vector3/#is_not_between) | Verifies that the current value is not between the given boundaries (inclusive).|
{% endtab %}
{% endtabs %}

---
## Vector3 Assert Examples

### is_equal
Verifies that the current value is equal to the given one.
{% tabs assert-vec3-is_equal %}
{% tab assert-vec3-is_equal GdScript %}
```ruby
    func assert_vector3(<current>).is_equal(<expected>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_equal(Vector3(1.1, 1.2, 1.0))

    # this assertion fails because part y of the vector 1.2 are not equal to 1.3
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_equal(Vector3(1.1, 1.3, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_equal C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(Vector3.One).IsEqual(Vector3.One);

    // should fail because is NOT equal
    AssertThat(Vector3.One).IsEqual(new Vector3(1.2f, 1.000001f, 1f);
```
{% endtab %}
{% endtabs %}



### is_not_equal
Verifies that the current value is not equal to the given one.
{% tabs assert-vec3-is_not_equal %}
{% tab assert-vec3-is_not_equal GdScript %}
```ruby
    func assert_vector3(<current>).is_not_equal(<expected>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_not_equal(Vector3(1.1, 1.3, 1.0))

    # this assertion fails because both vectors are equal
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_not_equal(Vector3(1.1, 1.2, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_not_equal C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsNotEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(new Vector3(1.2f, 1.000001f, 1f)).IsNotEqual(new Vector3(1.2f, 1.000002f, 1f));

    // should fail because is equal
    new Vector3(1.2f, 1.000001f, 1f)).IsNotEqual(new Vector3(1.2f, 1.000001f, 1f);
```
{% endtab %}
{% endtabs %}


### is_equal_approx
Verifies that the current and expected value are approximately equal.
{% tabs assert-vec3-is_equal_approx %}
{% tab assert-vec3-is_equal_approx GdScript %}
```ruby
    func assert_vector3(<current>).is_equal_approx(expected, approx) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(0.996, 0.996, 0.996)).is_equal_approx(Vector3.ONE, Vector3(0.004, 0.004, 0.004))

    # this will fail because the vector is out of approximated range
    assert_vector3(Vector3(1.005, 1, 1)).is_equal_approx(Vector3.ONE, Vector3(0.004, 0.004, 0.004))
```
{% endtab %}
{% tab assert-vec3-is_equal_approx C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsEqualApprox(<expected>, <approx>);
```
```cs
    // this assertion succeeds
    AssertThat(Vector3.One).IsEqualApprox(Vector3.One, new Vector3(0.004f, 0.004f, 0.004f));

    // should fail because is NOT equal approximated
    AssertThat(new Vector3(1.005f, 1f, 1f)).IsEqualApprox(Vector3.One, new Vector3(0.004f, 0.004f, 0.004f));
```
{% endtab %}
{% endtabs %}




### is_less
Verifies that the current value is less than the given one.
{% tabs assert-vec3-is_less %}
{% tab assert-vec3-is_less GdScript %}
```ruby
    func assert_vector3(<current>).is_less(<expected>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3.ZERO.is_less(Vector3.ONE)
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_less(Vector3(1.1, 1.3, 1.0))

    # this assertion fails because both vectors are equal
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_less(Vector3(1.1, 1.2, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_less C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsLess(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(new Vector3(1.2f, 1.000001f, 1f)).IsLess(new Vector3(1.2f, 1.000002f, 1f));

    // should fail because is NOT less is equal
    AssertThat(Vector3.One).IsLess(Vector3.One);
```
{% endtab %}
{% endtabs %}


### is_less_equal
Verifies that the current value is less than or equal the given one.
{% tabs assert-vec3-is_less_equal %}
{% tab assert-vec3-is_less_equal GdScript %}
```ruby
    func assert_vector3(<current>).is_less_equal(<expected>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_less_equal(Vector3(1.1, 1.3, 1.0))
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_less_equal(Vector3(1.1, 1.2, 1.0))

    # this assertion fails because part y 1.3 is not less or equal to 1.2 
    assert_vector3(Vector3(1.1, 1.3, 1.0)).is_less_equal(Vector3(1.1, 1.2, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_less_equal C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsLessEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(new Vector3(1.2f, 1.000001f, 1f)).IsLessEqual(new Vector3(1.2f, 1.000001f, 1f));
    AssertThat(new Vector3(1.2f, 1.000001f, 1f)).IsLessEqual(new Vector3(1.2f, 1.000002f, 1f));

    // should fail because is NOT less or equal
    AssertThat(Vector3.One).IsLessEqual(Vector3.Zero);
```
{% endtab %}
{% endtabs %}


### is_greater
Verifies that the current value is greater than the given one.
{% tabs assert-vec3-is_greater %}
{% tab assert-vec3-is_greater GdScript %}
```ruby
    func assert_vector3(<current>).is_greater(<expected>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.1, 1.3, 1.0)).is_greater(Vector3(1.1, 1.2, 1.0))

    # this assertion fails because both vectors are equal
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_greater(Vector3(1.1, 1.2, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_greater C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsGreater(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(new Vector3(1.2f, 1.000002f, 1f)).IsGreater(new Vector3(1.2f, 1.000001f, 1f));

    // should fail because zero is NOT greater than one
    AssertThat(Vector3.Zero).IsGreater(Vector3.One);
```
{% endtab %}
{% endtabs %}


### is_greater_equal
Verifies that the current value is greater than or equal the given one.
{% tabs assert-vec3-is_greater_equal %}
{% tab assert-vec3-is_greater_equal GdScript %}
```ruby
    func assert_vector3(<current>).is_greater_equal(<expected>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.1, 1.3, 1.0)).is_greater_equal(Vector3(1.1, 1.2, 1.0))
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_greater_equal(Vector3(1.1, 1.2, 1.0))

    # this assertion fails because part y1.2 is less than 1.3
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_greater_equal(Vector3(1.1, 1.3, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_greater_equal C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsGreaterEqual(<expected>);
```
```cs
    // this assertion succeeds
    AssertThat(new Vector3(1.2f, 1.000001f, 1f)).IsGreaterEqual(new Vector3(1.2f, 1.000001f, 1f));
    AssertThat(new Vector3(1.2f, 1.000002f, 1f)).IsGreaterEqual(new Vector3(1.2f, 1.000001f, 1f));

    // should fail because it is NOT greater or equal
   AssertThat(new Vector3(1.2f, 1.000002f, 1f)).IsGreaterEqual(new Vector3(1.2f, 1.000003f, 1f));
```
{% endtab %}
{% endtabs %}


### is_between
Verifies that the current value is between the given boundaries (inclusive).
{% tabs assert-vec3-is_between %}
{% tab assert-vec3-is_between GdScript %}
```ruby
    func assert_vector3(<current>).is_between(<from>, <to>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_between(Vector3(1.1, 1.2, 1.0), Vector3(1.1, 1.3, 1.0))
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_between(Vector3(1.1, 1.1, 1.0), Vector3(1.1, 1.3, 1.0))

    # this assertion fail because the part y 1.2 is not between 1.0 and 1.1
    assert_vector3(Vector3(1.1, 1.2, 1.0)).is_between (Vector3(1.1, 1.0, 1.0), Vector3(1.1, 1.1, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_between C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsBetween(<from>, <to>);
```
```cs
    // this assertion succeeds
    AssertThat(Vector3.Zero).IsBetween(Vector3.Zero, Vector3.One);
    AssertThat(Vector3.One).IsBetween(Vector3.Zero, Vector3.One);

    // should fail because it is NOT between zero and one
    AssertThat(new Vector3(0, -.1f, 1f)).IsBetween(Vector3.Zero, Vector3.One);
```
{% endtab %}
{% endtabs %}


### is_not_between
Verifies that the current value is not between the given boundaries (inclusive).
{% tabs assert-vec3-is_not_between %}
{% tab assert-vec3-is_not_between GdScript %}
```ruby
    func assert_vector3(<current>).is_not_between(<from>, <to>) -> GdUnitVector3Assert
```
```ruby
    # this assertion succeeds
    assert_vector3(Vector3(1.0, 1.0, 1.0)).is_not_between(Vector3(1.1, 1.2, 1.0), Vector3(2.0, 1.0, 1.0))

    # this assertion fail because the vector is between
    assert_vector3(Vector3(1.0, 1.0, 1.0)).is_not_between(Vector3(1.0, 1.0, 1.0), Vector3(2.0, 1.0, 1.0))
```
{% endtab %}
{% tab assert-vec3-is_not_between C# %}
```cs
    public static IVector3Assert AssertThat(Godot.Vector3 current).IsNotBetween(<from>, <to>);
```
```cs
    // this assertion succeeds
    AssertThat(new Vector3(1f, 1.0002f, 1f)).IsNotBetween(Vector3.Zero, Vector3.One);

    // should fail because it is between zero and one
    AssertThat(Vector3.One).IsNotBetween(Vector3.Zero, Vector3.One);
```
{% endtab %}
{% endtabs %}
