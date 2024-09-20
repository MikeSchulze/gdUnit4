---
layout: default
title: Scene Runner
parent: Advanced Testing
nav_order: 6
has_children: true
has_toc: false
---

# Scene Runner

## Definition

The Scene Runner is a tool used for simulating interactions on a scene. With this tool, you can simulate input events such as keyboard or mouse input and/or simulate scene processing over a certain number of frames.

This tool is typically used for integration testing a scene.
<figure class="video_container">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/m6tYigD6Oe0?si=SgdLorwkoIGTJvNI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen>
    </iframe>
</figure>
For more advanced example, see [Tutorial - Testing Scenes](/gdUnit4/tutorials/scenerunner_examples/#testing-scene-interactions)

## How to Use It

The Scene Runner is managed by the GdUnit API and is automatically freed after use. One Scene Runner can only manage one scene. If you need to test multiple scenes, you must create a separate runner for each scene in your test suite.

{% tabs scene-runner-definition %}
{% tab scene-runner-definition GdScript %}
To use the Scene Runner, load the scene to be tested with **scene_runner(\<scene\>)**.

```gd
var runner := scene_runner("res://my_scene.tscn")
```

{% endtab %}
{% tab scene-runner-definition C# %}
To use the Scene Runner, load the scene to be tested with **ISceneRunner.Load(\<scene\>)**.

```cs
ISceneRunner runner = ISceneRunner.Load("res://my_scene.tscn");
```

{% endtab %}
{% endtabs %}

Here is a short example:
{% tabs scene-runner-example %}
{% tab scene-runner-example GdScript %}

```gd
func test_simulate_frames(timeout = 5000) -> void:
    # Create the scene runner for scene `test_scene.tscn`
    var runner := scene_runner("res://test_scene.tscn")

    # Get access to scene property '_box1'
    var box1: ColorRect = runner.get_property("_box1")
    # Verify it is initially set to white
    assert_object(box1.color).is_equal(Color.WHITE)
    
    # Start the color cycle by invoking the function 'start_color_cycle' and await 10 frames being processed
    runner.invoke("start_color_cycle")        
    await runner.simulate_frames(10)

    # After 10 frames, the color should have changed to black
    assert_object(box1.color).is_equal(Color.BLACK)
```

{% endtab %}
{% tab scene-runner-example C# %}

```cs
[TestCase]
public void simulate_frame() {
    // Create the scene runner for scene `test_scene.tscn`
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Get access to scene property '_box1'
    ColorRect box1 = runner.GetProperty("_box1");
    // Verify it is initially set to white
    AssertObject(box1.color).IsEqual(Color.WHITE);
    
    // Start the color cycle by invoking the function 'start_color_cycle' and await 10 frames being processed
    runner.Invoke("start_color_cycle")        
    await runner.SimulateFrames(10);

    // After 10 frames, the color should have changed to black
    AssertObject(box1.color).IsEqual(Color.BLACK);
}
```

{% endtab %}
{% endtabs %}

## Function Overview

* [Processing your Scene](#processing-and-rendering-your-scene)
* [Simulate Action Inputs](/gdUnit4/advanced_testing/scene_runner/actions/#simulate-actions)
* [Simulate Key Inputs](/gdUnit4/advanced_testing/scene_runner/keys/#simulate-key-inputs)
* [Simulate Mouse Inputs](/gdUnit4/advanced_testing/scene_runner/mouse/#simulate-mouse-inputs)
* [Simulate Touchscreen Inputs](/gdUnit4/advanced_testing/scene_runner/touchscreen/#simulate-touchscreen-inputs)
* [Synchronize Inputs Events](/gdUnit4/advanced_testing/scene_runner/sync_inputs/#synchronize-inputs-events)
* [Wait for Function Results](#wait-for-function-results)
* [Wait for Signals](#wait-for-signals)
* [Scene Accessors](/gdUnit4/advanced_testing/scene_runner/accessors/#accessors)

---

## Processing and Rendering Your Scene

This section provides guidance on how to process and render your scene during tests using GdUnit4.

{% tabs scene-runner-processing %}
{% tab scene-runner-processing GdScript %}

|Function|Description|
|---|---|
|[simulate_frames](#simulate_frames) | Simulates scene processing for a certain number of frames (respecting time factor).|
|[set_time_factor](#set_time_factor) | Sets how fast or slow the scene simulation is processed (clock ticks versus the real).|
|[move_window_to_foreground](#move_window_to_foreground) | Restores the scene window to a windowed mode and brings it to the foreground.|

{% endtab %}
{% tab scene-runner-processing C# %}

|Function|Description|
|---|---|
|[SimulateFrames](#simulate_frames) | Simulates scene processing for a certain number of frames (respecting time factor).|
|[SetTimeFactor](#set_time_factor) | Sets how fast or slow the scene simulation is processed (clock ticks versus the real).|
|[MoveWindowToForeground](#move_window_to_foreground) | Restores the scene window to a windowed mode and brings it to the foreground.|

{% endtab %}
{% endtabs %}

### simulate_frames

The **simulate_frames** function allows you to simulate the processing and rendering of a specified number of frames in your scene. This is particularly useful for testing and debugging, as it provides a way to advance the scene's state over time without user input or external triggers.

This function is useful when you need to validate behaviors that depend on frame updates, such as animations, physics, and scripted events.<br>
Simulate frame progression in your scene to test animations, interactions, and time-based logic under controlled conditions.<br>

{% tabs scene-runner-simulate_frames %}
{% tab scene-runner-simulate_frames GdScript %}
It takes the following arguments:

```gd
# frames: the number of frames to process
# delta_ms: the time delta between each frame in milliseconds, by default no delay is set.
func simulate_frames(frames: int, delta_ms := -1) -> GdUnitSceneRunner:
```

Here is an example of how to use simulate_frames:

```gd
var runner := scene_runner("res://test_scene.tscn")

# Simulate scene processing over 60 frames at normal speed
await runner.simulate_frames(60)

# Simulate 60 frames with a delay of 100ms between each frame
await runner.simulate_frames(60, 100)
```

{% endtab %}
{% tab scene-runner-simulate_frames C# %}
It takes the following arguments:

```cs
/// <summary>
/// Simulates scene processing for a certain number of frames by given delta peer frame by ignoring the current time factor
/// </summary>
/// <param name="frames">the number of frames to process</param>
/// <param name="deltaPeerFrame">the time delta between each frame in milliseconds, by default no delay is set.</param>
/// <returns>Task to wait</returns>
Task SimulateFrames(uint frames, uint deltaPeerFrame);
```

Here is an example of how to use SimulateFrames:

```cs
ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

// Simulate scene processing over 60 frames at normal speed
await runner.SimulateFrames(60);

// Simulate scene processing over 60 frames with a delay of 100ms between each frame
await runner.SimulateFrames(60, 100);
```

{% endtab %}
{% endtabs %}

### set_time_factor

The **set_time_factor** function adjusts the speed at which the scene simulation is processed relative to real time.<br>
This is useful for testing in different gameplay speeds, debugging time-dependent interactions.

{% tabs scene-runner-set_time_factor %}
{% tab scene-runner-set_time_factor GdScript %}
It takes the following arguments:

```gd
## Sets the time factor for the scene simulation.
## [member time_factor] : A float representing the simulation speed.
## - Default is 1.0, meaning the simulation runs at normal speed.
## - A value of 2.0 means the simulation runs twice as fast as real time.
## - A value of 0.5 means the simulation runs at half the regular speed.
func set_time_factor(time_factor: float = 1.0) -> GdUnitSceneRunner:
```

Here is an example of how to use set_time_factor:

```gd
var runner := scene_runner("res://test_scene.tscn")

# Set the simulation speed to five times faster as the normal speed.
runner.set_time_factor(5)

# Simulated 60 frames ~5 times faster now  
await runner.simulate_frames(60)
```

{% endtab %}
{% tab scene-runner-set_time_factor C# %}
It takes the following arguments:

```cs
/// <summary>
/// Sets how fast or slow the scene simulation is processed (clock ticks versus the real).
/// </summary>
/// <param name="timeFactor"></param>
/// <returns>SceneRunner</returns>
ISceneRunner SetTimeFactor(double timeFactor = 1.0);
```

Here is an example of how to use SetTimeFactor:

```cs
ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");
// Set the simulation speed to five times faster as the normal speed.
runner.SetTimeFactor(5);
// Simulated 60 frames ~5 times faster now  
await runner.SimulateFrames(60);
```

{% endtab %}
{% endtabs %}

### move_window_to_foreground

The **move_window_to_foreground** function restores the scene window to a windowed mode and brings it to the foreground.<br>
This ensures that the scene is visible and active during testing, making it easier to observe and interact with, as the window are minimized or moved to the background after each test.<br>
<br>
This function is essential for scenarios where the scene needs to be actively monitored or interacted with during automated tests. Without it, the scene may not be visible or accessible, which can hinder the debugging process.

{% tabs scene-runner-move_window_to_foreground %}
{% tab scene-runner-move_window_to_foreground GdScript %}

```gd
## Restores the scene window to a windowed mode and brings it to the foreground.
## This ensures that the scene is visible and active during testing, making it easier to observe and interact with.
func move_window_to_foreground() -> GdUnitSceneRunner:
```

Here is an example of how to use move_window_to_foreground:

```gd
var runner := scene_runner("res://test_scene.tscn")

# Shows the running scene and moves the window to the foreground
runner.move_window_to_foreground()
```

{% endtab %}
{% tab scene-runner-move_window_to_foreground C# %}

```cs
/// <summary>
/// Shows the running scene and moves the window to the foreground. 
/// </summary>
void MoveWindowToForeground();
```

Here is an example of how to use MoveWindowToForeground:

```cs
ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");
// Shows the running scene and moves the window to the foreground
runner.MoveWindowToForeground();
```

{% endtab %}
{% endtabs %}

---

## Wait for Function Results

When working with asynchronous programming, you need to wait for a function is completed to get the results to complete before continuing with your program.

{% tabs scene-runner-await-functions %}
{% tab scene-runner-await-functions GdScript %}

|Function|Description|
|---|---|
|[await_func](#await_func) |Waits for the function return value until specified timeout or fails. |
|[await_func_on](#await_func_on) |Waits for the function return value of specified source until specified timeout or fails. |

{% endtab %}
{% tab scene-runner-await-functions C# %}

|Function|Description|
|---|---|
|[AwaitMethod](#await_func) |Waits for the function return value until specified timeout or fails. |
|[AwaitMethodOn](#await_func_on) |Waits for the function return value of specified source until specified timeout or fails. |

{% endtab %}
{% endtabs %}

### await_func

The **await_func** function waits for the function return value until specified timeout or fails.
{% tabs scene-runner-await_func %}
{% tab scene-runner-await_func GdScript %}

It takes the following arguments:

```gd
# func_name: the name of the function we want to wait for
# args : optional function arguments
func await_func(func_name: String, args := []) -> GdUnitFuncAssert:
```

Here is an example of how to use await_func:

```gd
var runner := scene_runner("res://test_scene.tscn")

# Waits until the function `color_cycle()` returns black or fails after an timeout of 5s
await runner.await_func("color_cycle").wait_until(5000).is_equal("black")
```

{% endtab %}
{% tab scene-runner-await_func C# %}

It takes the following arguments:

```cs
/// <summary>
/// Returns a method awaiter to wait for a specific method result.
/// </summary>
/// <typeparam name="V">The expected result type</typeparam>
/// <param name="methodName">The name of the method to wait</param>
/// <returns>GodotMethodAwaiter</returns>
GdUnitAwaiter.GodotMethodAwaiter<V> AwaitMethod<V>(string methodName);
```

Here is an example of how to use AwaitMethod:

```cs
ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

// Waits until the function `color_cycle()` returns black or fails after an timeout of 5s
await runner.AwaitMethod<bool>("color_cycle").IsEqual("black").WithTimeout(5000);
```

{% endtab %}
{% endtabs %}

### await_func_on

The **await_func_on** function waits for the return value of specified function until specified timeout or fails.

{% tabs scene-runner-await_func_on %}
{% tab scene-runner-await_func_on GdScript %}

It takes the following arguments:

```gd
# source: the object where implements the function
# func_name: the name of the function we want to wait for
# args : optional function arguments
func await_func_on(source: Object, func_name: String, args := []) -> GdUnitFuncAssert:
```

Here is an example of how to use await_func_on:

```gd
var runner := scene_runner("res://test_scene.tscn")
# grab the colorRect instance from the scene
var box1: ColorRect = runner.get_property("_box1")

# call function `start_color_cycle` how is emit the signal 
box1.start_color_cycle()

# Waits until the function `has_parent()` on source `door` returns false or fails after an timeout of 100ms
await runner.await_func_on(box1, "panel_color_change", [box1, Color.RED]).wait_until(100).is_false()
```

{% endtab %}
{% tab scene-runner-await_func_on C# %}

It takes the following arguments:

```cs
This function is not yet supported in C#.
```

```cs
```

{% endtab %}
{% endtabs %}

---

## Wait for Signals

When working with asynchronous programming, you often need to wait for signals to emitted before continuing with your program. Here are some ways you can await on signals.

{% tabs scene-runner-signals %}
{% tab scene-runner-signals GdScript %}

|Function|Description|
|---|---|
|[await_signal](#await_signal) | Waits for given signal is emited by the scene until a specified timeout to fail. |
|[await_signal_on](#await_signal_on) | Waits for given signal is emited by the source until a specified timeout to fail. |

{% endtab %}
{% tab scene-runner-signals C# %}

|Function|Description|
|---|---|
|[AwaitSignal](#await_signal) | Waits for given signal is emited by the scene until a specified timeout to fail. |
|[AwaitSignalOn](#await_signal_on) | Waits for given signal is emited by the source until a specified timeout to fail. |

{% endtab %}
{% endtabs %}

### await_signal

The **await_signal** function allows you to wait for a specified signal to be emitted by the scene, until a given timeout is reached.

{% tabs scene-runner-await_signal %}
{% tab scene-runner-await_signal GdScript %}

It takes the following arguments:

```gd
# signal_name: name of the signal to wait for
# args: expected signal arguments as an array
# timeout: timeout in ms (default is 2000ms)
func await_signal(signal_name: String, args := [], timeout := 2000):
```

Here is an example of how to use await_signal:

```gd
var runner := scene_runner("res://test_scene.tscn")
# call function `start_color_cycle` to start the color cycle
runner.invoke("start_color_cycle")

# Wait for the signals `panel_color_change` emitted by the function `start_color_cycle` by a maximum of 100ms or fails
await runner.await_signal("panel_color_change", [box1, Color.RED], 100)
await runner.await_signal("panel_color_change", [box1, Color.BLUE], 100)
await runner.await_signal("panel_color_change", [box1, Color.GREEN], 100)
```

{% endtab %}
{% tab scene-runner-await_signal C# %}

It takes the following arguments:

```cs
/// <summary>
/// Waits for given signal is emited.
/// </summary>
/// <param name="signal">name of the signal to wait for</param>
/// <param name="args">expected signal arguments as an array</param>
/// <returns>Task to wait</returns>
Task AwaitSignal(string signal, params object[] args);
```

Here is an example of how to use AwaitSignal:

```cs
ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");
// call function `start_color_cycle` to start the color cycle
runner.Invoke("start_color_cycle")

// Wait for the signals `panel_color_change` emitted by the function `start_color_cycle` by a maximum of 100ms or fails
await runner.AwaitSignal("panel_color_change", [box1, Color.RED], 100);
await runner.AwaitSignal("panel_color_change", [box1, Color.BLUE], 100);
await runner.AwaitSignal("panel_color_change", [box1, Color.GREEN], 100);
```

{% endtab %}
{% endtabs %}

### await_signal_on

The **await_signal_on** function allows you to wait for a specified signal to be emitted by a specified source, until a given timeout is reached.

{% tabs scene-runner-await_signal_on %}
{% tab scene-runner-await_signal_on GdScript %}

It takes the following arguments:

```gd
# source: the object from which the signal is emitted
# signal_name: name of the signal to wait for
# args: expected signal arguments as an array
# timeout: timeout in ms (default is 2000ms)
func await_signal_on(source: Object, signal_name: String, args := [], timeout := 2000):
```

Here is an example of how to use await_signal_on:

```gd
var runner := scene_runner("res://test_scene.tscn")
# grab the colorRect instance from the scene
var box1: ColorRect = runner.get_property("_box1")

# call function `start_color_cycle` how is emit the signal 
box1.start_color_cycle()

# Wait for the signals `panel_color_change` emitted by the function `start_color_cycle` by a maximum of 100ms or fails
await runner.await_signal_on(box1, "panel_color_change", [box1, Color.RED], 100)
await runner.await_signal_on(box1, "panel_color_change", [box1, Color.BLUE], 100)
await runner.await_signal_on(box1, "panel_color_change", [box1, Color.GREEN], 100)
```

{% endtab %}
{% tab scene-runner-await_signal_on C# %}

```cs
// This function is not yet supported in C#.
```

```cs
```

{% endtab %}
{% endtabs %}

---
<h4> document version v4.4.0 </h4>
