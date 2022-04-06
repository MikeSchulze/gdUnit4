---
layout: default
title: GdUnit3 - Embedded Godot Unit Test Framework
---

<!-- UIkit CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/uikit@3.7.2/dist/css/uikit.min.css" />

<!-- UIkit JS -->
<script src="https://cdn.jsdelivr.net/npm/uikit@3.7.2/dist/js/uikit.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/uikit@3.7.2/dist/js/uikit-icons.min.js"></script>

![Godot v3.2.3](https://img.shields.io/badge/Godot-v3.2.3-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.2.4](https://img.shields.io/badge/Godot-v3.2.4-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3](https://img.shields.io/badge/Godot-v3.3-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.1](https://img.shields.io/badge/Godot-v3.3.1-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.2](https://img.shields.io/badge/Godot-v3.3.2-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.3](https://img.shields.io/badge/Godot-v3.3.3-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.4](https://img.shields.io/badge/Godot-v3.3.4-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.4](https://img.shields.io/badge/Godot-v3.4-%23478cbf?logo=godot-engine&logoColor=white)

***

## GdUnit3 V2.0.0 - Beta

* You are welcome to test in and send me your feedback
* You are welcome to suggest improvements
* You are welcome to report bugs

***

GdUnit is a testing framework for Godot. GdUnit is important in the development of test-driven development and will help you to get your code bug free.

## Main Features

* Fully integrated in the Godot editor
* Run test-suite(s) by using the context menu on FileSystem, ScriptEditor or GdUnitInspector
* Create test's directly from the ScriptEditor
* Configurable template for the creation of a new test-suite
* A spacious set of Asserts use to verify your code
* Argument matchers to verify the behavior of a function call by a specified argument type.
* Fluent syntax support
* Test Fuzzing support
* Mocking a class to simulate the implementation which you define the output of certain function
* Spy on a instance to verify that a function has been called with certain parameters.
* Mock or Spy on a Scene 
* Provides a scene runner to simulate interactions on a scene 
  * Simulate by Input events like mouse and/or keyboard
  * Simulate scene processing by a certain number of frames
  * Simulate scene proccessing by waiting for a specific signal
* Update Notifier to install latest version from GitHub
* Command Line Tool


## Example
{% codetabs %}

{% codetab GdScript %}
```python
extends GdUnitTestSuite

func test_example():
	assert_str("This is a example message").has_length(25).starts_with("This is a ex")
```
{% endcodetab %}

{% codetab C# %}
```cs
public void Example() {
    AssertString("This is a example message").HasLength(25).StartsWith("This is a ex");
}
```
{% endcodetab %}

{% endcodetabs %}

