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
*Not yet implemented!*
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
{% endtabs %}

