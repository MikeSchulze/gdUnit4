---
layout: default
title: Signal Assert
parent: Asserts
nav_order: 12
---

# Signal Assertions

An Assertion Tool to verify for emitted signals until a certain time. When the timeout is reached, the assertion fails with a timeout error.
The default timeout of 2s can be overridden by wait_until(\<time in ms\>)<br>
To watch for signals emitted during the test execution you have to use in addition the [monitor_signal](/gdUnit4/advanced_testing/signals/#monitor-signals) tool.

{% tabs assert-signal-overview %}
{% tab assert-signal-overview GdScript %}
**GdUnitSignalAssert**<br>

|Function|Description|
|--- | --- |
|[is_emitted](/gdUnit4/testing/assert-signal/#is_emitted) | Verifies that given signal is emitted until waiting time.|
|[is_not_emitted](/gdUnit4/testing/assert-signal/#is_not_emitted) | Verifies that given signal is NOT emitted until waiting time.|
|[is_signal_exists](/gdUnit4/testing/assert-signal/#is_signal_exists) | Verifies if the signal exists on the emitter.|
|[wait_until](/gdUnit4/testing/assert-signal/#wait_until) | Sets the assert signal timeout in ms.|
{% endtab %}
{% tab assert-signal-overview C# %}
**ISignalAssert**<br>

|Function|Description|
|--- | --- |
|[IsEmitted](/gdUnit4/testing/assert-signal/#is_emitted) | Verifies that given signal is emitted until waiting time.|
|[IsNotEmitted](/gdUnit4/testing/assert-signal/#is_not_emitted) | Verifies that given signal is NOT emitted until waiting time.|
|[IsSignalExists](/gdUnit4/testing/assert-signal/#is_signal_exists) | Verifies if the signal exists on the emitter.|
{% endtab %}
{% endtabs %}

---
## Signal Assert Examples

## is_emitted
Waits until the given signal is emitted or the timeout occures and fails
{% tabs assert-signal-is_emitted %}
{% tab assert-signal-is_emitted GdScript %}
```ruby
    func assert_signal(<instance :Object>).is_emitted(<signal_name>, [args :Array]) -> GdUnitSignalAssert
```
```ruby
    # waits until the signal "door_opened" is emitted by the instance or fails after default timeout of 2s
    await assert_signal(instance).is_emitted("door_opened")
```
{% endtab %}
{% tab assert-signal-is_emitted C# %}
```cs
    public Task<ISignalAssert> IsEmitted(string signal, params object[] args);
```
```cs
    // waits until the signal "door_opened" is emitted by the instance or fails after default timeout of 2s
    await AssertSignal(instance).IsEmitted("door_opened");
    // waits until the signal "door_opened" is emitted by the instance or fails after given timeout of 200ms
    await AssertSignal(instance).IsEmitted("door_opened").WithTimeout(200);
```
{% endtab %}
{% endtabs %}


## is_not_emitted
Waits until the specified timeout to check if the signal was NOT emitted
{% tabs assert-signal-is_not_emitted %}
{% tab assert-signal-is_not_emitted GdScript %}
```ruby
    func assert_signal(<instance :Object>).is_not_emitted(<signal_name>, [args :Array]) -> GdUnitSignalAssert
```
```ruby
    # waits until 2s and verifies the signal "door_locked" is not emitted
    await assert_signal(instance).is_not_emitted("door_locked")
```
{% endtab %}
{% tab assert-signal-is_not_emitted C# %}
```cs
    public Task<ISignalAssert> IsNotEmitted(string signal, params object[] args);
```
```cs
    // waits until 2s and verifies the signal "door_locked" is not emitted
    await AssertSignal(instance).IsNotEmitted("door_locked");
    // waits until 200ms and verifies the signal "door_locked" is not emitted
    await AssertSignal(instance).IsNotEmitted("door_locked").WithTimeout(200);
```
{% endtab %}
{% endtabs %}


## is_signal_exists
Verifies if the signal exists on the emitter.
{% tabs assert-signal-is_signal_exists %}
{% tab assert-signal-is_signal_exists GdScript %}
```ruby
    func assert_signal(<instance :Object>).wait_until(<timeout>) -> GdUnitSignalAssert
```
```ruby
    # verify the signal 'visibility_changed' exists in the node
    assert_signal(node).is_signal_exists("visibility_changed");
```
{% endtab %}
{% tab assert-signal-is_signal_exists C# %}
```cs
    public ISignalAssert IsSignalExists(string signal);
```
```cs
    // verify the signal 'visibility_changed' exists in the node
    AssertSignal(node).IsSignalExists("visibility_changed");
```
{% endtab %}
{% endtabs %}


## wait_until
Sets the timeout in ms to wait.
{% tabs assert-signal-wait_until %}
{% tab assert-signal-wait_until GdScript %}
```ruby
    func assert_signal(<instance :Object>).wait_until(<timeout>) -> GdUnitSignalAssert
```
```ruby
    # waits until 5s the signal "door_closed" is emitted or fail
    await assert_signal(instance).wait_until(5000).is_emitted("door_closed")
```
{% endtab %}
{% tab assert-signal-wait_until C# %}
```cs
    public static async Task<ISignalAssert> WithTimeout(this Task<ISignalAssert> task, int timeoutMillis);
```
```cs
    // waits until 5s and verifies the signal "door_locked" is not emitted or fail
    await AssertSignal(instance).IsEmitted("door_closed").WithTimeout(5000);
```
{% endtab %}
{% endtabs %}

---

For more advanced examples show [Testing Signals](/gdUnit4/advanced_testing/signals/#testing-for-signals).

---
<h4> document version v4.1.1 </h4>
