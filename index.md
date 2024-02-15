---
layout: default
title: Home
---



# GdUnit4 V4.2.1
![GdUnit4](\gdUnit4\assets\images\background.png)
build on (v4.2.1.stable.official [b09f793f5])



## What is GdUnit4?
**Gd**(*Godot*)**Unit**(*Unit Testing*)**4**(*Godot 4.x*)

GdUnit4 is an embedded unit testing framework designed for testing Gd scripts, C# scripts, and scenes in the Godot editor. With GdUnit4, you can easily create and run unit tests to verify the functionality and performance of your code, ensuring that it meets your requirements and specifications.<br>
GdUnit4 is a powerful tool that supports Test-Driven Development ([TDD](https://en.wikipedia.org/wiki/Test-driven_development){:target="_blank"}), a popular software development approach that emphasizes creating automated tests before writing any code. By using GdUnit4 for TDD, you can ensure that your code is thoroughly tested and free of bugs, which can save you time and effort in the long run.



## You are welcome to:
  * [Give Feedback](https://github.com/MikeSchulze/gdUnit4/discussions/157){:target="_blank"} on the gdUnit GitHub Discussions page.
  * [Suggest Improvements](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=enhancement&template=feature_request.md&title=){:target="_blank"} by creating a new feature request issue on the gdUnit GitHub Issues page.
  * [Report Bugs](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=bug&projects=projects%2F5&template=bug_report.yml&title=GD-XXX%3A+Describe+the+issue+briefly){:target="_blank"} by creating a new bug report issue on the gdUnit GitHub Issues page.


## Main Features
* Support for writing and executing tests in GdScript or C#
* Embedded test Inspector in Godot for easy navigation of your test suites
* Convenient interface for running test-suites directly from Godot<br>
  One of the main features of GdUnit4 is the ability to run test-suites directly from the Godot editor using the context menu. You can run test-suites from the FileSystem panel, the ScriptEditor, or the GdUnit Inspector. To do this, simply right-click on the desired test-suite or test-case and select "Run Test(s)" from the context menu. This will run the selected tests and display the results in the GdUnit Inspector.<br>
  You can create new test cases directly from the ScriptEditor by right-clicking on the function you want to test and selecting "Create TestCase" from the context menu.
* Fluent syntax for writing test cases that's easy to read and understand
* Configurable template for generating new test-suites when creating test-cases
* Wide range of assertion methods for verifying the behavior and output of your code
* Argument matchers for verifying that a function call was made with the expected arguments
* Test Fuzzing support for generating random inputs to test edge cases and boundary conditions
* Parameterized Tests (Test Cases) for testing functions with multiple sets of inputs and expected outputs
* Mocking classes to simulate behavior and define output for specific functions
* Spy feature for verifying that a function was called with the expected parameters
* Mocking or spying on scenes to simulate behavior and verify that certain functions were called
* Scene runner for simulating different kinds of inputs and actions, such as mouse clicks and keyboard inputs<br>
  For example, you can simulate mouse clicks and keyboard inputs by calling the appropriate methods on the runner instance. Additionally, you can wait for a specific signal to be emitted by the scene, or you can wait for a specific function to return a certain value.
* Automatic update notifier to install the latest version of GdUnit from GitHub
* Command line tool for running tests outside of Godot editor
* CI - Continuous Integration support
  * Command line tool for running tests outside of Godot editor
  * Generates HTML report
  * Generates JUnit XML report
  * Public marketplace GitHub action to use in your own CI workflow [gdunit4-action](https://github.com/marketplace/actions/gdunit4-test-runner-action)
* Visual Studio Code extension for additional features and integrations in managing and running tests


## Basic Test Example
{: .d-none .d-md-inline-block }

{% tabs example %}
{% tab example GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

func test_example():
  assert_str("This is a example message")\
    .has_length(25)\
    .starts_with("This is a ex")
```
{% endtab %}

{% tab example C# %}
```cs
namespace examples
{
    using gdUnit4;
    using static gdUnit4.Assertions;

    [TestSuite]
    public class GdUnitExampleTest
    {
        [TestCase]
        public void Example()
        {
            AssertString("This is a example message")
              .HasLength(25)
              .StartsWith("This is a ex");
        }
    }
}

```
{% endtab %}
{% endtabs %}

---
<h4> document version v4.2.1 </h4>
