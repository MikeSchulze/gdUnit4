---
layout: default
title: About
nav_order: 1
has_toc: false
---

# GdUnit4 V4.4.0

![GdUnit4](\gdUnit4\assets\images\background.png)
build on (v4.2.2.stable.official [15073afe3])

## What is GdUnit4?

**Gd**(*Godot*)**Unit**(*Unit Testing*)**4**(*Godot 4.x*)

GdUnit4 is an embedded unit testing framework designed for testing Gd scripts, C# scripts, and scenes in the Godot editor. With GdUnit4, you can easily create and run unit tests to verify the functionality and performance of your code, ensuring that it meets your requirements and specifications.<br>
GdUnit4 is a powerful tool that supports Test-Driven Development ([TDD](https://en.wikipedia.org/wiki/Test-driven_development){:target="_blank"}), a popular software development approach that emphasizes creating automated tests before writing any code. By using GdUnit4 for TDD, you can ensure that your code is thoroughly tested and free of bugs, which can save you time and effort in the long run.

## You are welcome to

* [Give Feedback](https://github.com/MikeSchulze/gdUnit4/discussions/157){:target="_blank"} on the gdUnit GitHub Discussions page.
* [Suggest Improvements](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=enhancement&template=feature_request.md&title=){:target="_blank"} by creating a new feature request issue on the gdUnit GitHub Issues page.
* [Report Bugs](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=bug&projects=projects%2F5&template=bug_report.yml&title=GD-XXX%3A+Describe+the+issue+briefly){:target="_blank"} by creating a new bug report issue on the gdUnit GitHub Issues page.

## Main Features

* **Writing And Executing Tests** in GdScript or C#
* **Embedded Test Inspector** in Godot for easy navigation of your test suites
* **Test Discovery**, searches for tests at runtime and automatically adds them to the inspector.
* **Convenient Interface** for running test-suites directly from Godot<br>
  One of the main features of GdUnit4 is the ability to run test-suites directly from the Godot editor using the context menu. You can run test-suites from the FileSystem panel, the ScriptEditor, or the GdUnit Inspector. To do this, simply right-click on the desired test-suite or test-case and select "Run Test(s)" from the context menu. This will run the selected tests and display the results in the GdUnit Inspector.<br>
  You can create new test cases directly from the ScriptEditor by right-clicking on the function you want to test and selecting "Create TestCase" from the context menu.
* **Fluent Syntax** for writing test cases that's easy to read and understand
* **Configurable Template** for generating new test-suites when creating test-cases
* **Wide range of Assertions** for verifying the behavior and output of your code
* **Argument matchers** for verifying that a function call was made with the expected arguments
* **Test Fuzzing** for generating random inputs to explore edge cases and boundary conditions
* **Parameterized Tests** for validating functions with multiple sets of inputs and expected outputs
* **Mocking** classes to simulate behavior and define output for specific functions
* **Spy** feature for verifying that a function was called with the expected parameters
* **Mocking and Spying on Scenes** to simulate behavior and verify that certain functions were called
* **Scene Runner** for simulating different kinds of inputs and actions, such as mouse clicks and keyboard inputs<br>
  For example, you can simulate mouse clicks and keyboard inputs by calling the appropriate methods on the runner instance. Additionally, you can wait for a specific signal to be emitted by the scene, or you can wait for a specific function to return a certain value.
* **Automatic Update Notifier** to install the latest version of GdUnit from GitHub
* **Commandline Tool** for running tests outside of Godot editor
* **Flaky Test Handling and Detection**<br>
  Detects flaky tests by rerunning tests that fail. This feature helps identify non-deterministic or intermittent failures in your test suite. Configure the number of retries and mark flaky tests in the test results.
* **Continuous Integration Support**
  * Command line tool for running tests outside of Godot editor
  * Generates HTML report
  * Generates JUnit XML report
* **GitHub Action Integration**<br>
  A public marketplace action for integrating GdUnit4 into your CI workflow [gdunit4-action](https://github.com/marketplace/actions/gdunit4-test-runner-action){:target="_blank"}
* **GdUnit4Net** the C# API
  * Support for writing tests in C# [gdUnit4.api](https://github.com/MikeSchulze/gdUnit4Net/blob/master/api/README.md){:target="_blank"}
  * Supporting for the Visual Studio Test Platform to run and debug tests [gdunit4.test.adapter](https://github.com/MikeSchulze/gdUnit4Net/tree/master/testadapter/README.md){:target="_blank"}

---
<h4> document version v4.4.0 </h4>
