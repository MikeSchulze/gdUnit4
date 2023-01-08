---
layout: default
title: Scene Runner
parent: Advanced Testing
nav_order: 1
---

# Scene Runner

### Definition
A Scene Runner is a tool for simulating interactions on a scene. With this tool you can simulate input events like keyboard or mouse or/and simulate scene processing over a certain number of frames. This is typical used for integration testing a scene.

### How to use it
The scene runner is managed by the GdUnit API and is automatically freed after use.
One scene runner can only manage one scene, if you need more you have to create a separate runner for each scene in you test-suite.

{% tabs scene-runner-definition %}
{% tab scene-runner-definition GdScript %}
Use the scene runner with **scene_runner(\<scene\>)** in which you load the scene to be tested.
```ruby
    var runner := scene_runner("res://my_scene.tscn")
```
{% endtab %}
{% tab scene-runner-definition C# %}
Use the scene runner with **ISceneRunner.Load(\<scene\>)** in which you load the scene to be tested.
```cs
    ISceneRunner runner = ISceneRunner.Load("res://my_scene.tscn");
```
{% endtab %}
{% endtabs %}


{% include advice.html
content="You need to complete key or mouse simulations finally a minimum of one frame to complete the input event!<br>
You have to add `yield(await_idle_frame(), 'completed')`"
%}


For more advanced example, see [Tutorial - Testing Scenes](/gdUnit3/tutorials/tutorial_scene_runner/#using-scene-runner)

### Function Overview

{% tabs scene-runner-overview %}
{% tab scene-runner-overview GdScript %}
|Function|Description|
|---|---|
|[simulate_key_pressed](/gdUnit3/advanced_testing/sceneRunner/#simulate_key_pressed) | Simulates that a key has been pressed |
|[simulate_key_press](/gdUnit3/advanced_testing/sceneRunner/#simulate_key_press) | Simulates that a key is pressed |
|[simulate_key_release](/gdUnit3/advanced_testing/sceneRunner/#simulate_key_release) | Simulates that a key has been released |
|[simulate_mouse_move](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_move) | Simulates a mouse moved to final position |
|[simulate_mouse_move_relative](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_move_relative) | Simulates a mouse move by an offset and speed |
|[simulate_mouse_button_pressed](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_button_pressed) | Simulates a mouse button pressed |
|[simulate_mouse_button_press](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_button_press) | Simulates a mouse button press (holding) |
|[simulate_mouse_button_release](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_button_release) | Simulates a mouse button released |
|[simulate_frames](/gdUnit3/advanced_testing/sceneRunner/#simulate_frames) | Simulates scene processing for a certain number of frames (respecting time factor)|
|[set_mouse_pos](/gdUnit3/advanced_testing/sceneRunner/#set_mouse_pos) | Sets the mouse cursor to given position relative to the viewport.|
|[await_signal](/gdUnit3/advanced_testing/sceneRunner/#await_signal) | Waits for given signal is emited by the scene until a specified timeout to fail |
|[await_signal_on](/gdUnit3/advanced_testing/sceneRunner/#await_signal_on) | Waits for given signal is emited by the source until a specified timeout to fail |
|[await_func](/gdUnit3/advanced_testing/sceneRunner/#await_func) |Waits for the function return value until specified timeout or fails |
|[await_func_on](/gdUnit3/advanced_testing/sceneRunner/#await_func_on) |Waits for the function return value of specified source until specified timeout or fails |
|[get_property](/gdUnit3/advanced_testing/sceneRunner/#get_property) | Return the current value of a property |
|[invoke](/gdUnit3/advanced_testing/sceneRunner/#invoke) | Executes the function specified by name in the scene and returns the result |
|[set_time_factor](/gdUnit3/advanced_testing/sceneRunner/#set_time_factor) | Sets how fast or slow the scene simulation is processed (clock ticks versus the real).|
|[maximize_view](/gdUnit3/advanced_testing/sceneRunner/#maximize_view) | maximizes the window to bring the scene visible|
{% endtab %}
{% tab scene-runner-overview C# %}
|Function|Description|
|---|---|
|[SimulateKeyPressed](/gdUnit3/advanced_testing/sceneRunner/#simulate_key_pressed) | Simulates that a key has been pressed |
|[SimulateKeyPress](/gdUnit3/advanced_testing/sceneRunner/#simulate_key_press) | Simulates that a key is pressed |
|[SimulateKeyRelease](/gdUnit3/advanced_testing/sceneRunner/#simulate_key_release) | Simulates that a key has been released |
|[SimulateMouseMove](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_move) | Simulates a mouse moved to final position |
|[SimulateMouseButtonPressed](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_button_pressed) | Simulates a mouse button pressed |
|[SimulateMouseButtonPress](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_button_press) ] | Simulates a mouse button press (holding) |
|[SimulateMouseButtonRelease](/gdUnit3/advanced_testing/sceneRunner/#simulate_mouse_button_release) | Simulates a mouse button released |
|[SimulateFrames](/gdUnit3/advanced_testing/sceneRunner/#simulate_frames) | Simulates scene processing for a certain number of frames (respecting time factor)|
|[SetMousePos](/gdUnit3/advanced_testing/sceneRunner/#set_mouse_pos) | Sets the mouse cursor to given position relative to the viewport.|
|[AwaitSignal](/gdUnit3/advanced_testing/sceneRunner/#await_signal) | Waits for given signal is emited by the scene until a specified timeout to fail |
|[AwaitSignalOn](/gdUnit3/advanced_testing/sceneRunner/#await_signal_on) | Waits for given signal is emited by the source until a specified timeout to fail |
|[AwaitMethod](/gdUnit3/advanced_testing/sceneRunner/#await_func) |Waits for the function return value until specified timeout or fails |
|[AwaitMethodOn](/gdUnit3/advanced_testing/sceneRunner/#await_func_on) |Waits for the function return value of specified source until specified timeout or fails |
|[GetProperty](/gdUnit3/advanced_testing/sceneRunner/#get_property) | Return the current value of a property |
|[Invoke](/gdUnit3/advanced_testing/sceneRunner/#invoke) | Executes the function specified by name in the scene and returns the result |
|[SetTimeFactor](/gdUnit3/advanced_testing/sceneRunner/#set_time_factor) | Sets how fast or slow the scene simulation is processed (clock ticks versus the real).|
|[MoveWindowToForeground](/gdUnit3/advanced_testing/sceneRunner/#maximize_view) | maximizes the window to bring the scene visible|
{% endtab %}
{% endtabs %}

### simulate_key_pressed
Simulates that a key has been pressed.
{% tabs scene-runner-simulate_key_pressed %}
{% tab scene-runner-simulate_key_pressed GdScript %}
```ruby
    # key_code : the key code e.g. 'KEY_ENTER'
    # shift : false by default set to true if simmulate shift is press
    # control : false by default set to true if simmulate control is press
    func simulate_key_pressed(<key_code> :int, [shift] :bool, [control] :bool) -> GdUnitSceneRunner:
```
```ruby
    # simulate the enter key is pressed
    runner.simulate_key_pressed(KEY_ENTER)
    yield(await_idle_frame(), "completed")

    # simulates key combination ctrl+C is pressed
    runner.simulate_key_pressed(KEY_C, false, true)
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_key_pressed C# %}
```cs
    /// <summary>
    /// Simulates that a key has been pressed.
    /// </summary>
    /// <param name="keyCode">the key code e.g. 'KeyList.Enter'</param>
    /// <param name="shift">false by default set to true if simmulate shift is press</param>
    /// <param name="control">false by default set to true if simmulate control is press</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateKeyPressed(KeyList keyCode, bool shift = false, bool control = false);
```
```cs
    // simulate the enter key is pressed
    runner.SimulateKeyPressed(KeyList.Enter);

    // simulates key combination ctrl+C is pressed
    runner.SimulateKeyPressed(KeyList.C, false, true);
```
{% endtab %}
{% endtabs %}

### simulate_key_press
Simulates that a key is press.
{% tabs scene-runner-simulate_key_press %}
{% tab scene-runner-simulate_key_press GdScript %}
```ruby
    # key_code : the key code e.g. 'KEY_ENTER'
    # shift : false by default set to true if simmulate shift is press
    # control : false by default set to true if simmulate control is press
    func simulate_key_press(<key_code> :int, [shift] :bool, [control] :bool) -> GdUnitSceneRunner:
```
```ruby
    # simulate the enter key is press
    runner.simulate_key_press(KEY_ENTER)
    yield(await_idle_frame(), "completed")

    # simulates key combination ctrl+C is pressed
    runner.simulate_key_press(KEY_C, false, true)
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_key_press c# %}
```cs
    /// <summary>
    /// Simulates that a key is pressed.
    /// </summary>
    /// <param name="keyCode">the key code e.g. 'KeyList.Enter'</param>
    /// <param name="shift">false by default set to true if simmulate shift is press</param>
    /// <param name="control">false by default set to true if simmulate control is press</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateKeyPress(KeyList keyCode, bool shift = false, bool control = false);
```
```cs
    // simulate the enter key is press
    runner.SimulateKeyPress(KeyList.Enter);

    // simulates key combination ctrl+C is pressed
    runner.SimulateKeyPress(KeyList.C, false, true);
```
{% endtab %}
{% endtabs %}


### simulate_key_release
Simulates that a key has been released
{% tabs scene-runner-simulate_key_release %}
{% tab scene-runner-simulate_key_release GdScript %}
```ruby
    # key_code : the key code e.g. 'KEY_ENTER'
    # shift : false by default set to true if simmulate shift is press
    # control : false by default set to true if simmulate control is press
    func simulate_key_release(<key_code> :int, [shift] :bool, [control] :bool) -> GdUnitSceneRunner:
```
```ruby
    # simulate a enter key is released
    runner.simulate_key_release(KEY_ENTER)
    yield(await_idle_frame(), "completed")

    # simulates key combination ctrl+C is released
    runner.simulate_key_release(KEY_C, false, true)
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_key_release C# %}
```cs
    /// <summary>
    /// Simulates that a key has been released.
    /// </summary>
    /// <param name="keyCode">the key code e.g. 'KeyList.Enter'</param>
    /// <param name="shift">false by default set to true if simmulate shift is press</param>
    /// <param name="control">false by default set to true if simmulate control is press</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateKeyRelease(KeyList keyCode, bool shift = false, bool control = false);
```
```cs
    // simulate a enter key is released
    runner.SimulateKeyRelease(KeyList.Enter);

    // simulates key combination ctrl+C is released
    runner.SimulateKeyRelease(KeyList.C, false, true);
```
{% endtab %}
{% endtabs %}


### simulate_mouse_move
Simulates a mouse moved to final position
{% tabs scene-runner-simulate_mouse_move %}
{% tab scene-runner-simulate_mouse_move GdScript %}
```ruby
    # position: The final mouse position
    func simulate_mouse_move(<position> :Vector2) -> GdUnitSceneRunner:
```
```ruby
    # set mouse pos to a inital position
    runner.set_mouse_pos(Vector2(160, 20))
    yield(await_idle_frame(), "completed")

    # simulates a mouse move to final position 200, 40
    runner.simulate_mouse_move(Vector2(200, 40))
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_mouse_move C# %}
```cs
    /// <summary>
    /// Simulates a mouse moved to relative position by given speed.
    /// </summary>
    /// <param name="relative">The mouse position relative to the previous position (position at the last frame).</param>
    /// <param name="speed">The mouse speed in pixels per second.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseMove(Vector2 relative, Vector2 speeds = default);
```
```cs
    # set mouse pos to a inital position
    runner.SimulateMouseMove(new Vector2(160, 20))

    # simulates a mouse move to final position 200,40
    runner.SimulateMouseMove(new Vector2(200, 40))
```
{% endtab %}
{% endtabs %}


### simulate_mouse_move_relative
Simulates a mouse move by given offset and speed to the final position.
{% tabs scene-runner-simulate_mouse_move_relative %}
{% tab scene-runner-simulate_mouse_move_relative GdScript %}
```ruby
    # relative: The relative position, e.g. the mouse position offset
    # speed : The mouse speed in pixels per second.
    func simulate_mouse_move_relative(<relative> :Vector2, <speed> :Vector2) -> GdUnitSceneRunner:
```
```ruby
    # set mouse pos to a inital position
    runner.set_mouse_pos(Vector2(10, 20))
    yield(await_idle_frame(), "completed")

    # simulates a full mouse move from current position + the given offset (400, 200) with a speed of (.2, 1)
    # the final position will be (410, 220) when is completed
    yield(runner.simulate_mouse_move_relative(Vector2(400, 200), Vector2(.2, 1)), "completed")
```
{% endtab %}
{% endtabs %}


### simulate_mouse_button_pressed
Simulates a mouse button pressed
{% tabs scene-runner-simulate_mouse_button_pressed %}
{% tab scene-runner-simulate_mouse_button_pressed GdScript %}
```ruby
    # buttonIndex: The mouse button identifier, one of the ButtonList button or button wheel constants.
    # double_click: set to true to simmulate a doubleclick
    func simulate_mouse_button_pressed(<buttonIndex> :int, <double_click>:=false) -> GdUnitSceneRunner:
```
```ruby
    # simulates mouse left button pressed
    runner.simulate_mouse_button_pressed(BUTTON_LEFT)
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_mouse_button_pressed C# %}
```cs
    /// <summary>
    /// Simulates a mouse button pressed.
    /// </summary>
    /// <param name="button">The mouse button identifier, one of the ButtonList button or button wheel constants.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseButtonPressed(ButtonList button);
```
```cs
    // simulates mouse left button pressed
    runner.SimulateMouseButtonPressed(ButtonList.Left);
```
{% endtab %}
{% endtabs %}


### simulate_mouse_button_press
Simulates a mouse button press (holding)
{% tabs scene-runner-simulate_mouse_button_press %}
{% tab scene-runner-simulate_mouse_button_press GdScript %}
```ruby
    # buttonIndex: The mouse button identifier, one of the ButtonList button or button wheel constants.
    # double_click: set to true to simmulate a doubleclick
    func simulate_mouse_button_press(<buttonIndex> :int, <double_click>:=false) -> GdUnitSceneRunner:
```
```ruby
    # simulates mouse left button is press
    runner.simulate_mouse_button_press(BUTTON_LEFT)
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_mouse_button_press C# %}
```cs
    /// <summary>
    /// Simulates a mouse button press. (holding)
    /// </summary>
    /// <param name="button">The mouse button identifier, one of the ButtonList button or button wheel constants.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseButtonPress(ButtonList button);
```
```cs
    // simulates mouse left button is press
    runner.SimulateMouseButtonPress(ButtonList.Left);
```
{% endtab %}
{% endtabs %}


### simulate_mouse_button_release
Simulates a mouse button released
{% tabs scene-runner-simulate_mouse_button_release %}
{% tab scene-runner-simulate_mouse_button_release GdScript %}
```ruby
    # buttonIndex: The mouse button identifier, one of the ButtonList button or button wheel constants.
    func simulate_mouse_button_release(<buttonIndex> :int) -> GdUnitSceneRunner:
```
```ruby
    # simulates mouse left button is released
    runner.simulate_mouse_button_release(BUTTON_LEFT)
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_mouse_button_release C# %}
```cs
    /// <summary>
    /// Simulates a mouse button released.
    /// </summary>
    /// <param name="button">The mouse button identifier, one of the ButtonList button or button wheel constants.</param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SimulateMouseButtonRelease(ButtonList button);
```
```cs
    // simulates mouse left button is released
    runner.SimulateMouseButtonRelease(ButtonList.Left);
```
{% endtab %}
{% endtabs %}


### simulate_frames
Simulates scene processing for a certain number of frames by respecting the configured time factor
{% tabs scene-runner-simulate_frames %}
{% tab scene-runner-simulate_frames GdScript %}
```ruby
    # frames: amount of frames to process
    # delta_milli: the time delta between a frame in milliseconds
    func simulate_frames(<frames>, [delta_milli]) -> GdUnitSceneRunner:
```
```ruby
    # simulates scene processing over 60 frames
    yield(runner.simulate_frames(60), "completed")

    # simulates scene processing over 60 frames with a delay of 100ms peer frame
    yield(runner.simulate_frames(60, 100), "completed")
```
{% endtab %}
{% tab scene-runner-simulate_frames C# %}
```cs
    /// <summary>
    /// Simulates scene processing for a certain number of frames by given delta peer frame by ignoring the current time factor
    /// </summary>
    /// <param name="frames">amount of frames to process</param>
    /// <param name="deltaPeerFrame">the time delta between a frame in milliseconds</param>
    /// <returns>Task to wait</returns>
    Task SimulateFrames(uint frames, uint deltaPeerFrame);
```
```cs
    // simulates scene processing over 60 frames
    await runner.SimulateFrames(60);

    // simulates scene processing over 60 frames with a delay of 100ms peer frame
    await runner.SimulateFrames(60, 100);
```
{% endtab %}
{% endtabs %}


### await_signal
Waits for given signal is emited by the scene until a specified timeout to fail
{% tabs scene-runner-await_signal %}
{% tab scene-runner-await_signal GdScript %}
```ruby
    # signal_name: signal name
    # args: the expected signal arguments as an array
    # timeout: the timeout in ms, default is set to 2000ms
    func await_signal(<signal_name> :String, <args> :Array, [timeout]):
```
```ruby
    # simulates scene processing until the signal `tree_entered` is emitted
    yield(runner.await_signal("tree_entered"), "completed")

    # simulates scene processing until the signal `my_signal` with arguments ("foo",10) is emitted
    yield(runner.await_signal("my_signal", "foo", 10), "completed")
```
{% endtab %}
{% tab scene-runner-await_signal C# %}
```cs
    /// <summary>
    /// Waits for given signal is emited.
    /// </summary>
    /// <param name="signal">The name of the signal to wait</param>
    /// <returns>Task to wait</returns>
    Task AwaitSignal(string signal, params object[] args);
```
```cs
    // simulates scene processing until the signal `tree_entered` is emitted
    await runner.AwaitSignal("tree_entered");

    // simulates scene processing until the signal `my_signal` with arguments ("foo",10) is emitted
    await runner.AwaitSignal("my_signal", "foo", 10);
```
{% endtab %}
{% endtabs %}

### await_signal_on
Waits for the function return value of specified source until specified timeout or fails
{% tabs scene-runner-await_signal_on %}
{% tab scene-runner-await_signal_on GdScript %}
```ruby
    # source: the object from which the signal is emitted
    # signal_name: signal name
    # args: the expected signal arguments as an array
    # timeout: the timeout in ms, default is set to 2000ms
    func await_signal_on(<source> :Object, <signal_name> :String, <args> :Array, [timeout]):
```
```ruby
    # simulates scene processing until the signal `door_closed` is emitted by door
    yield(runner.await_signal_on(door, "door_closed"), "completed")
```
{% endtab %}
{% tab scene-runner-await_signal_on C# %}
```cs
    not yet supported!
```
```cs
```
{% endtab %}
{% endtabs %}


### await_func
Waits for the function return value until specified timeout or fails
{% tabs scene-runner-await_func %}
{% tab scene-runner-await_func GdScript %}
```ruby
    # args : optional function arguments
    func await_func(<func_name> :String, <args> :Array) -> GdUnitFuncAssert:
```
```ruby
    # waits until the function `has_parent()` returns false or fails after an timeout of 5s
    yield(runner.await_func("has_parent").wait_until(5000).is_false(), "completed")
```
{% endtab %}
{% tab scene-runner-await_func C# %}
```cs
    /// <summary>
    /// Returns a method awaiter to wait for a specific method result.
    /// </summary>
    /// <typeparam name="V">The expected result type</typeparam>
    /// <param name="methodName">The name of the method to wait</param>
    /// <returns>GodotMethodAwaiter</returns>
    GdUnitAwaiter.GodotMethodAwaiter<V> AwaitMethod<V>(string methodName);
```
```cs
    // waits until the function `has_parent()` returns false or fails after an timeout of 5s
    await runner.AwaitMethod<bool>("has_parent").IsFalse().WithTimeout(5000);
```
{% endtab %}
{% endtabs %}


### await_func_on
Waits for the function return value of specified source until specified timeout or fails
{% tabs scene-runner-await_func_on %}
{% tab scene-runner-await_func_on GdScript %}
```ruby
    # source: the object where implements the function
    # args : optional function arguments
    func await_func_on(<source> :Object, <func_name> :String, <args> :Array) -> GdUnitFuncAssert:
```
```ruby
    # waits until the function `has_parent()` on source `door` returns false or fails after an timeout of 5s
    yield(runner.await_func_on(door, "has_parent").wait_until(5000).is_false(), "completed")
```
{% endtab %}
{% tab scene-runner-await_func_on C# %}
```cs
    not yet supported
```
```cs
```
{% endtab %}
{% endtabs %}


### get_property
Returns the current value of the property from the current scene.
{% tabs scene-runner-get_property %}
{% tab scene-runner-get_property GdScript %}
```ruby
    # name: name of property
    # retuen: the value of the property
    func get_property(<name> :String):
```
```ruby
    # returns the current property `_door_color` from the scene
    var color :ColorRect = runner.get_property("_door_color")
```
{% endtab %}
{% tab scene-runner-get_property C# %}
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
```cs
    // returns the current property `_door_color` from the scene
    ColorRect color = runner.GetProperty("_door_color");
```
{% endtab %}
{% endtabs %}


### invoke
Executes the function specified by given name in the scene and returns the result
{% tabs scene-runner-invoke %}
{% tab scene-runner-invoke GdScript %}
```ruby
    # name: the name of the function to execute
    # optional function args 0..9
    # return: the function result
    func invoke(name :String, arg0=NO_ARG, arg1=NO_ARG, arg2=NO_ARG, arg3=NO_ARG, arg4=NO_ARG, arg5=NO_ARG, arg6=NO_ARG, arg7=NO_ARG, arg8=NO_ARG, arg9=NO_ARG):
```
```ruby
    # invokes the function `start_color_cycle` from the current scene
    runner.invoke("start_color_cycle")
```
{% endtab %}
{% tab scene-runner-invoke C# %}
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
```cs
    // invokes the function `start_color_cycle` from the current scene
    runner.Invoke("start_color_cycle");
```
{% endtab %}
{% endtabs %}


### set_mouse_pos
Sets the mouse cursor to given position relative to the viewport.
{% tabs scene-runner-set_mouse_pos %}
{% tab scene-runner-set_mouse_pos GdScript %}
```ruby
    func set_mouse_pos(<pos> :Vector2) -> GdUnitSceneRunner:
```
```ruby
    # sets the current mouse position to 100, 100
    runner.set_mouse_pos(Vector2(100, 100))
    yield(await_idle_frame(), "completed")
```
{% endtab %}
{% tab scene-runner-set_mouse_pos C# %}
```cs
    /// <summary>
    /// Sets the actual mouse position relative to the viewport.
    /// </summary>
    /// <param name="position">The position in x/y coordinates</param>
    /// <returns></returns>
    ISceneRunner SetMousePos(Vector2 position);
```
```cs
    // sets the current mouse position to 100, 100
    runner.SetMousePos(new Vector2(100, 100));
```
{% endtab %}
{% endtabs %}


### maximize_view
Maximizes the window to make the scene visible, sensibly set for debugging reasons to see the scene output.
{% tabs scene-runner-maximize_view %}
{% tab scene-runner-maximize_view GdScript %}
```ruby
    func maximize_view() -> GdUnitSceneRunner:
```
```ruby
    # shows the scene running
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
```cs
    // shows the scene running
    runner.MoveWindowToForeground();
```
{% endtab %}
{% endtabs %}

### set_time_factor
Sets how fast or slow the scene simulation is processed (clock ticks versus the real).
{% tabs scene-runner-set_time_factor %}
{% tab scene-runner-set_time_factor GdScript %}
```ruby
    # It defaults to 1.0. A value of 2.0 means the game moves twice as fast as real life,
    # whilst a value of 0.5 means the game moves at half the regular speed.
    func set_time_factor(<time_factor> := 1.0) -> GdUnitSceneRunner:
```
```ruby
    # sets time factor to 5 
    runner.set_time_factor(5)
    # simulated 60 frames ~5 times faster now  
    yield(runner.simulate_frames(60), "completed")
```
{% endtab %}
{% tab scene-runner-set_time_factor C# %}
```cs
    /// <summary>
    /// Sets how fast or slow the scene simulation is processed (clock ticks versus the real).
    /// </summary>
    /// <param name="timeFactor"></param>
    /// <returns>SceneRunner</returns>
    ISceneRunner SetTimeFactor(double timeFactor = 1.0);
```
```cs
    // sets time factor to 5 
    runner.SetTimeFactor(5);
    // simulated 60 frames ~5 times faster now  
    await runner.SimulateFrames(60);
```
{% endtab %}
{% endtabs %}