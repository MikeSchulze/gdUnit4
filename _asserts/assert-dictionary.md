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
|[is_null](/gdUnit3/asserts/assert-dictionary/#is_null) | Verifies that the current value is null.|
|[is_not_null](/gdUnit3/asserts/assert-dictionary/#is_not_null) | Verifies that the current value is not null.|
|[is_equal](/gdUnit3/asserts/assert-dictionary/#is_equal) | Verifies that the current dictionary is equal to the given one, ignoring order.|
|[is_not_equal](/gdUnit3/asserts/assert-dictionary/#is_not_equal) | Verifies that the current dictionary is not equal to the given one, ignoring order.|
|[is_empty](/gdUnit3/asserts/assert-dictionary/#is_empty) | Verifies that the current dictionary is empty, it has a size of 0.|
|[is_not_empty](/gdUnit3/asserts/assert-dictionary/#is_not_empty) | Verifies that the current dictionary is not empty, it has a size of minimum 1.|
|[has_size](/gdUnit3/asserts/assert-dictionary/#has_size) | Verifies that the current dictionary has a size of given value.|
|[contains_keys](/gdUnit3/asserts/assert-dictionary/#contains_keys) | Verifies that the current dictionary contains the given keys.|
|[contains_not_keys](/gdUnit3/asserts/assert-dictionary/#contains_not_keys) | Verifies that the current dictionary not contains the given keys.|
|[contains_key_value](/gdUnit3/asserts/assert-dictionary/#contains_key_value) | Verifies that the current dictionary contains the given key and value.|
{% endtab %}
{% tab assert-dict-overview C# %}
**IDictionaryAssert**<br>

|Function|Description|
|--- | --- |
|[IsNull](/gdUnit3/asserts/assert-dictionary/#is_null) | Verifies that the current value is null.|
|[IsNotNull](/gdUnit3/asserts/assert-dictionary/#is_not_null) | Verifies that the current value is not null.|
|[IsEqual](/gdUnit3/asserts/assert-dictionary/#is_equal) | Verifies that the current dictionary is equal to the given one, ignoring order.|
|[IsNotEqual](/gdUnit3/asserts/assert-dictionary/#is_not_equal) | Verifies that the current dictionary is not equal to the given one, ignoring order.|
|[IsEmpty](/gdUnit3/asserts/assert-dictionary/#is_empty) | Verifies that the current dictionary is empty, it has a size of 0.|
|[IsNotEmpty](/gdUnit3/asserts/assert-dictionary/#is_not_empty) | Verifies that the current dictionary is not empty, it has a size of minimum 1.|
|[HasSize](/gdUnit3/asserts/assert-dictionary/#has_size) | Verifies that the current dictionary has a size of given value.|
|[ContainsKeys](/gdUnit3/asserts/assert-dictionary/#contains_keys) | Verifies that the current dictionary contains the given keys.|
|[NotContainsKeys](/gdUnit3/asserts/assert-dictionary/#contains_not_keys) | Verifies that the current dictionary not contains the given keys.|
|[ContainsKeyValue](/gdUnit3/asserts/assert-dictionary/#contains_key_value) | Verifies that the current dictionary contains the given key and value.|
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
Verifies that the current dictionary is equal to the given one, ignoring order.
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
Verifies that the current dictionary is not equal to the given one, ignoring order.
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
Verifies that the current dictionary contains the given key(s).
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


### contains_not_keys
Verifies that the current dictionary not contains the given key(s).
{% tabs assert-dict-contains_not_keys %}
{% tab assert-dict-contains_not_keys GdScript %}
```ruby
    func assert_dict(<current>).contains_not_keys(<expected>: Array) -> GdUnitDictionaryAssert:
```
```ruby
    # this assertion succeeds
    assert_dict({}).contains_not_keys([2])
    assert_dict({1:1, 3:3}).contains_not_keys([2])
    assert_dict({1:1, 3:3}).contains_not_keys([2, 4])

    # should fail
    assert_dict({1:1, 2:2, 3:3}).contains_not_keys([2, 4]) # but contains 2
    assert_dict({1:1, 2:2, 3:3}.contains_not_keys([1, 2, 3, 4]) # but contains 1, 2, 3
```
{% endtab %}
{% tab assert-dict-contains_not_keys C# %}
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


### contains_key_value
Verifies that the current dictionary contains the given key and value.
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
