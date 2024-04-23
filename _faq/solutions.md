---
layout: default
title: Problems & Solutions
nav_order: 10
---

# Problems & Solutions

This section lists known problems and possible solutions/workarounds.

## Problems

- [Script/Resource Errors after the plugin is installed](/gdUnit4/faq/solutions/#scriptresource-errors-after-the-plugin-is-installed)
- [Modifying the Game Engine State 'mainLoop.Paused = true' during Tests](/gdUnit4/faq/solutions/#modifying-the-game-engine-state-mainlooppaused--true-during-tests)

---

### Script/Resource Errors after the plugin is installed

When installing the GdUnit4 plugin and activating it, you may encounter a lot of script and resource loading errors. These errors occur due to a cache problem in the Godot Engine.

<h4> Solution </h4>

To solve the errors, you need to restart the Godot Editor. If this does not help, you may need to manually delete the Godot cache folder:

1. Close the Godot Editor.
2. Delete the `.godot` folder from your working directory.
3. Start the Godot Editor (you may still see loading errors).
4. Close and restart the Godot Editor. The loading errors should no longer occur.

---

### Modifying the Game Engine State 'mainLoop.Paused = true' during Tests

When a test modifies the game engine state `Paused` on the `SceneTree`, it can affect the test execution. Setting the main loop to paused will stop the engine running, including the test execution running in the main loop, causing the GdUnit4 test window to remain open even after tests are complete.

<h4> Solution </h4>

When you modify engine states during tests, ensure you restore them to their previous values when the test is finished. You can achieve this by adding an "after test" stage to your test suite.

{% tabs mainloop_paused %}
{% tab mainloop_paused GDScript %}

```ruby
# Reset the paused mode back to false after each test
func after_test() -> void:
    Engine.get_main_loop().paused = false

# Simple example test to modify the game state
func test_game_paused() -> void:
    var mainLoop :SceneTree = Engine.get_main_loop()

    assert_that(mainLoop.paused).is_false()
    # The following lines cause the GdUnit4 test window to remain open even after tests are complete
    mainLoop.paused = true
    assert_that(mainLoop.paused).is_true()
```

{% endtab %}
{% tab mainloop_paused C# %}

```cs
// Reset the paused mode back to false after each test
[AfterTest]
public void TearDown() =>
    ((SceneTree)Engine.GetMainLoop()).Paused = false;


[TestCase]
public void GamePaused()
{
    var mainLoop = (SceneTree)Engine.GetMainLoop();

    AssertThat(mainLoop.Paused).IsFalse();

    // The following lines cause the GdUnit4 test window to remain open even after tests are complete
    mainLoop.Paused = true;
    AssertThat(mainLoop.Paused).IsTrue();
}
```

{% endtab %}
{% endtabs %}

---
<h4> document version v4.2.5 </h4>
