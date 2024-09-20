---
layout: default
title: Touchscreen Inputs
parent: Scene Runner
grand_parent: Advanced Testing
nav_order: 4
---

# Simulate Touchscreen Inputs

This page provides guidance on how to test touchscreen inputs in your scene using GdUnit4.
For more detailed information on Godot touchscreen events, please refer to the [official Godot documentation](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html#touch-events){:target="_blank"}

## Function Overview

All functions listed below utilize the listed classes to simulate touchscreen input events.

* [InputEventScreenTouch](https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html#class-inputeventscreentouch){:target="_blank"}
* [InputEventScreenDrag](https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html){:target="_blank"}

{% tabs scene-runner-overview %}
{% tab scene-runner-overview GdScript %}

|Function|Description|
|---|---|
|[get_screen_touch_drag_position](#get_screen_touch_drag_position)| Returns the actual position of the touch drag position by given index. |
|[simulate_screen_touch_drag](#simulate_screen_touch_drag)| Simulates a touch screen drag event to given position. |
|[simulate_screen_touch_pressed](#simulate_screen_touch_pressed)| Simulates a screen touch is pressed. |
|[simulate_screen_touch_press](#simulate_screen_touch_press)|Simulates a screen touch is press (holding). |
|[simulate_screen_touch_release](#simulate_screen_touch_release)| Simulates a screen touch is released. |
|[simulate_screen_touch_drag_relative](#simulate_screen_touch_drag_relative)| Simulates a touch screen drag&drop to the relative coordinates (offset). |
|[simulate_screen_touch_drag_absolute](#simulate_screen_touch_drag_absolute)| Simulates a touch screen drop to the absolute coordinates. |
|[simulate_screen_touch_drag_drop](#simulate_screen_touch_drag_drop)| Simulates a touch screen drop&drop to the absolute coordinates. |

{% endtab %}
{% tab scene-runner-overview C# %}

|Function|Description|
|---|---|

Not yet implemented!

{% endtab %}
{% endtabs %}

## How to Simulate Touchscreen Interactions

To simulate touchscreen interactions in your scene, you can use the provided touchscreen simulation functions. These functions allow you to mimic user touchscreen inputs for testing purposes. There are two main categories of functions:

* **Unfinished Functions**<br>
    Unfinished functions simulate ongoing touch actions without completing them immediately. They are ideal for scenarios where you need to simulate multi-touch interactions, such as holding down one finger while using another to perform gestures. The interaction is completed by calling a corresponding release function.

  * **[simulate_screen_touch_press](#simulate_screen_touch_press)**<br>
    Simulates a finger pressing down on the screen at a specified position.<br>
  * **[simulate_screen_touch_release](#simulate_screen_touch_release)**<br>
    Simulates a finger being lifted off the screen from a previously pressed position.

* **Finalized Functions**<br>
    Finalized functions simulate complete touchscreen actions, encompassing both the press and release events in a single function call. These are useful for simulating single-tap actions or gestures like swipes and drags.

  * **[get_screen_touch_drag_position](#get_screen_touch_drag_position)**<br>
    Retrieves the current drag position of a touchscreen input.<br>
  * **[simulate_screen_touch_drag](#simulate_screen_touch_drag)**<br>
    Simulates a drag gesture to a position.<br>
  * **[simulate_screen_touch_pressed](#simulate_screen_touch_pressed)**<br>
    Simulates a full press-and-release action at a specified position, mimicking a tap.<br>
  * **[simulate_screen_touch_drag_relative](#simulate_screen_touch_drag_relative)**<br>
    Simulates a drag gesture by moving the touch input relative to its current position.<br>
  * **[simulate_screen_touch_drag_absolute](#simulate_screen_touch_drag_absolute)**<br>
    Simulates a drag gesture by moving the touch input to an absolute position.<br>
  * **[simulate_screen_touch_drag_drop](#simulate_screen_touch_drag_drop)**<br>
    Simulates a drag-and-drop action, where a touch input is pressed, dragged to a target position, and then released.
  
{% include advice.html
content="To ensure input events are processed correctly, you must wait at least one frame cycle after simulating inputs. Use the <b>await await_input_processed()</b> function to accomplish this."
%}
See [Synchronize Inputs Events](/gdUnit4/advanced_testing/scene_runner/sync_inputs/#synchronize-inputs-events)

---

### get_screen_touch_drag_position

We use **[await_input_processed()](/gdUnit4/advanced_testing/scene_runner/sync_inputs/#synchronize-inputs-events)** to ensure that the simulation of the touchscreen input is complete before moving on to the next instruction.

### simulate_screen_touch_pressed

### simulate_screen_touch_press

### simulate_screen_touch_release

### simulate_screen_touch_drag_relative

### simulate_screen_touch_drag_absolute

### simulate_screen_touch_drag_drop

### simulate_screen_touch_drag

---
<h4> document version v4.4.0 </h4>
