---
layout: default
title: Function/Method Assert
parent: Asserts
nav_order: 11
---

## ***!Deprecated!***

# Function/Method Assertions

An assertion tool that waits until a certain time for an expected function return value. When the timeout is reached, the assertion fails with a timeout error. The default timeout of 2s can be overridden by wait_until(<time in ms>)

{% tabs assert-function-overview %}
{% tab assert-function-overview GdScript %}
**GdUnitFuncAssert**<br>

|Function|Description|
|--- | --- |
|[is_null](/gdUnit3/asserts/assert-function/#is_null) | Verifies that the current value is null.|
|[is_not_null](/gdUnit3/asserts/assert-function/#is_not_null) | Verifies that the current value is not null.|
|[is_equal](/gdUnit3/asserts/assert-function/#is_equal) | Verifies that the current value is equal to expected one.|
|[is_not_equal](/gdUnit3/asserts/assert-function/#is_not_equal) | Verifies that the current value is not equal to expected one.|
|[is_true](/gdUnit3/asserts/assert-function/#is_true) | Verifies that the current value is true.|
|[is_false](/gdUnit3/asserts/assert-function/#is_false) | Verifies that the current value is false.|
|[wait_until](/gdUnit3/asserts/assert-function/#wait_until) | Sets the timeout in ms to wait the function returnd the expected value.|
{% endtab %}
{% tab assert-function-overview C# %}
## Not supported!
{% endtab %}
{% endtabs %}

---
## Function/Method Assert Examples


### is_equal
Waits until the return value of the function is equal to the expected value until the wait time has expired.
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).is_equal(<expected>) -> GdUnitAssert
```
```ruby
    # waits until get_count() returns 9 or fails after default timeout of 2s
    yield(assert_func(self, "get_count").is_equal(9.0), "completed")
```


### is_not_equal
Waits until the return value of the function is NOT equal to the expected value until the wait time has expired.
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).is_not_equal(<expected>) -> GdUnitAssert
```
```ruby
    # waits until get_state() returns different value than "idle" or fails after default timeout of 2s
    yield(assert_func(self, "get_state").is_not_equal("idle"), "completed")
```


### is_null
Waits until the return value of the function is NULL until the wait time has expired.
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).is_null() -> GdUnitAssert
```
```ruby
    # waits until get_parent() returns NULL or fails after default timeout of 2s
    yield(assert_func(self, "get_parent").is_null(), "completed")
```


### is_not_null
Waits until the return value of the function is NOT NULL until the wait time has expired.
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).is_not_null() -> GdUnitAssert
```
```ruby
    # waits until get_parent() returns not NULL or fails after default timeout of 2s
    yield(assert_func(self, "get_parent").is_not_null(), "completed")
```


### is_true
Waits until the return value of the function is true until the wait time has expired.
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).is_true() -> GdUnitAssert
```
```ruby
    # waits until has_parent() returns true or fails after default timeout of 2s
    yield(assert_func(self, "has_parent").is_true(), "completed")
```


### is_false
Waits until the return value of the function is false until the wait time has expired.
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).is_false() -> GdUnitAssert
```
```ruby
    # waits until has_parent() returns false or fails after default timeout of 2s
    yield(assert_func(self, "has_parent").is_false(), "completed")
```



### wait_until
Sets the timeout in ms to wait the function returnd the expected value, if the time over a failure is emitted
```ruby
    func assert_func(<instance :Object>, <func_name :String>, [args :Array]).wait_until(<timeout>) -> GdUnitFuncAssert
```
```ruby
    # waits until has_parent() returns false or fails after custom timeout of 5s
    yield(assert_func(self, "has_parent").wait_until(5000).is_false(), "completed")
```

