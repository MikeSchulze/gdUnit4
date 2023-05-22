---
layout: default
title: Signals
parent: Advanced Testing
nav_order: 3
---

# Testing for Signals

With GdUnit, you can test signals in your Godot projects. GdUnit provides two tools specifically for working with signals: `assert_signal()` and `monitor_signals()`.<br>
By using these tools, you can test the emission of signals in your Godot projects and ensure that the correct signals are being sent and received.

## Verify Signals
The `assert_signal()` an Assertion Tool to verify for emitted signals until a certain time. When the timeout is reached, the assertion fails with a timeout error.<br>
For more details show [assert_signal](/gdUnit4/asserts/assert-signal/#signal-assertions)

Here's an example of using `assert_signal()`:

```gd
extends GdUnitTestSuite

class TestEmitter extends Node:
    signal test_signal_counted(value)
    signal test_signal()
    signal test_signal_unused()

    var _trigger_count :int
    var _count := 0

    func _init(trigger_count := 10):
        _trigger_count = trigger_count

    func _process(_delta):
        if _count >= _trigger_count:
            test_signal_counted.emit(_count)
        
        if _count == 20:
            test_signal.emit()
        _count += 1


var signal_emitter :TestEmitter


func before_test():
    signal_emitter = auto_free(TestEmitter.new())
    add_child(signal_emitter)


func test_signal_emitted() -> void:
    # wait until signal 'test_signal' without args is emitted
    await assert_signal(signal_emitter).is_emitted("test_signal")


func test_signal_is_emitted_with_args() -> void:
    # wait until signal 'test_signal_counted' is emitted with value 20
    await assert_signal(signal_emitter).is_emitted("test_signal_counted", [20])    


func test_signal_is_not_emitted() -> void:
    # wait to verify signal 'test_signal_counted()' is not emitted until the first 50ms
    await assert_signal(signal_emitter).wait_until(50).is_not_emitted("test_signal_counted")


func test_is_signal_exists() -> void:
    var node :Node2D = auto_free(Node2D.new())

    assert_signal(node).is_signal_exists("visibility_changed")\
        .is_signal_exists("draw")\
        .is_signal_exists("visibility_changed")\
        .is_signal_exists("tree_entered")\
        .is_signal_exists("tree_exiting")\
        .is_signal_exists("tree_exited")

```

## Monitor Signals
The `monitor_signals()` tool allows you to monitor the emission of signals from a specific object. It sets up a signal monitoring system for the specified object, which enables you to capture and analyze the signals emitted during the execution of your test.

{% tabs monitor_signals-overview %}
{% tab monitor_signals-overview GdScript %}
```gd
    func monitor_signals(source :Object, _auto_free := true) -> Object:
```
{% endtab %}
{% tab monitor_signals-overview C# %}
### ~~Not yet implemented!~~
{% endtab %}
{% endtabs %}

Here's an example of using `monitor_signals()`:

```gd
extends GdUnitTestSuite

class MyEmitter extends Node:

    signal my_signal_a
    signal my_signal_b(value :String)


    func do_emit_a() -> void:
        my_signal_a.emit()


    func do_emit_b() -> void:
        my_signal_b.emit("foo")


func test_monitor_signals() -> void:
    # start monitoring on the emitter to collect all emitted signals
    var emitter_a := monitor_signals(MyEmitter.new())
    var emitter_b := monitor_signals(MyEmitter.new())

    # verify the signals are not emitted initial
    await assert_signal(emitter_a).wait_until(50).is_not_emitted('my_signal_a')
    await assert_signal(emitter_a).wait_until(50).is_not_emitted('my_signal_b')
    await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_a')
    await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_b')

    # emit signal `my_signal_a` on emitter_a
    emitter_a.do_emit_a()
    await assert_signal(emitter_a).is_emitted('my_signal_a')

    # emit signal `my_signal_b` on emitter_a
    emitter_a.do_emit_b()
    await assert_signal(emitter_a).is_emitted('my_signal_b', ["foo"])
    # verify emitter_b still has nothing emitted
    await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_a')
    await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_b')

    # now verify emitter b
    emitter_b.do_emit_a()
    await assert_signal(emitter_b).wait_until(50).is_emitted('my_signal_a')

```
---
<h4> document version v4.1.1 </h4>
