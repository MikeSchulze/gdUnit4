---
layout: default
title: Signal Assert
parent: Asserts
nav_order: 12
---

## Signal Assertions

An Assertion Tool to verify for emitted signals until a certain time. When the timeout is reached, the assertion fails with a timeout error.
The default timeout of 2s can be overridden by wait_until(<time in ms>)

{% tabs assert-signal-overview %}
{% tab assert-signal-overview GdScript %}
|Function|Description|
|[is_emitted](/gdUnit3/asserts/assert-signal/#is_emitted) | Verifies that given signal is emitted until waiting time.|
|[is_not_emitted](/gdUnit3/asserts/assert-signal/#is_not_emitted) | Verifies that given signal is NOT emitted until waiting time.|
|[wait_until](/gdUnit3/asserts/assert-signal/#wait_until) | Sets the assert signal timeout in ms.|
{% endtab %}
{% tab assert-signal-overview C# %}

## Not yet supported!
{% endtab %}
{% endtabs %}

---
## Signal Assert Examples

### is_emitted
Waits until the given signal is emitted or the timeout occures and fails
```ruby
    func assert_signal(<instance :Object>).is_emitted(<signal_name>, [args :Array]) -> GdUnitSignalAssert
```
```ruby
    # waits until the signal "door_opened" is emitted by the instance or fails after default timeout of 2s
    yield(assert_signal(instance).is_emitted("door_opened"), "completed")
```


### is_not_emitted
Waits until the specified timeout to check if the signal was NOT emitted
```ruby
    func assert_signal(<instance :Object>).is_not_emitted(<signal_name>, [args :Array]) -> GdUnitSignalAssert
```
```ruby
    # waits until 2s and verifies the signal "door_locked" is not emitted
    yield(assert_signal(instance).is_not_emitted("door_locked"), "completed")
```

### wait_until
Sets the timeout in ms to wait.
```ruby
    func assert_signal(<instance :Object>).wait_until(<timeout>) -> GdUnitSignalAssert
```
```ruby
    # waits until 5s the signal "door_closed" is emitted or fail
    yield(assert_signal(instance).wait_until(5000).is_emitted("door_closed"), "completed")
```
