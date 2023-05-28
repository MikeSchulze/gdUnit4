---
layout: default
title: Dictionary Assert
parent: Asserts
nav_order: 6
---

# Dictionary Assertions

An assertion tool to verify dictionaries.

{% tabs assert-dict-overview %}
{% tab assert-dict-overview GdScript %}
**GdUnitDictionaryAssert**<br>

|Function|Description|
|--- | --- |
|[is_null](/gdUnit4/asserts/assert-dictionary/#is_null) | Verifies that the current value is null.|
|[is_not_null](/gdUnit4/asserts/assert-dictionary/#is_not_null) | Verifies that the current value is not null.|
|[is_equal](/gdUnit4/asserts/assert-dictionary/#is_equal) | Verifies that the current dictionary is equal to the given one, ignoring order.|
|[is_not_equal](/gdUnit4/asserts/assert-dictionary/#is_not_equal) | Verifies that the current dictionary is not equal to the given one, ignoring order.|
|[is_same](/gdUnit4/asserts/assert-dictionary/#is_same) | Verifies that the current dictionary is the same.|
|[is_not_same](/gdUnit4/asserts/assert-dictionary/#is_not_same) | Verifies that the current dictionary is NOT the same.|
|[is_empty](/gdUnit4/asserts/assert-dictionary/#is_empty) | Verifies that the current dictionary is empty, it has a size of 0.|
|[is_not_empty](/gdUnit4/asserts/assert-dictionary/#is_not_empty) | Verifies that the current dictionary is not empty, it has a size of minimum 1.|
|[has_size](/gdUnit4/asserts/assert-dictionary/#has_size) | Verifies that the current dictionary has a size of given value.|
|[contains_keys](/gdUnit4/asserts/assert-dictionary/#contains_keys) | Verifies that the current dictionary contains the given keys.|
|[contains_key_value](/gdUnit4/asserts/assert-dictionary/#contains_key_value) | Verifies that the current dictionary contains the given key and value.|
|[not_contains_keys](/gdUnit4/asserts/assert-dictionary/#not_contains_keys) | Verifies that the current dictionary not contains the given keys.|
|[contains_same_keys](/gdUnit4/asserts/assert-dictionary/#contains_same_keys) | Verifies that the current dictionary contains the given keys.|
|[contains_same_key_value](/gdUnit4/asserts/assert-dictionary/#contains_same_key_value) | Verifies that the current dictionary contains the given key and value.|
|[not_contains_same_keys](/gdUnit4/asserts/assert-dictionary/#not_contains_same_keys) | Verifies that the current dictionary not contains the given keys.|
{% endtab %}
{% tab assert-dict-overview C# %}
**IDictionaryAssert**<br>

|Function|Description|
|--- | --- |
|[IsNull](/gdUnit4/asserts/assert-dictionary/#is_null) | Verifies that the current value is null.|
|[IsNotNull](/gdUnit4/asserts/assert-dictionary/#is_not_null) | Verifies that the current value is not null.|
|[IsEqual](/gdUnit4/asserts/assert-dictionary/#is_equal) | Verifies that the current dictionary is equal to the given one, ignoring order.|
|[IsNotEqual](/gdUnit4/asserts/assert-dictionary/#is_not_equal) | Verifies that the current dictionary is not equal to the given one, ignoring order.|
|[IsSame](/gdUnit4/asserts/assert-dictionary/#is_same) | Verifies that the current dictionary is the same.|
|[IsNotSame](/gdUnit4/asserts/assert-dictionary/#is_not_same) | Verifies that the current dictionary is NOT the same.|
|[IsEmpty](/gdUnit4/asserts/assert-dictionary/#is_empty) | Verifies that the current dictionary is empty, it has a size of 0.|
|[IsNotEmpty](/gdUnit4/asserts/assert-dictionary/#is_not_empty) | Verifies that the current dictionary is not empty, it has a size of minimum 1.|
|[HasSize](/gdUnit4/asserts/assert-dictionary/#has_size) | Verifies that the current dictionary has a size of given value.|
|[ContainsKeys](/gdUnit4/asserts/assert-dictionary/#contains_keys) | Verifies that the current dictionary contains the given keys.|
|[ContainsKeyValue](/gdUnit4/asserts/assert-dictionary/#contains_key_value) | Verifies that the current dictionary contains the given key and value.|
|[NotContainsKeys](/gdUnit4/asserts/assert-dictionary/#contains_not_keys) | Verifies that the current dictionary not contains the given keys.|
|[ContainsSameKeys](/gdUnit4/asserts/assert-dictionary/#contains_same_keys) | Verifies that the current dictionary contains the given keys.|
|[ContainsSameKeyValue](/gdUnit4/asserts/assert-dictionary/#contains_same_key_value) | Verifies that the current dictionary contains the given key and value.|
|[NotContainsSameKeys](/gdUnit4/asserts/assert-dictionary/#not_contains_same_keys) | Verifies that the current dictionary not contains the given keys.|
{% endtab %}
{% endtabs %}

---
## Dictionary Assert Examples

### is_null
Verifies that the current value is null.
{% tabs assert-dict-is_null %}
{% tab assert-dict-is_null GdScript %}
```ruby
    func assert_dict(<current>).is_null() -> GdUnitDictionaryAssert
```
```ruby
    # this assertion succeeds
    assert_dict(null).is_null()

    # should fail because the dictionary is not null
    assert_dict({}).is_null()
```
{% endtab %}
{% tab assert-dict-is_null C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsNull();
    public static IDictionaryAssert AssertThat<K, V>(current).IsNull();
```
```cs
    // this assertion succeeds
    AssertThat(null).IsNull();

    // should fail because it not null
    AssertThat(new Hashtable()).IsNull();
```
{% endtab %}
{% endtabs %}


### is_not_null
Verifies that the current value is not null.
{% tabs assert-dict-is_not_null %}
{% tab assert-dict-is_not_null GdScript %}
```ruby
    func assert_dict(<current>).is_not_null() -> GdUnitDictionaryAssert
```
```ruby
    # this assertion succeeds
    assert_dict({}).is_not_null()

    # should fail because the dictionary is null
    assert_dict(null).is_not_null()
```
{% endtab %}
{% tab assert-dict-is_not_null C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsNotNull();
    public static IDictionaryAssert AssertThat<K, V>(current).IsNotNull();
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable()).IsNotNull();

    // should fail because the current value is null
    AssertThat(null).IsNotNull();
```
{% endtab %}
{% endtabs %}


### is_equal
Verifies that the current dictionary is equal to the given one, ignoring order.<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [is_same](/gdUnit4/asserts/assert-dictionary/#is_same).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-is_equal %}
{% tab assert-dict-is_equal GdScript %}
```ruby
    func assert_dict(<current>).is_equal(<expected>) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({}).is_equal({})
    assert_dict({1:1}).is_equal({1:1})
    assert_dict({1:1, "key_a": "value_a"}).is_equal({1:1, "key_a": "value_a" })
    # different order is also equals
    assert_dict({"key_a": "value_a", 1:1}).is_equal({1:1, "key_a": "value_a" })

    # should fail
    assert_dict({}).is_equal({1:1})
    assert_dict({1:1}).is_equal({1:2})
    assert_dict({1:1, "key_a": "value_a"}).is_equal({1:1, "key_b": "value_b"})
```
{% endtab %}
{% tab assert-dict-is_equal C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsEqual();
    public static IDictionaryAssert AssertThat<K, V>(current).IsEqual();
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable()).IsEqual(new Hashtable());

    // should fail because is not equal
    AssertThat(new Hashtable()).IsEqual(new Hashtable() { { 1, 1 } });
```
{% endtab %}
{% endtabs %}


### is_not_equal
Verifies that the current dictionary is not equal to the given one, ignoring order.<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [is_not_same](/gdUnit4/asserts/assert-dictionary/#is_not_same).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-is_not_equal %}
{% tab assert-dict-is_not_equal GdScript %}
```ruby
    func assert_dict(<current>).is_not_equal(<expected>) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict(null).is_not_equal({})
    assert_dict({}).is_not_equal(null)
    assert_dict({}).is_not_equal({1:1})
    assert_dict({1:1}).is_not_equal({})
    assert_dict({1:1}).is_not_equal({1:2})
    assert_dict({2:1}).is_not_equal({1:1})
    assert_dict({1:1}).is_not_equal({1:1, "key_a": "value_a"})
    assert_dict({1:1, "key_a": "value_a"}).is_not_equal({1:1})
    assert_dict({1:1, "key_a": "value_a"}).is_not_equal({1:1,"key_b": "value_b"})

    # should fail
    assert_dict({}).is_not_equal({})
    assert_dict({1:1}).is_not_equal({1:1})
    assert_dict({1:1, "key_a": "value_a"}).is_not_equal({1:1, "key_a": "value_a"})
    assert_dict({"key_a": "value_a", 1:1}).is_not_equal({1:1, "key_a": "value_a"})
```
{% endtab %}
{% tab assert-dict-is_not_equal C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsNotEqual();
    public static IDictionaryAssert AssertThat<K, V>(current).IsNotEqual();
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable()).IsNotEqual(new Hashtable() { { 1, 1 } });

    // should fail because it is equal
    AssertThat(new Hashtable()).IsNotEqual(new Hashtable());
```
{% endtab %}
{% endtabs %}



### is_same
Verifies that the current dictionary is the same.<br>
The dictionary are compared by object reference, for deep parameter comparision use [is_equal](/gdUnit4/asserts/assert-dictionary/#is_equal).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)

{% tabs assert-dict-is_same %}
{% tab assert-dict-is_same GdScript %}
```ruby
    func assert_dict(<current>).is_same(<expected>) -> GdUnitDictionaryAssert:
```
```ruby
    var a := { "key_a": "value_a", "key_b": "value_b"}
    var b := { "key_a": "value_a", "key_b": "value_b"}
    # this assertion succeeds
    assert_dict(a).is_same(a)

    # should fail
    assert_dict(a).is_same(b)
```
{% endtab %}
{% tab assert-dict-is_same C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsSame();
    public static IDictionaryAssert AssertThat<K, V>(current).IsSame();
```
```cs
    Hashtable a = new Hashtable();
    Hashtable b = new Hashtable();
    // this assertion succeeds
    AssertThat(a).IsSame(a);

    // should fail because is not equal
    AssertThat(a).IsSame(b);
```
{% endtab %}
{% endtabs %}


### is_not_same
Verifies that the current dictionary is NOT the same.<br>
The dictionary are compared by object reference, for deep parameter comparision use [is_not_equal](/gdUnit4/asserts/assert-dictionary/#is_not_equal).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)

{% tabs assert-dict-is_not_same %}
{% tab assert-dict-is_not_same GdScript %}
```ruby
    func assert_dict(<current>).is_not_same(<expected>) -> GdUnitDictionaryAssert:
```
```ruby
    var a := { "key_a": "value_a", "key_b": "value_b"}
    var b := { "key_a": "value_a", "key_b": "value_b"}
    # this assertion succeeds
    assert_dict(a).is_not_same(b)

    # should fail
    assert_dict(a).is_not_same(a)
```
{% endtab %}
{% tab assert-dict-is_not_same C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsNotSame();
    public static IDictionaryAssert AssertThat<K, V>(current).IsNotSame();
```
```cs
    Hashtable a = new Hashtable();
    Hashtable b = new Hashtable();
    // this assertion succeeds
    AssertThat(a).IsNotSame(b);

    // should fail because is not equal
    AssertThat(a).IsNotSame(a);
```
{% endtab %}
{% endtabs %}


### is_empty
Verifies that the current dictionary is empty, it has a size of 0.
{% tabs assert-dict-is_empty %}
{% tab assert-dict-is_empty GdScript %}
```ruby
    func assert_dict(<current>).is_empty() -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({}).is_empty()

    # should fail
    assert_dict(null).is_empty()
    assert_dict({1:1}).is_empty()
```
{% endtab %}
{% tab assert-dict-is_empty C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsEmpty();
    public static IDictionaryAssert AssertThat<K, V>(current).IsEmpty();
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable()).IsEmpty();

    // should fail because it is NOT empty
    AssertThat(new Hashtable() { { 1, 1 } }).IsEmpty();
```
{% endtab %}
{% endtabs %}


### is_not_empty
Verifies that the current dictionary is not empty, it has a size of minimum 1.
{% tabs assert-dict-is_not_empty %}
{% tab assert-dict-is_not_empty GdScript %}
```ruby
    func assert_dict(<current>).is_not_empty() -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({1:1}).is_not_empty()
    assert_dict({1:1, "key_a": "value_a"}).is_not_empty()

    # should fail
    assert_dict(null).is_not_empty()
    assert_dict({}).is_not_empty()
```
{% endtab %}
{% tab assert-dict-is_not_empty C# %}
```cs
    public static IDictionaryAssert AssertThat(current).IsNotEmpty();
    public static IDictionaryAssert AssertThat<K, V>(current).IsNotEmpty();
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable() { { 1, 1 } }).IsNotEmpty();

    // should fail because it is empty
    AssertThat(new Hashtable()).IsNotEmpty();
```
{% endtab %}
{% endtabs %}


### has_size
Verifies that the current dictionary has a size of given value.
{% tabs assert-dict-has_size %}
{% tab assert-dict-has_size GdScript %}
```ruby
    func assert_dict(<current>).has_size(<expected>) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({}).has_size(0)
    assert_dict({1:1, 2:1, 3:1}).has_size(3)

    # should fail
    assert_dict(null).has_size(0)
    assert_dict({}).has_size(1)
    assert_dict({1:1, 2:1, 3:1}).has_size(4)
```
{% endtab %}
{% tab assert-dict-has_size C# %}
```cs
    public static IDictionaryAssert AssertThat(current).HasSize(<count>);
    public static IDictionaryAssert AssertThat<K, V>(current).HasSize(<count>);
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable() { { 1, 1 } }).HasSize(1);

    // should fail because it is empty
    AssertThat(new Hashtable()).HasSize(1);
```
{% endtab %}
{% endtabs %}


### contains_keys
Verifies that the current dictionary contains the given key(s).<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [contains_same_keys](/gdUnit4/asserts/assert-dictionary/#contains_same_keys).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-contains_keys %}
{% tab assert-dict-contains_keys GdScript %}
```ruby
    func assert_dict(<current>).contains_keys(<expected>: Array) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({1:1, 2:2, 3:3}).contains_keys([2])
    assert_dict({1:1, 2:2, "key_a": "value_a"}).contains_keys([2, "key_a"])

    # should fail
    assert_dict({1:1, 3:3}).contains_keys([2]) # key 2 is missing
    assert_dict({1:1, 3:3}).contains_keys([1, 4]) # key 4 is missing
```
{% endtab %}
{% tab assert-dict-contains_keys C# %}
```cs
    public static IDictionaryAssert AssertThat(current).ContainsKeys(<keys>);
    public static IDictionaryAssert AssertThat<K, V>(current).ContainsKeys(<keys>);
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable() { { "a", 1 }, { "b", 2} }).ContainsKeys("a", "b");

    // should fail because it not contains key "c"
    AssertThat(new Hashtable() { { "a", 1 }, { "b", 2} }).ContainsKeys("a", "c");
```
{% endtab %}
{% endtabs %}


### contains_key_value
Verifies that the current dictionary contains the given key and value.<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [contains_same_key_value](/gdUnit4/asserts/assert-dictionary/#contains_same_key_value).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-contains_key_value %}
{% tab assert-dict-contains_key_value GdScript %}
```ruby
    func contains_key_value(<key>, <value>) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({1:1}).contains_key_value(1, 1)
    assert_dict({1:1, 2:2, 3:3}).contains_key_value(3, 3).contains_key_value(1, 1)

    # should fail
    assert_dict({1:1}.contains_key_value(1, 2) # contains key '1' but with value '2'
```
{% endtab %}
{% tab assert-dict-contains_key_value C# %}
```cs
    public static IDictionaryAssert AssertThat(current).ContainsKeyValue(<keys>);
    public static IDictionaryAssert AssertThat<K, V>(current).ContainsKeyValue(<keys>);
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable() { { "a", 1 }, { "b", 2} }).ContainsKeyValue("a", "1");

    // should fail because it NOT contains key and value "a:2"
    AssertThat(new Hashtable() { { "a", 1 }, { "b", 2} }).ContainsKeyValue("a", "2");
```
{% endtab %}
{% endtabs %}


### not_contains_keys
Verifies that the current dictionary not contains the given key(s).<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [not_contains_same_keys](/gdUnit4/asserts/assert-dictionary/#not_contains_same_keys).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-not_contains_keys %}
{% tab assert-dict-not_contains_keys GdScript %}
```ruby
    func assert_dict(<current>).not_contains_keys(<expected>: Array) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({}).not_contains_keys([2])
    assert_dict({1:1, 3:3}).not_contains_keys([2])
    assert_dict({1:1, 3:3}).not_contains_keys([2, 4])

    # should fail
    assert_dict({1:1, 2:2, 3:3}).not_contains_keys([2, 4]) # but contains 2
    assert_dict({1:1, 2:2, 3:3}.not_contains_keys([1, 2, 3, 4]) # but contains 1, 2, 3
```
{% endtab %}
{% tab assert-dict-not_contains_keys C# %}
```cs
    public static IDictionaryAssert AssertThat(current).NotContainsKeys(<keys>);
    public static IDictionaryAssert AssertThat<K, V>(current).NotContainsKeys(<keys>);
```
```cs
    // this assertion succeeds
    AssertThat(new Hashtable() { { "a", 1 }, { "b", 2} }).ContainsKeys("c", "d");

    // should fail because it contains key "b"
    AssertThat(new Hashtable() { { "a", 1 }, { "b", 2} }).NotContainsKeys("b", "c");
```
{% endtab %}
{% endtabs %}


### contains_same_keys
Verifies that the current dictionary contains the given key(s).<br>
The dictionary are compared by object reference, for deep parameter comparision use [contains_keys](/gdUnit4/asserts/assert-dictionary/#contains_keys).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-contains_same_keys %}
{% tab assert-dict-contains_same_keys GdScript %}
```ruby
    func assert_dict(<current>).contains_same_keys(<expected>: Array) -> GdUnitDictionaryAssert:
```
```ruby
    var key_a := Node.new()
    var key_b := Node.new()
    var key_c := Node.new()
    var dict_a := { key_a:"foo", key_b:"bar" }

    # this assertion succeeds
    assert_dict(dict_a).contains_same_keys([key_a])

    # should fail
    assert_dict(a).contains_same_keys([key_c]) # key_c is missing
```
{% endtab %}
{% tab assert-dict-contains_same_keys C# %}
```cs
    public static IDictionaryAssert AssertThat(current).ContainsSameKeys(<keys>);
    public static IDictionaryAssert AssertThat<K, V>(current).ContainsSameKeys(<keys>);
```
```cs
    String key_a = "a";
    String key_b = "b";
    String key_c = "c";
    Hashtable dict_a = new Hashtable() { { key_a, "foo" }, { key_b, "bar"} };
    // this assertion succeeds
    AssertThat(dict_a).ContainsSameKeys(key_a);

    // should fail because it not contains key "c"
    AssertThat(dict_a).ContainsSameKeys(key_c);
```
{% endtab %}
{% endtabs %}


### contains_same_key_value
Verifies that the current dictionary contains the given key and value.<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [contains_key_value](/gdUnit4/asserts/assert-dictionary/#contains_key_value).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-contains_same_key_value %}
{% tab assert-dict-contains_same_key_value GdScript %}
```ruby
    func contains_same_key_value(<key>, <value>) -> GdUnitDictionaryAssert:
```
```ruby
    var key_a := Node.new()
    var key_b := Node.new()
    var value_a := Node.new()
    var value_b := Node.new()
    var dict_a := { key_a:value_a, key_b:value_b }

    # this assertion succeeds
    assert_dict(dict_a)\
        .contains_same_key_value(key_a, value_a)\
        .contains_same_key_value(key_b, value_b)

    # should fail  because it NOT contains key with value key_a, value_b
    assert_dict(dict_a).contains_same_key_value(key_a, value_b)
```
{% endtab %}
{% tab assert-dict-contains_same_key_value C# %}
```cs
    public static IDictionaryAssert AssertThat(current).ContainsSameKeyValue(<keys>);
    public static IDictionaryAssert AssertThat<K, V>(current).ContainsSameKeyValue(<keys>);
```
```cs
    String key_a = "a";
    String key_b = "b";
    String value_a = "foo";
    String value_b = "bar";
    Hashtable dict_a = new Hashtable() { { key_a, value_a }, { key_b, value_b} };
    // this assertion succeeds
    AssertThat(dict_a).ContainsSameKeyValue(key_a, value_a);

    // should fail because it NOT contains key with value key_a, value_b
    AssertThat(dict_a).ContainsSameKeyValue(key_a, value_b);
```
{% endtab %}
{% endtabs %}


### not_contains_same_keys
Verifies that the current dictionary not contains the given key(s).<br>
The values are compared by deep parameter comparision, for object reference compare you have to use [not_contains_keys](/gdUnit4/asserts/assert-dictionary/#not_contains_keys).<br>
For more details about comparision works see [How GdUnit Asserts compares Objects](/gdUnit4/asserts/index/#how-gdunit-asserts-compares-objects)
{% tabs assert-dict-not_contains_same_keys %}
{% tab assert-dict-not_contains_same_keys GdScript %}
```ruby
    func assert_dict(<current>).not_contains_same_keys(<expected>: Array) -> GdUnitDictionaryAssert:
```
```ruby
    var key_a := Node.new()
    var key_b := Node.new()
    var key_c := Node.new()
    var dict_a := { key_a:"foo", key_b:"bar" }
    # this assertion succeeds
    assert_dict(dict_a).not_contains_same_keys([key_c])

    # should fail because it contains key_a and key_b
    assert_dict(dict_a).not_contains_same_keys(key_a)
    assert_dict(dict_a).not_contains_same_keys(key_b)
```
{% endtab %}
{% tab assert-dict-not_contains_same_keys C# %}
```cs
    public static IDictionaryAssert AssertThat(current).NotContainsSameKeys(<keys>);
    public static IDictionaryAssert AssertThat<K, V>(current).NotContainsSameKeys(<keys>);
```
```cs
    String key_a = "a";
    String key_b = "b";
    String key_c = "b";
    Hashtable dict_a = new Hashtable() { { key_a, "foo" }, { key_b, "bar"} };
    // this assertion succeeds
    AssertThat(dict_a).NotContainsSameKeys(key_c);

    // should fail because it contains key "a" and "b"
    AssertThat(dict_a).NotContainsSameKeys(key_a);
    AssertThat(dict_a).NotContainsSameKeys(key_b);
```
{% endtab %}
{% endtabs %}

---
<h4> document version v4.1.1 </h4>
