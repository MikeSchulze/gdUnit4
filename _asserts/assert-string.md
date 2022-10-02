---
layout: default
title: String Assert
parent: Asserts
nav_order: 1
---

# String Assertions

An assertion tool to verify String values.

{% tabs assert-str-overview %}
{% tab assert-str-overview GdScript %}
**GdUnitStringAssert**<br>

|Function|Description|
|--- | --- |
|[is_null](/gdUnit3/asserts/assert-string/#is_null)| Verifies that the current value is null.|
|[is_not_null](/gdUnit3/asserts/assert-string/#is_not_null)| Verifies that the current value is not null.|
|[is_equal](/gdUnit3/asserts/assert-string/#is_equal) | Verifies that the current String is equal to the given one.|
|[is_equal_ignoring_case](/gdUnit3/asserts/assert-string/#is_equal_ignoring_case) | Verifies that the current String is equal to the given one, ignoring case considerations.|
|[is_not_equal](/gdUnit3/asserts/assert-string/#is_not_equal) | Verifies that the current String is not equal to the given one.|
|[is_not_equal_ignoring_case](/gdUnit3/asserts/assert-string/#is_not_equal_ignoring_case) | Verifies that the current String is not equal to the given one, ignoring case considerations.|
|[is_empty](/gdUnit3/asserts/assert-string/#is_empty) | Verifies that the current String is empty, it has a length of 0.| 
|[is_not_empty](/gdUnit3/asserts/assert-string/#is_not_empty) | Verifies that the current String is not empty, it has a length of minimum 1.|
|[contains](/gdUnit3/asserts/assert-string/#contains) | Verifies that the current String contains the given String.|
|[contains_ignoring_case](/gdUnit3/asserts/assert-string/#contains_ignoring_case) | Verifies that the current String does not contain the given String, ignoring case considerations.|
|[not_contains](/gdUnit3/asserts/assert-string/#not_contains) | Verifies that the current String does not contain the given String.|
|[not_contains_ignoring_case](/gdUnit3/asserts/assert-string/#not_contains_ignoring_case) | Verifies that the current String does not contain the given String, ignoring case considerations.|
|[starts_with](/gdUnit3/asserts/assert-string/#starts_with) | Verifies that the current String starts with the given prefix.|
|[ends_with](/gdUnit3/asserts/assert-string/#ends_with) | Verifies that the current String ends with the given suffix.|
|[has_length](/gdUnit3/asserts/assert-string/#has_length) | Verifies that the current String has the expected length by used comparator.|
{% endtab %}
{% tab assert-str-overview C# %}
**IStringAssert**<br>

|Function|Description|
|--- | --- |
|[IsNull](/gdUnit3/asserts/assert-string/#is_null)| Verifies that the current value is null.|
|[IsNotNull](/gdUnit3/asserts/assert-string/#is_not_null)| Verifies that the current value is not null.|
|[IsEqual](/gdUnit3/asserts/assert-string/#is_equal) | Verifies that the current String is equal to the given one.|
|[IsEqualIgnoringCase](/gdUnit3/asserts/assert-string/#is_equal_ignoring_case) | Verifies that the current String is equal to the given one, ignoring case considerations.|
|[IsNotEqual](/gdUnit3/asserts/assert-string/#is_not_equal) | Verifies that the current String is not equal to the given one.|
|[IsNotEqualIgnoringCase](/gdUnit3/asserts/assert-string/#is_not_equal_ignoring_case) | Verifies that the current String is not equal to the given one, ignoring case considerations.|
|[IsEmpty](/gdUnit3/asserts/assert-string/#is_empty) | Verifies that the current String is empty, it has a length of 0.| 
|[IsNotEmpty](/gdUnit3/asserts/assert-string/#is_not_empty) | Verifies that the current String is not empty, it has a length of minimum 1.|
|[Contains](/gdUnit3/asserts/assert-string/#contains) | Verifies that the current String contains the given String.|
|[ContainsIgnoringCase](/gdUnit3/asserts/assert-string/#contains_ignoring_case) | Verifies that the current String does not contain the given String, ignoring case considerations.|
|[NotContains](/gdUnit3/asserts/assert-string/#not_contains) | Verifies that the current String does not contain the given String.|
|[NotContainsIgnoringCase](/gdUnit3/asserts/assert-string/#not_contains_ignoring_case) | Verifies that the current String does not contain the given String, ignoring case considerations.|
|[StartsWith](/gdUnit3/asserts/assert-string/#starts_with) | Verifies that the current String starts with the given prefix.|
|[EndsWith](/gdUnit3/asserts/assert-string/#ends_with) | Verifies that the current String ends with the given suffix.|
|[HasLength](/gdUnit3/asserts/assert-string/#has_length) | Verifies that the current String has the expected length by used comparator.|
{% endtab %}
{% endtabs %}

---
## String Assert Examples

### is_equal
Verifies that the current String is equal to the given one.
{% tabs assert-str-is_equal %}
{% tab assert-str-is_equal GdScript %}
```ruby
    func assert_str(<current>).is_equal(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a test message").is_equal("This is a test message")

    # this assertion fails because the 'Message' is writen camel case
    assert_str("This is a test message").is_equal("This is a test Message")
```
{% endtab %}
{% tab assert-str-is_equal C# %}
```cs
    public static IStringAssert AssertThat(<current>).IsEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a test message").IsEqual("This is a test message");

    // this assertion fails because the 'Message' is writen camel case
    AssertThat("This is a test message").IsEqual("This is a test Message");
```
{% endtab %}
{% endtabs %}


### is_equal_ignoring_case
Verifies that the current String is equal to the given one, ignoring case considerations.
{% tabs assert-str-is_equal_ignoring_case %}
{% tab assert-str-is_equal_ignoring_case GdScript %}
```ruby
    func assert_str(<current>).is_equal_ignoring_case(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a test message").is_equal_ignoring_case("This is a test Message")

    # this assertion fails because 'test' is missing 
    assert_str("This is a test message").is_equal_ignoring_case("This is a Message")
```
{% endtab %}
{% tab assert-str-is_equal_ignoring_case C# %}
```cs
    public static IStringAssert AssertThat(<current>).IsEqualIgnoringCase(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a test message").IsEqualIgnoringCase("This is a test Message")

    // this assertion fails because 'test' is missing 
    AssertThat("This is a test message").IsEqualIgnoringCase("This is a Message")
```
{% endtab %}
{% endtabs %}

### is_not_equal
Verifies that the current String is not equal to the given one.
{% tabs assert-str-is_not_equal %}
{% tab assert-str-is_not_equal GdScript %}
```ruby
    func assert_str(<current>).is_not_equal(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a test message").is_not_equal("This is a test Message")

    # this assertion fails because the values are equal
    assert_str("This is a test message").is_not_equal("This is a test message")
```
{% endtab %}
{% tab assert-str-is_not_equal C# %}
```cs
    public static IStringAssert AssertThat(<current>).IsNotEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a test message").IsNotEqual("This is a test Message");

    // this assertion fails because the values are equal
    AssertThat("This is a test message").IsNotEqual("This is a test message");
```
{% endtab %}
{% endtabs %}

### is_not_equal_ignoring_case
Verifies that the current String is not equal to the given one, ignoring case considerations.
{% tabs assert-str-is_not_equal_ignoring_case %}
{% tab assert-str-is_not_equal_ignoring_case GdScript %}
```ruby
    func assert_str(<current>).is_not_equal_ignoring_case(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a test message").is_not_equal_ignoring_case("This is a Message")

    # this assertion fails because the values are equal ignoring camel case
    assert_str("This is a test message").is_not_equal_ignoring_case("This is a test Message")
```
{% endtab %}
{% tab assert-str-is_not_equal_ignoring_case C# %}
```cs
    public static IStringAssert AssertThat(<current>).IsNotEqualIgnoringCase(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a test message").IsNotEqualIgnoringCase("This is a Message");

    // this assertion fails because the values are equal ignoring camel case
    AssertThat("This is a test message").IsNotEqualIgnoringCase("This is a test Message");
```
{% endtab %}
{% endtabs %}


### is_empty
Verifies that the current String is empty, it has a length of 0.
{% tabs assert-str-is_empty %}
{% tab assert-str-is_empty GdScript %}
```ruby
    func assert_str(<current>).is_empty() -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("").is_empty()

    # this assertion fails because the values contains a single space
    assert_str(" ").is_empty()
```
{% endtab %}
{% tab assert-str-is_empty C# %}
```cs
    public static IStringAssert AssertThat(<current>).IsEmpty()
```
```cs
    // this assertion succeeds
    AssertThat("").IsEmpty();

    // this assertion fails because the values contains a single space
    AssertThat(" ").IsEmpty();
```
{% endtab %}
{% endtabs %}



### is_not_empty
Verifies that the current String is not empty, it has a length of minimum 1.
{% tabs assert-str-is_not_empty %}
{% tab assert-str-is_not_empty GdScript %}
```ruby
    func assert_str(<current>).is_not_empty() -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str(" ").is_not_empty()

    # this assertion fails because the values empty (has size of 0 lenght)
    assert_str("").is_not_empty()
```
{% endtab %}
{% tab assert-str-is_not_empty C# %}
```cs
    public static IStringAssert AssertThat(<current>).IsNotEmpty()
```
```cs
    // this assertion succeeds
    AssertThat(" ").IsNotEmpty();

    // this assertion fails because the values empty (has size of 0 lenght)
    AssertThat("").IsNotEmpty();
```
{% endtab %}
{% endtabs %}


### contains
Verifies that the current String contains the given String.
{% tabs assert-str-contains %}
{% tab assert-str-contains GdScript %}
```ruby
    func assert_str(<current>).contains(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a String").contains("is")

    # this assertion fails
    assert_str("This is a String").contains("not")
```
{% endtab %}
{% tab assert-str-contains C# %}
```cs
    public static IStringAssert AssertThat(<current>).Contains(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a String").Contains("is");

    // this assertion fails
    AssertThat("This is a String").Contains("not");
```
{% endtab %}
{% endtabs %}


### contains_ignoring_case
Verifies that the current String does not contain the given String, ignoring case considerations.
{% tabs assert-str-contains_ignoring_case %}
{% tab assert-str-contains_ignoring_case GdScript %}
```ruby
    func assert_str(<current>).contains_ignoring_case(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a String").contains_ignoring_case("IS")

    # this assertion fails
    assert_str("This is a String").contains_ignoring_case("not")
```
{% endtab %}
{% tab assert-str-contains_ignoring_case C# %}
```cs
    public static IStringAssert AssertThat(<current>).ContainsIgnoringCase(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a String").ContainsIgnoringCase("IS");

    // this assertion fails
    AssertThat("This is a String").ContainsIgnoringCase("not");
```
{% endtab %}
{% endtabs %}


### not_contains
Verifies that the current String does not contain the given String.
{% tabs assert-str-not_contains %}
{% tab assert-str-not_contains GdScript %}
```ruby
    func assert_str(<current>).not_contains(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a String").not_contains("not")

    # this assertion fails
    assert_str("This is a String").not_contains("is")
```
{% endtab %}
{% tab assert-str-not_contains C# %}
```cs
    public static IStringAssert AssertThat(<current>).NotContains(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a String").NotContains("not");

    // this assertion fails
    AssertThat("This is a String").NotContains("is");
```
{% endtab %}
{% endtabs %}



### not_contains_ignoring_case
Verifies that the current String does not contain the given String, ignoring case considerations.
{% tabs assert-str-not_contains_ignoring_case %}
{% tab assert-str-not_contains_ignoring_case GdScript %}
```ruby
    func assert_str(<current>).not_contains_ignoring_case(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a String").not_contains_ignoring_case("Not")

    # this assertion fails
    assert_str("This is a String").not_contains_ignoring_case("IS")
```
{% endtab %}
{% tab assert-str-not_contains_ignoring_case C# %}
```cs
    public static IStringAssert AssertThat(<current>).NotContainsIgnoringCase(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a String").NotContainsIgnoringCase("Not");

    // this assertion fails
    AssertThat("This is a String").NotContainsIgnoringCase("IS");
```
{% endtab %}
{% endtabs %}


### starts_with
Verifies that the current String starts with the given prefix.
{% tabs assert-str-starts_with %}
{% tab assert-str-starts_with GdScript %}
```ruby
    func assert_str(<current>).starts_with(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a String").starts_with("This is")

    # this assertion fails
    assert_str("This is a String").starts_with("a String")
```
{% endtab %}
{% tab assert-str-starts_with C# %}
```cs
    public static IStringAssert AssertThat(<current>).StartsWith(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a String").StartsWith("This is");

    // this assertion fails
    AssertThat("This is a String").StartsWith("a String");
```
{% endtab %}
{% endtabs %}



### ends_with
Verifies that the current String ends with the given suffix.
{% tabs assert-str-ends_with %}
{% tab assert-str-ends_with GdScript %}
```ruby
    func assert_str(<current>).ends_with(<expected>) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds
    assert_str("This is a String").ends_with("a String")

    # this assertion fails
    assert_str("This is a String").ends_with("a Str")
```
{% endtab %}
{% tab assert-str-ends_with C# %}
```cs
    public static IStringAssert AssertThat(<current>).EndsWith(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat("This is a String").EndsWith("a String");

    // this assertion fails
    AssertThat("This is a String").EndsWith("a Str");
```
{% endtab %}
{% endtabs %}


### has_length
Verifies that the current String has the expected length by used [[comparator|Asserts#GdUnit Comparator]].
{% tabs assert-str-has_length %}
{% tab assert-str-has_length GdScript %}
```ruby
    func assert_str(<current>).has_length(<expected>, <comparator> (EXACTLY)) -> GdUnitStringAssert
```
```ruby
    # this assertion succeeds because the current String has 22 characters 
    assert_str("This is a test message").has_length(22)
    assert_str("This is a test message").has_length(23, Comparator.LESS_THAN)
    assert_str("This is a test message").has_length(22, Comparator.LESS_EQUAL)
    assert_str("This is a test message").has_length(21, Comparator.GREATER_THAN)
    assert_str("This is a test message").has_length(21, Comparator.GREATER_EQUAL)

    # this assertion fails because the current String has 22 characters and not 23
    assert_str("This is a test message").has_length(23)
    assert_str("This is a test message").has_length(22, Comparator.LESS_THAN)
    assert_str("This is a test message").has_length(21, Comparator.LESS_EQUAL) 
    assert_str("This is a test message").has_length(22, Comparator.GREATER_THAN)
    assert_str("This is a test message").has_length(23, Comparator.GREATER_EQUAL)
```
{% endtab %}
{% tab assert-str-has_length C# %}
```cs
    public static IStringAssert AssertThat(<current>).HasLength(<expected>, <comparator> (// EQUAL is default))
```
```cs
    // this assertion succeeds because the current String has 22 characters 
    AssertThat("This is a test message").HasLength(22);
    AssertThat("This is a test message").HasLength(23, Compare.LESS_THAN);
    AssertThat("This is a test message").HasLength(22, Compare.LESS_EQUAL);
    AssertThat("This is a test message").HasLength(21, Compare.GREATER_THAN);
    AssertThat("This is a test message").HasLength(21, Compare.GREATER_EQUAL);

    // this assertion fails because the current String has 22 characters and not 23
    AssertThat("This is a test message").HasLength(23);
    AssertThat("This is a test message").HasLength(22, Compare.LESS_THAN);
    AssertThat("This is a test message").HasLength(21, Compare.LESS_EQUAL); 
    AssertThat("This is a test message").HasLength(22, Compare.GREATER_THAN);
    AssertThat("This is a test message").HasLength(23, Compare.GREATER_EQUAL);
```
{% endtab %}
{% endtabs %}

