---
layout: default
title: Synchronize Inputs
parent: Scene Runner
grand_parent: Advanced Testing
nav_order: 5
---

## Synchronize Inputs Events

Waits for all input events to be processed by flushing any buffered input events and then awaiting a full cycle of both the process and physics frames.<br>

This is typically used to ensure that any simulated or queued inputs are fully processed before proceeding with the next steps in the scene.<br>
**It's essential for reliable input simulation or when synchronizing logic based on inputs.**<br>

### await_input_processed

The **await_input_processed** function do wait until all input events are processed.<br>

{% tabs scene-runner-await_input_processed %}
{% tab scene-runner-await_input_processed GdScript %}

```gd
### Waits for all input events are processed
func await_input_processed() -> void:
```

Here is an example of how to use simulate_frames:

```gd
var runner := scene_runner("res://test_scene.tscn")

# Simulates key combination ctrl+C is pressed
runner.simulate_key_pressed(KEY_C, false, true)

# finalize the input event processing
await await_input_processed()
```

{% endtab %}
{% tab scene-runner-await_input_processed C# %}

```cs
/// <summary>
/// A utility to synchronize the current thread with the Godot render thread.
/// This can be used to await the completion of a single render frame in Godot.
/// </summary>
public static SignalAwaiter SyncProcessFrame
```

Here is an example of how to use SimulateFrames:

```cs
ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

// Simulates key combination ctrl+C is pressed
runner
    .SimulateKeyPress(Key.Ctrl)
    .SimulateKeyPress(Key.C);

// finalize the input event processing
await ISceneRunner.SyncProcessFrame;
```

{% endtab %}
{% endtabs %}

---
<h4> document version v4.4.0 </h4>
