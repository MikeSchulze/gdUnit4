---
layout: default
title: Array Assert
parent: Asserts
nav_order: 5
---

# Array Assertions

An assertion tool to verify arrays.

{% tabs assert-array-overview %}
{% tab assert-array-overview GdScript %}
**GdUnitArrayAssert**<br>

|Function|Description|
|--- | --- |
|[is_null](/gdUnit3/asserts/assert-array/#is_null) | Verifies that the current value is null.|
|[is_not_null](/gdUnit3/asserts/assert-array/#is_not_null) | Verifies that the current value is not null.|
|[is_equal](/gdUnit3/asserts/assert-array/#is_equal) | Verifies that the current Array is equal to the given one.|
|[is_equal_ignoring_case](/gdUnit3/asserts/assert-array/#is_equal_ignoring_case) | Verifies that the current Array is equal to the given one, ignoring case considerations.|
|[is_not_equal](/gdUnit3/asserts/assert-array/#is_not_equal) | Verifies that the current Array is not equal to the given one.|
|[is_not_equal_ignoring_case](/gdUnit3/asserts/assert-array/#is_not_equal_ignoring_case) | Verifies that the current Array is not equal to the given one, ignoring case considerations.|
|[is_empty](/gdUnit3/asserts/assert-array/#is_empty) | Verifies that the current Array is empty, it has a size of 0.|
|[is_not_empty](/gdUnit3/asserts/assert-array/#is_not_empty) | Verifies that the current Array is not empty, it has a size of minimum 1.|
|[has_size](/gdUnit3/asserts/assert-array/#has_size) | Verifies that the current Array has a size of given value.|
|[contains](/gdUnit3/asserts/assert-array/#contains) | Verifies that the current Array contains the given values, in any order.|
|[contains_exactly](/gdUnit3/asserts/assert-array/#contains_exactly) | Verifies that the current Array contains exactly only the given values and nothing else, in same order.|
|[contains_exactly_in_any_order](/gdUnit3/asserts/assert-array/#contains_exactly_in_any_order) | Verifies that the current Array contains exactly only the given values and nothing else, in any order.|
|[extract](/gdUnit3/asserts/assert-array/#extract) | Extracts all values by given function name and optional arguments.|
|[extractv](/gdUnit3/asserts/assert-array/#extractv) | Extracts all values by given extractor's.|
{% endtab %}
{% tab assert-array-overview C# %}
**IEnumerableAssert**<br>

|Function|Description|
|--- | --- |
|[IsNull](/gdUnit3/asserts/assert-array/#is_null) | Verifies that the current value is null.|
|[IsNotNull](/gdUnit3/asserts/assert-array/#is_not_null) | Verifies that the current value is not null.|
|[IsEqual](/gdUnit3/asserts/assert-array/#is_equal) | Verifies that the current Array is equal to the given one.|
|[IsEqualIgnoringCase](/gdUnit3/asserts/assert-array/#is_equal_ignoring_case) | Verifies that the current Array is equal to the given one, ignoring case considerations.|
|[IsNotEqual](/gdUnit3/asserts/assert-array/#is_not_equal) | Verifies that the current Array is not equal to the given one.|
|[IsNotEqualIgnoringNase](/gdUnit3/asserts/assert-array/#is_not_equal_ignoring_case) | Verifies that the current Array is not equal to the given one, ignoring case considerations.|
|[IsEmpty](/gdUnit3/asserts/assert-array/#is_empty) | Verifies that the current Array is empty, it has a size of 0.|
|[IsNotEmpty](/gdUnit3/asserts/assert-array/#is_not_empty) | Verifies that the current Array is not empty, it has a size of minimum 1.|
|[HasNize](/gdUnit3/asserts/assert-array/#has_size) | Verifies that the current Array has a size of given value.|
|[Contains](/gdUnit3/asserts/assert-array/#contains) | Verifies that the current Array contains the given values, in any order.|
|[ContainsExactly](/gdUnit3/asserts/assert-array/#contains_exactly) | Verifies that the current Array contains exactly only the given values and nothing else, in same order.|
|[ContainsExactlyInAnyOrder](/gdUnit3/asserts/assert-array/#contains_exactly_in_any_order) | Verifies that the current Array contains exactly only the given values and nothing else, in any order.|
|[Extract](/gdUnit3/asserts/assert-array/#extract) | Extracts all values by given function name and optional arguments.|
|[ExtractV](/gdUnit3/asserts/assert-array/#extractv) | Extracts all values by given extractor's.|
{% endtab %}
{% endtabs %}

---
## Array Assert Examples

### is_null
Verifies that the current value is null.
{% tabs assert-array-is_null %}
{% tab assert-array-is_null GdScript %}
```ruby
    func assert_array(<current>).is_null() -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array(null).is_null()

    # should fail because the array not null
    assert_array([]).is_null()
```
{% endtab %}
{% tab assert-array-is_null C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsNull()
```
```cs
    // this assertion succeeds
    AssertThat(null).IsNull();

    // should fail because the array not null
    AssertThat(new int[]{}).IsNull();
```
{% endtab %}
{% endtabs %}


### is_not_null
Verifies that the current value is not null.
{% tabs assert-array-is_not_null %}
{% tab assert-array-is_not_null GdScript %}
```ruby
    func assert_array(<current>).is_not_null() -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([]).is_not_null()

    # should fail because the array is null
    assert_array(null).is_not_null()
```
{% endtab %}
{% tab assert-array-is_not_null C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsNotNull()
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{}).IsNotNull();

    // should fail because the array is null
    AssertThat(null).IsNotNull();
```
{% endtab %}
{% endtabs %}


### is_equal
Verifies that the current Array is equal to the given one.
{% tabs assert-array-is_not_null %}
{% tab assert-array-is_not_null GdScript %}
```ruby
    func assert_array(<current>).is_equal(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([1, 2, 3, 4, 2, 5]).is_equal([1, 2, 3, 4, 2, 5])

    # should fail because the array not contains same elements and has diff size
    assert_array([1, 2, 4, 5]).is_equal([1, 2, 3, 4, 2, 5])
```
{% endtab %}
{% tab assert-array-is_not_null C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{1, 2, 3, 4, 2, 5}).IsEqual(new int[]{1, 2, 3, 4, 2, 5});

    // should fail because the array not contains same elements and has diff size
    AssertThat(new int[]{1, 2, 4, 2, 5}).IsEqual(new int[]{1, 2, 3, 4, 2, 5});
```
{% endtab %}
{% endtabs %}


### is_equal_ignoring_case
Verifies that the current Array is equal to the given one, ignoring case considerations.
{% tabs assert-array-is_equal_ignoring_case %}
{% tab assert-array-is_equal_ignoring_case GdScript %}
```ruby
    func assert_array(<current>).is_equal_ignoring_case(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array(["this", "is", "a", "message"]).is_equal_ignoring_case(["This", "is", "a", "Message"])

    # should fail because the array not contains same elements
    assert_array(["this", "is", "a", "message"]).is_equal_ignoring_case(["This", "is", "an", "Message"])
```
{% endtab %}
{% tab assert-array-is_equal_ignoring_case C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsEqualIgnoringCase(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new sring[]{"this", "is", "a", "message"}).IsEqualIgnoringCase(new sring[]{"This", "is", "a", "Message"});

    // should fail because the array not contains same elements
    AssertThat(new sring[]{"this", "is", "a", "message"}).IsEqualIgnoringCase(new sring[]{"This", "is", "an", "Message"});
```
{% endtab %}
{% endtabs %}


### is_not_equal
Verifies that the current Array is not equal to the given one.
{% tabs assert-array-is_equal_ignoring_case %}
{% tab assert-array-is_equal_ignoring_case GdScript %}
```ruby
    func assert_array(<current>).is_not_equal(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([1, 2, 3, 4, 5]).is_not_equal([1, 2, 3, 4, 5, 6])

    # should fail because the array contains same elements
    assert_array([1, 2, 3, 4, 5]).is_not_equal([1, 2, 3, 4, 5])
```
{% endtab %}
{% tab assert-array-is_equal_ignoring_case C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsNotEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{1, 2, 3, 4, 5}).IsNotEqual(new int[]{1, 2, 3, 4, 5, 6});

    // should fail because the array contains same elements
    AssertThat(new int[]{1, 2, 3, 4, 5}).IsNotEqual(new int[]{1, 2, 3, 4, 5});
```
{% endtab %}
{% endtabs %}



### is_not_equal_ignoring_case
Verifies that the current Array is not equal to the given one, ignoring case considerations.
{% tabs assert-array-is_not_equal_ignoring_case %}
{% tab assert-array-is_not_equal_ignoring_case GdScript %}
```ruby
    func assert_array(<current>).is_not_equal_ignoring_case(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array(["this", "is", "a", "message"]).is_not_equal_ignoring_case(["This", "is", "an", "Message"])

    # should fail because the array contains same elements ignoring case sensitive
    assert_array(["this", "is", "a", "message"]).is_not_equal_ignoring_case(["This", "is", "a", "Message"])
```
{% endtab %}
{% tab assert-array-is_not_equal_ignoring_case C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsNotEqualIgnoringCase(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new string[]{"this", "is", "a", "message"}).IsNotEqualIgnoringCase(new string[]{"This", "is", "an", "Message"});

    // should fail because the array contains same elements ignoring case sensitive
    AssertThat(new string[]{"this", "is", "a", "message"}).IsNotEqualIgnoringCase(new string[]{"This", "is", "a", "Message"});
```
{% endtab %}
{% endtabs %}


### is_empty
Verifies that the current Array is empty, it has a size of 0.
{% tabs assert-array-is_empty %}
{% tab assert-array-is_empty GdScript %}
```ruby
    func assert_array(<current>).is_empty() -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([]).is_empty()

    # should fail because the array is not empty it has a size of one
    assert_array([1]).is_empty()
```
{% endtab %}
{% tab assert-array-is_empty C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsEmpty()
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{}).IsEmpty();

    // should fail because the array is not empty it has a size of one
    AssertThat(new int[]{1}).IsEmpty();
```
{% endtab %}
{% endtabs %}


### is_not_empty
Verifies that the current Array is not empty, it has a size of minimum 1.
{% tabs assert-array-is_not_empty %}
{% tab assert-array-is_not_empty GdScript %}
```ruby
    func assert_array(<current>).is_not_empty() -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([1]).is_not_empty()

    # should fail because the array is empty
    assert_array([]).is_not_empty()
```
{% endtab %}
{% tab assert-array-is_not_empty C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).IsNotEmpty()
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{1}).IsNotEmpty();

    // should fail because the array is empty
    AssertThat(new int[]{}).IsNotEmpty();
```
{% endtab %}
{% endtabs %}


### has_size
Verifies that the current Array has a size of given value.
{% tabs assert-array-has_size %}
{% tab assert-array-has_size GdScript %}
```ruby
    func assert_array(<current>).has_size(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([1, 2, 3, 4, 5]).has_size(5)
    assert_array(["a", "b", "c", "d", "e", "f"]).has_size(6)

    # should fail because the array has a size of 5 and not 4
    assert_array([1, 2, 3, 4, 5]).has_size(4)
```
{% endtab %}
{% tab assert-array-has_size C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).HasSize(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{1, 2, 3, 4, 5}).HasSize(5);
    AssertThat(new string[]{"a", "b", "c", "d", "e", "f"}).HasSize(6);

    // should fail because the array has a size of 5 and not 4
    AssertThat(new int[]{1, 2, 3, 4, 5}).HasSize(4);
```
{% endtab %}
{% endtabs %}



### contains
Verifies that the current Array contains the given values, in any order.
{% tabs assert-array-contains %}
{% tab assert-array-contains GdScript %}
```ruby
    func assert_array(<current>).contains(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([1, 2, 3, 4, 5]).contains([5, 2])

    # should fail because the array not contains 7 and 6
    assert_array([1, 2, 3, 4, 5]).contains([2, 7, 6])
```
{% endtab %}
{% tab assert-array-contains C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).Contains(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{1, 2, 3, 4, 5}).Contains(5, 2);

    // should fail because the array not contains 7 and 6
    AssertThat(new int[]{1, 2, 3, 4, 5}).Contains(2, 7, 6):
```
{% endtab %}
{% endtabs %}


### contains_exactly
Verifies that the current Array contains exactly only the given values and nothing else, in same order.
{% tabs assert-array-contains_exactly %}
{% tab assert-array-contains_exactly GdScript %}
```ruby
    func assert_array(<current>).contains_exactly(<expected>) -> GdUnitArrayAssert
```
```ruby
    # this assertion succeeds
    assert_array([1, 2, 3, 4, 5]).contains_exactly([1, 2, 3, 4, 5])

    # should fail because the array contains the same elements but in a different order
    assert_array([1, 2, 3, 4, 5]).contains_exactly([1, 4, 3, 2, 5])
```
{% endtab %}
{% tab assert-array-contains_exactly C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).ContainsExactly(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(new int[]{1, 2, 3, 4, 5}).ContainsExactly(1, 2, 3, 4, 5);

    // should fail because the array contains the same elements but in a different order
    AssertThat(new int[]{1, 2, 3, 4, 5}).ContainsExactly(1, 4, 3, 2, 5);
```
{% endtab %}
{% endtabs %}


### contains_exactly_in_any_order
Verifies that the current Array contains exactly only the given values and nothing else, in any order.
{% tabs assert-array-contains_exactly_in_any_order %}
{% tab assert-array-contains_exactly_in_any_order GdScript %}
```ruby
    func contains_exactly_in_any_order(expected) -> GdUnitArrayAssert:
```
```ruby
    # this assertion succeeds, contains all elements but in a different order
    assert_array([1, 2, 3, 4, 5]).contains_exactly_in_any_order([1, 5, 3, 4, 2])

    # should fail because the array contains not exacly all elements (5 is missing)
    assert_array([1, 2, 3, 4]).contains_exactly([1, 4, 3, 2])
```
{% endtab %}
{% tab assert-array-contains_exactly_in_any_order C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).ContainsExactlyInAnyOrder(<expected>)
```
```cs
    // this assertion succeeds, contains all elements but in a different order
    AssertThat(new int[]{1, 2, 3, 4, 5}).ContainsExactlyInAnyOrder(1, 5, 3, 4, 2);

    // should fail because the array contains not exacly all elements (5 is missing)
    AssertThat(new int[]{1, 2, 3, 4}).ContainsExactlyInAnyOrder(1, 4, 3, 2);
```
{% endtab %}
{% endtabs %}



### extract

Extracts all values by given function name and optional arguments into a new ArrayAssert. 
If the elements not accessible by `func_name` the value is converted to `"n.a"`, expecting null values

You can use function name chaining e.g. `get_parent.get_name`
{% tabs assert-array-extract %}
{% tab assert-array-extract GdScript %}
```ruby
    func assert_array(<current>).extract(<func_name :String>, [args :Array]) -> GdUnitArrayAssert
    func assert_array(<current>).extract(<func_name :String>[.<func_name>, ..]) -> GdUnitArrayAssert
```
```ruby
    # extracting only by function name "get_class"
    assert_array([Reference.new(), 2, AStar.new(), auto_free(Node.new())])\
        .extract("get_class")\
        .contains_exactly(["Reference", "n.a.", "AStar", "Node"])
    # extracting by a function name and arguments
    assert_array([Reference.new(), 2, AStar.new(), auto_free(Node.new())])\
        .extract("has_signal", ["tree_entered"])\
        .contains_exactly([false, "n.a.", false, true])
```
{% endtab %}
{% tab assert-array-extract C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).Extract(<func_name :String>, <args>);
    public static IEnumerableAssert AssertThat(<current>).Extract(<func_name :String>[.<func_name>], <args>]);
```
```cs
    // extracting only by function name "get_class"
    AssertThat(new object[] { new Reference(), 2, new AStar(), AutoFree(new Node()) })
        .Extract("get_class")
        .ContainsExactly("Reference", "n.a.", "AStar", "Node");
    // extracting by a function name and arguments
    AssertThat(new object[] { new Reference(), 2, new AStar(), AutoFree(new Node()) })
        .Extract("has_signal", ["tree_entered"])
        .ContainsExactly(false, "n.a.", false, true);
```
{% endtab %}
{% endtabs %}


### extractv

Extracts all values by given extractor's into a new ArrayAssert, a maximum of teen extractors currently supported.
If the elements not extractable than the value is converted to `"n.a"`, expecting null values

To check multiple extracted values you must use `tuple`, a tuple can hold two up to ten values 
{% tabs assert-array-extractv %}
{% tab assert-array-extractv GdScript %}
```ruby
    func assert_array(<current>).extractv(<extractor:GdUnitValueExtractor>[, extractor, ..]) -> GdUnitArrayAssert
```
```ruby
    # example object for extraction
    class TestObj:
        var _name :String
        var _value
        var _x

        func _init(name :String, value, x = null):
            _name = name
            _value = value
            _x = x

        func get_name() -> String:
            return _name

        func get_value():
            return _value

        func get_x():
            return _x
```
```ruby
    # single extract
    assert_array([1, false, 3.14, null, Color.aliceblue])\
        .extractv(extr("get_class"))\
        .contains_exactly(["n.a.", "n.a.", "n.a.", null, "n.a."])
    # tuple of two
    assert_array([TestObj.new("A", 10), TestObj.new("B", "foo"), Color.aliceblue, TestObj.new("C", 11)])\
        .extractv(extr("get_name"), extr("get_value"))\
        .contains_exactly([
            tuple("A", 10),
            tuple("B", "foo"),
            tuple("n.a.", "n.a."), 
            tuple("C", 11)])
    # tuple of three
    assert_array([TestObj.new("A", 10), TestObj.new("B", "foo", "bar"), TestObj.new("C", 11, 42)])\
        .extractv(extr("get_name"), extr("get_value"), extr("get_x"))\
        .contains_exactly([
            tuple("A", 10, null),
            tuple("B", "foo", "bar"), 
            tuple("C", 11, 42)])
```
{% endtab %}
{% tab assert-array-extractv C# %}
```cs
    public static IEnumerableAssert AssertThat(<current>).ExtractV(<extractor:IValueExtractor>[, extractor, ..]);
```
```cs
    // example object for extraction
    class TestObj : Godot.Reference
    {
        string _name;
        object _value;
        object _x;

        public TestObj(string name, object value, object x = null)
        {
            _name = name;
            _value = value;
            _x = x;
        }

        public string GetName() => _name;
        public object GetValue() => _value;
        public object GetX() => _x;
    }
```
```cs
    // single extract
    AssertThat(new object[] { 1, false, 3.14, null, Colors.AliceBlue })
        .ExtractV(Extr("GetClass"))
        .ContainsExactly("n.a.", "n.a.", "n.a.", null, "n.a.");
    // tuple of two
    AssertThat(new object[] { new TestObj("A", 10), new TestObj("B", "foo"), Colors.AliceBlue, new TestObj("C", 11) })
                .ExtractV(Extr("GetName"), Extr("GetValue"))
                .ContainsExactly(Tuple("A", 10), Tuple("B", "foo"), Tuple("n.a.", "n.a."), Tuple("C", 11));
    // tuple of three
    AssertThat(new object[] { new TestObj("A", 10), new TestObj("B", "foo", "bar"), new TestObj("C", 11, 42) })
                .ExtractV(Extr("GetName"), Extr("GetValue"), Extr("GetX"))
                .ContainsExactly(Tuple("A", 10, null), Tuple("B", "foo", "bar"), Tuple("C", 11, 42));
```
{% endtab %}
{% endtabs %}


### custom value extractor
GdUnit provides `extr` function to build a value extractor by given function name and optional arguments.
You can use also function name chaining e.g. `get_parent.get_name`


{% tabs assert-array-value-extractor %}
{% tab assert-array-value-extractor GdScript %}
```ruby
    # Builds an extractor by given function name and optional arguments
    static func extr(<func_name :String>[.func_name, ..], [args :Array]) -> GdUnitValueExtractor:
```
{% endtab %}
{% tab assert-array-value-extractor C# %}
```cs
    // Builds an extractor by given function name and optional arguments
    public static IValueExtractor Extr(string methodName, params object[] args);
```
{% endtab %}
{% endtabs %}
