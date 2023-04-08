---
layout: default
title: Scene Runner
parent: Advanced Testing
nav_order: 6
---

# Scene Runner

## Definition
The Scene Runner is a tool used for simulating interactions on a scene. With this tool, you can simulate input events such as keyboard or mouse input and/or simulate scene processing over a certain number of frames. This tool is typically used for integration testing a scene.


## How to Use It
The Scene Runner is managed by the GdUnit API and is automatically freed after use. One Scene Runner can only manage one scene. If you need to test multiple scenes, you must create a separate runner for each scene in your test suite.

{% tabs scene-runner-definition %}
{% tab scene-runner-definition GdScript %}
To use the Scene Runner, load the scene to be tested with **scene_runner(\<scene\>)**.
```ruby
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
```ruby
    func test_simulate_frames(timeout = 5000) -> void:
        # Create the scene runner for scene `test_scene.tscn`
        var runner := scene_runner("res://test_scene.tscn")

        # Get access to scene property '_box1'
        var box1 :ColorRect = runner.get_property("_box1")
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


* [How to Simulate Key and Mouse Interactions](/gdUnit4/advanced_testing/sceneRunner/#how-to-simulate-key-and-mouse-interactions)<br>
* [Await for Signals or Function Results](/gdUnit4/advanced_testing/sceneRunner/#await-for-signals-or-function-results)<br>
* [Scene Accessors and Time Manipulation](/gdUnit4/advanced_testing/sceneRunner/#scene-accessors-and-time-manipulation)<br>

For more advanced example, see [Tutorial - Testing Scenes](/gdUnit4/tutorials/tutorial_scene_runner/#using-scene-runner)

## Function Overview

{% tabs scene-runner-overview %}
{% tab scene-runner-overview GdScript %}
|Function|Description|
|---|---|
|[simulate_key_pressed](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_pressed) | Simulates that a key has been pressed. |
|[simulate_key_press](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_press) | Simulates that a key is pressed. |
|[simulate_key_release](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_release) | Simulates that a key has been released. |
|[simulate_mouse_move](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_move) | Simulates a mouse moved to final position. |
|[simulate_mouse_move_relative](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_move_relative) | Simulates a mouse move by an offset and speed. |
|[simulate_mouse_button_pressed](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_pressed) | Simulates a mouse button pressed. |
|[simulate_mouse_button_press](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_press) | Simulates a mouse button press (holding). |
|[simulate_mouse_button_release](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_release) | Simulates a mouse button released. |
|[simulate_frames](/gdUnit4/advanced_testing/sceneRunner/#simulate_frames) | Simulates scene processing for a certain number of frames (respecting time factor).|
|[set_mouse_pos](/gdUnit4/advanced_testing/sceneRunner/#set_mouse_pos) | Sets the mouse cursor to given position relative to the viewport.|
|[await_signal](/gdUnit4/advanced_testing/sceneRunner/#await_signal) | Waits for given signal is emited by the scene until a specified timeout to fail. |
|[await_signal_on](/gdUnit4/advanced_testing/sceneRunner/#await_signal_on) | Waits for given signal is emited by the source until a specified timeout to fail. |
|[await_func](/gdUnit4/advanced_testing/sceneRunner/#await_func) |Waits for the function return value until specified timeout or fails. |
|[await_func_on](/gdUnit4/advanced_testing/sceneRunner/#await_func_on) |Waits for the function return value of specified source until specified timeout or fails. |
|[get_property](/gdUnit4/advanced_testing/sceneRunner/#get_property) | Return the current value of a property. |
|[find_child](/gdUnit4/advanced_testing/sceneRunner/#find_child) | Searches for the specified node with the name in the current scene. |
|[invoke](/gdUnit4/advanced_testing/sceneRunner/#invoke) | Executes the function specified by name in the scene and returns the result. |
|[set_time_factor](/gdUnit4/advanced_testing/sceneRunner/#set_time_factor) | Sets how fast or slow the scene simulation is processed (clock ticks versus the real).|
|[maximize_view](/gdUnit4/advanced_testing/sceneRunner/#maximize_view) | maximizes the window to bring the scene visible.|
{% endtab %}
{% tab scene-runner-overview C# %}
|Function|Description|
|---|---|
|[SimulateKeyPressed](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_pressed) | Simulates that a key has been pressed. |
|[SimulateKeyPress](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_press) | Simulates that a key is pressed. |
|[SimulateKeyRelease](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_release) | Simulates that a key has been released. |
|[SimulateMouseMove](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_move) | Simulates a mouse moved to final position. |
|[SimulateMouseButtonPressed](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_pressed) | Simulates a mouse button pressed. |
|[SimulateMouseButtonPress](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_press) | Simulates a mouse button press (holding). |
|[SimulateMouseButtonRelease](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_release) | Simulates a mouse button released. |
|[SimulateFrames](/gdUnit4/advanced_testing/sceneRunner/#simulate_frames) | Simulates scene processing for a certain number of frames (respecting time factor).|
|[SetMousePos](/gdUnit4/advanced_testing/sceneRunner/#set_mouse_pos) | Sets the mouse cursor to given position relative to the viewport.|
|[AwaitSignal](/gdUnit4/advanced_testing/sceneRunner/#await_signal) | Waits for given signal is emited by the scene until a specified timeout to fail. |
|[AwaitSignalOn](/gdUnit4/advanced_testing/sceneRunner/#await_signal_on) | Waits for given signal is emited by the source until a specified timeout to fail. |
|[AwaitMethod](/gdUnit4/advanced_testing/sceneRunner/#await_func) |Waits for the function return value until specified timeout or fails. |
|[AwaitMethodOn](/gdUnit4/advanced_testing/sceneRunner/#await_func_on) |Waits for the function return value of specified source until specified timeout or fails. |
|[GetProperty](/gdUnit4/advanced_testing/sceneRunner/#get_property) | Return the current value of a property. |
|[FindChild](/gdUnit4/advanced_testing/sceneRunner/#find_child) | Searches for the specified node with the name in the current scene. |
|[Invoke](/gdUnit4/advanced_testing/sceneRunner/#invoke) | Executes the function specified by name in the scene and returns the result. |
|[SetTimeFactor](/gdUnit4/advanced_testing/sceneRunner/#set_time_factor) | Sets how fast or slow the scene simulation is processed (clock ticks versus the real).|
|[MoveWindowToForeground](/gdUnit4/advanced_testing/sceneRunner/#maximize_view) | maximizes the window to bring the scene visible.|
{% endtab %}
{% endtabs %}

## How to Simulate Key and Mouse Interactions
To simulate key or mouse interactions, you can use the provided key and mouse simulate functions.<br>
We distinguish between *finalized* and *unfinished* functions.


* Finalized Functions<br>
    A finalized function is used to simulate a key or mouse press and release in combination.
    * [simulate_key_pressed](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_pressed)
    * [simulate_mouse_button_pressed](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_pressed)
    * [set_mouse_pos](/gdUnit4/advanced_testing/sceneRunner/#set_mouse_pos)
    * [simulate_mouse_move](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_move)
    * [simulate_mouse_move_relative](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_move_relative)


* Unfinished Functions<br>
    An unfinished function is used to simulate a key or mouse press. This is typically used to simulate a key-mouse combination, such as pressing a shortcut. The unfinished function is later finalized by a key or mouse release function.
    * [simulate_key_press](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_press)
    * [simulate_key_release](/gdUnit4/advanced_testing/sceneRunner/#simulate_key_release)
    * [simulate_mouse_button_press](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_press)
    * [simulate_mouse_button_release](/gdUnit4/advanced_testing/sceneRunner/#simulate_mouse_button_release)

{% include advice.html 
content="To complete the input events, you always need to process a minimum of one frame cycle. You can do this by using the `await await_idle_frame()` function."
%}
More details about specific key and mouse functions can be found below in this document.


### simulate_key_pressed
The **simulate_key_pressed** function is used to simulate that a key has been pressed.

{% tabs scene-runner-simulate_key_pressed %}
{% tab scene-runner-simulate_key_pressed GdScript %}
It takes the following arguments:
```ruby
    # key_code: an integer value representing the key code of the key being pressed, e.g. KEY_ENTER for the enter key.
    # shift: a boolean value indicating whether the shift key should be simulated as being pressed along with the main key. It is false by default.
    # control: a boolean value indicating whether the control key should be simulated as being pressed along with the main key. It is false by default.
    func simulate_key_pressed(<key_code> :int, [shift] := false, [control] := false) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_key_pressed:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Simulate the enter key is pressed
    runner.simulate_key_pressed(KEY_ENTER)
    await await_idle_frame()

    # Simulates key combination ctrl+C is pressed
    runner.simulate_key_pressed(KEY_C, false, true)
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_key_pressed C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates that a key has been pressed.
    /// </summary>
    /// <param name="keyCode">an integer value representing the key code of the key being pressed, e.g. KEY_ENTER for the enter key.</param>
    /// <param name="shift">a boolean value indicating whether the shift key should be simulated as being pressed along with the main key. It is false by default.</param>
    /// <param name="control">a boolean value indicating whether the control key should be simulated as being pressed along with the main key. It is false by default.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateKeyPressed(KeyList keyCode, bool shift = false, bool control = false);
```
Here is an example of how to use SimulateKeyPressed:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Simulate the enter key is pressed
    runner.SimulateKeyPressed(KeyList.Enter);
    await AwaitIdleFrame();

    // Simulates key combination ctrl+C is pressed
    runner.SimulateKeyPressed(KeyList.C, false, true);
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}
In this example, we simulate that the enter key is pressed and then we simulate that the key combination ctrl+C is pressed. We use **await_idle_frame()** to ensure that the simulation of the key press is complete before moving on to the next instruction.



### simulate_key_press
The **simulate_key_press** function is used to simulate that a key holding down.

{% tabs scene-runner-simulate_key_press %}
{% tab scene-runner-simulate_key_press GdScript %}
It takes the following arguments:
```ruby
    # key_code : an integer value representing the key code of the key being press e.g. KEY_ENTER for the enter key.
    # shift : a boolean value indicating whether the shift key should be simulated as being press along with the main key. It is false by default.
    # control : a boolean value indicating whether the control key should be simulated as being press along with the main key. It is false by default.
    func simulate_key_press(<key_code> :int, [shift] := false, [control] := false) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_key_press:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Simulate the enter key is press
    runner.simulate_key_press(KEY_ENTER)
    await await_idle_frame()

    # Simulates key combination ctrl+C is press in one function call
    runner.simulate_key_press(KEY_C, false, true)
    await await_idle_frame()

    # Simulates multi key combination ctrl+alt+C is press
    runner.simulate_key_press(KEY_CTRL)
    runner.simulate_key_press(KEY_ALT)
    runner.simulate_key_press(KEY_C)
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_key_press c# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates that a key is press.
    /// </summary>
    /// <param name="keyCode">an integer value representing the key code of the key being press, e.g. KeyList.Enter for the enter key.</param>
    /// <param name="shift">a boolean value indicating whether the shift key should be simulated as being press along with the main key. It is false by default.</param>
    /// <param name="control">a boolean value indicating whether the control key should be simulated as being press along with the main key. It is false by default.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateKeyPress(KeyList keyCode, bool shift = false, bool control = false);
```
Here is an example of how to use SimulateKeyPress:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Simulate the enter key is press
    runner.SimulateKeyPress(KeyList.Enter);
    await AwaitIdleFrame();

    // Simulates key combination ctrl+C is press in one method call
    runner.SimulateKeyPress(KeyList.C, false. true);
    await AwaitIdleFrame();

    // Simulates multi key combination ctrl+alt+C is press
    runner.SimulateKeyPress(KeyList.CTRL);
    runner.SimulateKeyPress(KeyList.ALT);
    runner.SimulateKeyPress(KeyList.C);
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}
In this example, we simulate that the enter key is press and then we simulate that the key combination ctrl+C is press. We use **await_idle_frame()** to ensure that the simulation of the key press is complete before moving on to the next instruction.



### simulate_key_release
The **simulate_key_release** function is used to simulate that a key has been released.

{% tabs scene-runner-simulate_key_release %}
{% tab scene-runner-simulate_key_release GdScript %}
It takes the following arguments:
```ruby
    # key_code : an integer value representing the key code of the key being released, e.g. KEY_ENTER for the enter key.
    # shift : a boolean value indicating whether the shift key should be simulated as being released along with the main key. It is false by default.
    # control : fa boolean value indicating whether the control key should be simulated as being released along with the main key. It is false by default.
    func simulate_key_release(<key_code> :int, [shift] := false, [control] := false) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_key_release:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    
    # Simulate a enter key is released
    runner.simulate_key_release(KEY_ENTER)
    await await_idle_frame()

    # Simulates key combination ctrl+C is released in one function call
    runner.simulate_key_release(KEY_C, false, true)
    await await_idle_frame()

    # Simulates multi key combination ctrl+alt+C is released
    runner.simulate_key_release(KEY_CTRL)
    runner.simulate_key_release(KEY_ALT)
    runner.simulate_key_release(KEY_C)
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_key_release C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates that a key has been released.
    /// </summary>
    /// <param name="keyCode">an integer value representing the key code of the key being released, e.g. KeyList.Enter for the enter key.</param>
    /// <param name="shift">a boolean value indicating whether the shift key should be simulated as being released along with the main key. It is false by default.</param>
    /// <param name="control">a boolean value indicating whether the control key should be simulated as being released along with the main key. It is false by default.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateKeyRelease(KeyList keyCode, bool shift = false, bool control = false);
```
Here is an example of how to use SimulateKeyRelease:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Simulate a enter key is released
    runner.SimulateKeyRelease(KeyList.Enter);
    await AwaitIdleFrame();

    // Simulates key combination ctrl+C is released
    runner.SimulateKeyRelease(KeyList.C, false, true);
    await AwaitIdleFrame();

    // Simulates multi key combination ctrl+C is released
    runner.SimulateKeyRelease(KeyList.CTRL);
    runner.SimulateKeyRelease(KeyList.ALT);
    runner.SimulateKeyRelease(KeyList.C);
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}
In this example, we simulate that the enter key is released and then we simulate that the key combination ctrl+C is released. We use **await_idle_frame()** to ensure that the simulation of the key press is complete before moving on to the next instruction.




### set_mouse_pos
The **set_mouse_pos** function is used to simulate set the mouse cursor to given position relative to the viewport.

{% tabs scene-runner-set_mouse_pos %}
{% tab scene-runner-set_mouse_pos GdScript %}
It takes the following arguments:
```ruby
    # pos: the new position relative to the viewport
    func set_mouse_pos(<pos> :Vector2) -> GdUnitSceneRunner:
```
Here is an example of how to use set_mouse_pos:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    
    # sets the current mouse position to 100, 100
    runner.set_mouse_pos(Vector2(100, 100))
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-set_mouse_pos C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Sets the actual mouse position relative to the viewport.
    /// </summary>
    /// <param name="position">The position in x/y coordinates</param>
    /// <returns></returns>
    ISceneRunner SetMousePos(Vector2 position);
```
Here is an example of how to use SetMousePos:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // sets the current mouse position to 100, 100
    runner.SetMousePos(new Vector2(100, 100));
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}



### simulate_mouse_move
The **simulate_mouse_move** function is used to simulate the movement of the mouse cursor to a given position on the screen.

{% tabs scene-runner-simulate_mouse_move %}
{% tab scene-runner-simulate_mouse_move GdScript %}
It takes the following arguments:
```ruby
    # position: representing the final position of the mouse cursor after the movement is completed
    func simulate_mouse_move(<position> :Vector2) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_mouse_move:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    
    # Set mouse position to a inital position
    runner.set_mouse_pos(Vector2(160, 20))
    await await_idle_frame()

    # Simulates a mouse move to final position 200, 40
    runner.simulate_mouse_move(Vector2(200, 40))
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_mouse_move C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates a mouse moved to final position.
    /// </summary>
    /// <param name="position">representing the final position of the mouse cursor after the movement is completed).</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseMove(Vector2 position);
```
Here is an example of how to use SimulateMouseMove:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    # Set the mouse position to a inital position
    runner.SetMousePos(new Vector2(160, 20))
    await AwaitIdleFrame();

    # simulates a mouse move to final position 200,40
    runner.SimulateMouseMove(new Vector2(200, 40))
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}



### simulate_mouse_move_relative
The **simulate_mouse_move_relative** function is used to simulate a mouse move by given offset and speed to the final position.

{% tabs scene-runner-simulate_mouse_move_relative %}
{% tab scene-runner-simulate_mouse_move_relative GdScript %}
It takes the following arguments:
```ruby
    # relative: The relative position, e.g. the mouse position offset
    # speed : The mouse speed in pixels per second, the default is Vector2.ONE.
    func simulate_mouse_move_relative(<relative> :Vector2, [speed] :Vector2) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_mouse_move_relative:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    
    # Set mouse position to a inital position
    runner.set_mouse_pos(Vector2(10, 20))
    await await_idle_frame()

    # Simulates a full mouse move from current position + the given offset (400, 200) with a speed of (.2, 1)
    # the final position will be (410, 220) when is completed
    awati runner.simulate_mouse_move_relative(Vector2(400, 200), Vector2(.2, 1))
    await await_idle_frame()
```
{% endtab %}
{% endtabs %}


### simulate_mouse_button_pressed
The **simulate_mouse_button_pressed** function is used to simulatethat a mouse button is pressed.

{% tabs scene-runner-simulate_mouse_button_pressed %}
{% tab scene-runner-simulate_mouse_button_pressed GdScript %}
It takes the following arguments:
```ruby
    # buttonIndex: The mouse button identifier, one of the ButtonList button or button wheel constants.
    # double_click: set to true to simmulate a doubleclick
    func simulate_mouse_button_pressed(<buttonIndex> :int, [double_click] :=false) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_mouse_button_pressed:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Simulates pressing the left mouse button
    runner.simulate_mouse_button_pressed(BUTTON_LEFT)
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_mouse_button_pressed C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates a mouse button pressed.
    /// </summary>
    /// <param name="button">The mouse button identifier, one of the ButtonList button or button wheel constants.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseButtonPressed(ButtonList button);
```
Here is an example of how to use SimulateMouseButtonPressed:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Simulates pressing the left mouse button
    runner.SimulateMouseButtonPressed(ButtonList.Left);
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}



### simulate_mouse_button_press
The **simulate_mouse_button_press** function is used to simulate holding down a mouse button.

{% tabs scene-runner-simulate_mouse_button_press %}
{% tab scene-runner-simulate_mouse_button_press GdScript %}
It takes the following arguments:
```ruby
    # buttonIndex: The mouse button identifier, one of the ButtonList button or button wheel constants.
    # double_click: Set to true to simmulate a doubleclick
    func simulate_mouse_button_press(<buttonIndex> :int, [double_click] :=false) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_mouse_button_press:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # simulates mouse left button is press
    runner.simulate_mouse_button_press(BUTTON_LEFT)
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_mouse_button_press C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates a mouse button press. (holding)
    /// </summary>
    /// <param name="button">The mouse button identifier, one of the ButtonList button or button wheel constants.</param>
    /// <param name="doubleClick">Set to true to simmulate a doubleclick.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseButtonPress(ButtonList button);
```
Here is an example of how to use SimulateMouseButtonPress:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // simulates mouse left button is press
    runner.SimulateMouseButtonPress(ButtonList.Left);
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}



### simulate_mouse_button_release
The **simulate_mouse_button_release** function is used to simulate a mouse button is released.

{% tabs scene-runner-simulate_mouse_button_release %}
{% tab scene-runner-simulate_mouse_button_release GdScript %}
It takes the following arguments:
```ruby
    # buttonIndex: The mouse button identifier, one of the ButtonList button or button wheel constants.
    func simulate_mouse_button_release(<buttonIndex> :int) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_mouse_button_release:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Simulates a mouse left button is released
    runner.simulate_mouse_button_release(BUTTON_LEFT)
    await await_idle_frame()
```
{% endtab %}
{% tab scene-runner-simulate_mouse_button_release C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Simulates a mouse button released.
    /// </summary>
    /// <param name="button">The mouse button identifier, one of the ButtonList button or button wheel constants.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseButtonRelease(ButtonList button);
```
Here is an example of how to use SimulateMouseButtonRelease:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Simulates a mouse left button is released
    runner.SimulateMouseButtonRelease(ButtonList.Left);
    await AwaitIdleFrame();
```
{% endtab %}
{% endtabs %}



### simulate_frames
The **simulate_frames** function simulates the processing of a certain number of frames in a scene, taking into account the configured time factor.

{% tabs scene-runner-simulate_frames %}
{% tab scene-runner-simulate_frames GdScript %}
It takes the following arguments:
```ruby
    # frames: the number of frames to process
    # delta_milli: the time delta between each frame in milliseconds, by default no delay is set.
    func simulate_frames(<frames> :int, [delta_milli] := -1) -> GdUnitSceneRunner:
```
Here is an example of how to use simulate_frames:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Simulate scene processing over 60 frames
    await runner.simulate_frames(60)

    # Simulate scene processing over 60 frames with a delay of 100ms between each frame
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

    // Simulate scene processing over 60 frames
    await runner.SimulateFrames(60);

    // Simulate scene processing over 60 frames with a delay of 100ms between each frame
    await runner.SimulateFrames(60, 100);
```
{% endtab %}
{% endtabs %}



## Await for Signals or Function Results
When working with asynchronous programming, you often need to wait for signals or function results to complete before continuing with your program. Here are some ways you can await signals or function results by using the SceneRunner.

### await_signal
The **await_signal** function allows you to wait for a specified signal to be emitted by the scene, until a given timeout is reached.

{% tabs scene-runner-await_signal %}
{% tab scene-runner-await_signal GdScript %}
It takes the following arguments:
```ruby
    # signal_name: name of the signal to wait for
    # args: expected signal arguments as an array
    # timeout: timeout in ms (default is 2000ms)
    func await_signal(<signal_name> :String, [args] := [], [timeout] := 2000):
```
Here is an example of how to use await_signal:
```ruby
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
    /// <param anme="args">expected signal arguments as an array</param>
    /// <returns>Task to wait</returns>
    Task AwaitSignal(string signal, params object[] args);
```
Here is an example of how to use AwaitSignal:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");
    # call function `start_color_cycle` to start the color cycle
    runner.Invoke("start_color_cycle")

    # Wait for the signals `panel_color_change` emitted by the function `start_color_cycle` by a maximum of 100ms or fails
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
```ruby
    # source: the object from which the signal is emitted
    # signal_name: name of the signal to wait for
    # args: expected signal arguments as an array
    # timeout: timeout in ms (default is 2000ms)
    func await_signal_on(<source> :Object, <signal_name> :String, [args] := [], [timeout] := 2000):
```
Here is an example of how to use await_signal_on:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    # grab the colorRect instance from the scene
    var box1 :ColorRect = runner.get_property("_box1")
    
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
    This function is not yet supported in C#.
```
```cs
```
{% endtab %}
{% endtabs %}



### await_func
The **await_func** function waits for the function return value until specified timeout or fails.
{% tabs scene-runner-await_func %}
{% tab scene-runner-await_func GdScript %}
It takes the following arguments:
```ruby
    # func_name: the name of the function we want to wait for
    # args : optional function arguments
    func await_func(<func_name> :String, [args] := []) -> GdUnitFuncAssert:
```
Here is an example of how to use await_func:
```ruby
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
```ruby
    # source: the object where implements the function
    # func_name: the name of the function we want to wait for
    # args : optional function arguments
    func await_func_on(<source> :Object, <func_name> :String, [args] := []) -> GdUnitFuncAssert:
```
Here is an example of how to use await_func_on:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    # grab the colorRect instance from the scene
    var box1 :ColorRect = runner.get_property("_box1")
    
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


## Scene Accessors and Time Manipulation
In addition to simulating the scene, the SceneRunner provides functions to access the scene's nodes and manipulate time. These functions are useful for debugging and testing purposes.

For example, you can use **find_child()** to retrieve a specific node in the scene, and then call its methods or change its properties to test its behavior. You can also use **set_time_factor()** to adjust the speed at which the scene runs, making it faster or slower than real-time to test different scenarios.

By using these functions, you can gain greater control over the scene and test various scenarios, making it easier to find and fix bugs and improve the overall quality of your game or application.

### get_property
The **get_property** function returns the current value of the property from the current scene.

{% tabs scene-runner-get_property %}
{% tab scene-runner-get_property GdScript %}
It takes the following arguments:
```ruby
    # name: name of property
    # returns the actual value of the property
    func get_property(<name> :String) -> Variant:
```
Here is an example of how to use get_property:
```ruby
    var runner := scene_runner("res://test_scene.tscn")
    
    # Returns the current property `_door_color` from the scene
    var color :ColorRect = runner.get_property("_door_color")
```
{% endtab %}
{% tab scene-runner-get_property C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Returns the property by given name.
    /// </summary>
    /// <typeparam name="T">The type of the property</typeparam>
    /// <param name="name">The parameter name</param>
    /// <returns>The value of the property or throws a MissingFieldException</returns>
    /// <exception cref="MissingFieldException"/>
    public T GetProperty<T>(string name);
```
Here is an example of how to use GetProperty:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Returns the current property `_door_color` from the scene
    ColorRect color = runner.GetProperty("_door_color");
```
{% endtab %}
{% endtabs %}



### find_child
The **find_child** function searches for a node with the specified name in the current scene and returns it. If the node is not found, it returns null.

{% tabs scene-runner-find_child %}
{% tab scene-runner-find_child GdScript %}
```ruby
    ## [member name] : the name of the node to find
    ## [member recursive] : enables/disables seraching recursive
    ## [member owned] : is set to true it only finds nodes who have an assigned owner
    ## [member return] : the node if find otherwise null
    func find_child(<name> :String, [recursive] := true, [owned] := false) -> Node:
```
Here is an example of how to use find_child:
```ruby
	var runner := scene_runner("res://test_scene.tscn")
	
	# Searchs for node `Spell` inside the scene tree
	var spell:Node = runner.find_child("Spell")
```
{% endtab %}
{% tab scene-runner-find_child C# %}
```cs
    This function is not yet supported in C#.
```
```cs
```
{% endtab %}
{% endtabs %}



### invoke
The **invoke** function runs the function specified by given name in the scene and returns the result.

{% tabs scene-runner-invoke %}
{% tab scene-runner-invoke GdScript %}
It takes the following arguments:
```ruby
    # name: the name of the function to execute
    # optional function args 0..9
    # return: the function result
    func invoke(name :String, arg0=NO_ARG, arg1=NO_ARG, arg2=NO_ARG, arg3=NO_ARG, arg4=NO_ARG, arg5=NO_ARG, arg6=NO_ARG, arg7=NO_ARG, arg8=NO_ARG, arg9=NO_ARG):
```
Here is an example of how to use invoke:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Invokes the function `start_color_cycle`
    runner.invoke("start_color_cycle")
```
{% endtab %}
{% tab scene-runner-invoke C# %}
It takes the following arguments:
```cs
    /// <summary>
    /// Invokes the method by given name and arguments.
    /// </summary>
    /// <param name="name">The name of method to invoke</param>
    /// <param name="args">The function arguments</param>
    /// <returns>The return value of invoked method</returns>
    /// <exception cref="MissingMethodException"/>
    public object Invoke(string name, params object[] args);
```
Here is an example of how to use Invoke:
```cs
    ISceneRunner runner = ISceneRunner.Load("res://test_scene.tscn");

    // Invokes the function `start_color_cycle`
    runner.Invoke("start_color_cycle");
```
{% endtab %}
{% endtabs %}


### maximize_view
The **maximize_view** maximizes the window to make the scene visible, sensibly set for debugging reasons to see the scene output.

{% tabs scene-runner-maximize_view %}
{% tab scene-runner-maximize_view GdScript %}
```ruby
    func maximize_view() -> GdUnitSceneRunner:
```
Here is an example of how to use maximize_view:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Shows the running scene and moves the window to the foreground
    runner.maximize_view()
```
{% endtab %}
{% tab scene-runner-maximize_view C# %}
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



### set_time_factor
The **set_time_factor** function sets how fast or slow the scene simulation is processed (clock ticks versus the real).

{% tabs scene-runner-set_time_factor %}
{% tab scene-runner-set_time_factor GdScript %}
It takes the following arguments:
```ruby
    # It defaults to 1.0. A value of 2.0 means the game moves twice as fast as real life,
    # whilst a value of 0.5 means the game moves at half the regular speed.
    func set_time_factor(<time_factor> := 1.0) -> GdUnitSceneRunner:
```
Here is an example of how to use set_time_factor:
```ruby
    var runner := scene_runner("res://test_scene.tscn")

    # Sets time factor to 5 
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
    // Sets time factor to 5 
    runner.SetTimeFactor(5);
    // Simulated 60 frames ~5 times faster now  
    await runner.SimulateFrames(60);
```
{% endtab %}
{% endtabs %}

---
<h4> document version v4.1.0 </h4>