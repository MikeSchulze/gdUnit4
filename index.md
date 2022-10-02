---
layout: default
title: Home
---

# GdUnit3 V2.3.0

![GdUnit3](\gdUnit3\assets\images\background.png)


## What is GdUnit3?
**Gd**(*Godot*)**Unit**(*Unit Testing*)**3**(*Godot 3.x*)

GdUnit3 is an embeded unit testing framework for testing your Gd, C# Scripts and Scenes within the Godot editor. GdUnit3 is very useful for [TDD (test driven development)](https://en.wikipedia.org/wiki/Test-driven_development){:target="_blank"} and will help you get your code bug-free.


## You are welcome to:
  * [Give Feedback](https://github.com/MikeSchulze/gdUnit3/discussions/228){:target="_blank"}
  * [Suggest Improvements](https://github.com/MikeSchulze/gdUnit3/issues/new?assignees=MikeSchulze&labels=enhancement&template=feature_request.md&title=){:target="_blank"}
  * [Report Bugs](https://github.com/MikeSchulze/gdUnit3/issues/new?assignees=MikeSchulze&labels=bug&template=bug_report.md&title=){:target="_blank"}

***


## Main Features
* Write and run tests in GdScript or C#
* Embedded test Inspector in the Godot to navigate over your test suites
* Run test-suite(s) by using the context menu on FileSystem, ScriptEditor or GdUnit Inspector
* Create test's directly from the ScriptEditor
* A Configurable template for the creation of a new test-suite
* A spacious set of Asserts use to verify your code
* Argument matchers to verify the behavior of a function call by a specified argument type.
* Fluent syntax support
* Test Fuzzing support
* Parameterized Tests (Test Cases)
* Mocking a class to simulate the implementation which you define the output of certain function
* Spy on a instance to verify that a function has been called with certain parameters.
* Mock or Spy on a Scene 
* Provides a scene runner to simulate interactions on a scene 
  * Simulate by Input events like mouse and/or keyboard
  * Simulate scene processing by a certain number of frames
  * Simulate scene proccessing by waiting for a specific signal
  * Simulate scene proccessing by waiting for a specific function result
* Update Notifier to install latest version from GitHub
* Command Line Tool
* Visual Studio Code extension


### Test Example
{: .d-none .d-md-inline-block }

{% tabs example %}
{% tab example GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

func test_example():
	assert_str("This is a example message").has_length(25).starts_with("This is a ex")
```
{% endtab %}

{% tab example C# %}
```cs
namespace examples
{
    using GdUnit3;
    using static GdUnit3.Assertions;

    [TestSuite]
    public class GdUnitExampleTest
    {
        [TestCase]
        public void Example()
        {
            AssertString("This is a example message").HasLength(25).StartsWith("This is a ex");
        }
    }
}

```
{% endtab %}
{% endtabs %}