
<h1 align="center">GdUnit4 <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/MikeSchulze/gdunit4" width="18%"> </h1>
<h2 align="center">A Godot Embedded Unit Testing Framework</h2>
<p align="center">This version of GdUnit4 is based on Godot <strong>v4.2.1.stable.official [b09f793f5]</strong> (master branch)</p>
</h2>

---
<h1 align="center">Supported Godot Versions</h2>
<p align="center">
  <img src="https://img.shields.io/badge/Godot-v4.2.0-%23478cbf?logo=godot-engine&logoColor=cyian&color=green">
  <img src="https://img.shields.io/badge/Godot-v4.2.1-%23478cbf?logo=godot-engine&logoColor=cyian&color=green">
  <img src="https://img.shields.io/badge/Godot-v4.2.2-%23478cbf?logo=godot-engine&logoColor=cyian&color=green">
</p>

<p align="center"><a href="https://github.com/MikeSchulze/gdUnit4"><img src="https://github.com/MikeSchulze/gdUnit4/blob/master/assets/gdUnit4-animated.gif" width="100%"/></p><br/>

<p align="center">
  <img alt="GitHub branch checks state" src="https://img.shields.io/github/checks-status/MikeSchulze/gdunit4/master"></br>
  <img src="https://github.com/MikeSchulze/gdUnit4/actions/workflows/ci-dev.yml/badge.svg?branch=master"></br>
</p>

## What is GdUnit4?

**Gd**(*Godot*)**Unit**(*Unit Testing*)**4**(*Godot 4.x*)

GdUnit4 is an embedded unit testing framework designed for testing Gd scripts, C# scripts, and scenes in the Godot editor. With GdUnit4, you can easily create and run unit tests to verify the functionality and performance of your code, ensuring that it meets your requirements and specifications.<br>
GdUnit4 is a powerful tool that supports Test-Driven Development ([TDD](https://en.wikipedia.org/wiki/Test-driven_development)), a popular software development approach that emphasizes creating automated tests before writing any code. By using GdUnit4 for TDD, you can ensure that your code is thoroughly tested and free of bugs, which can save you time and effort in the long run.

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
* CI - Continuous Integration support
  * Command line tool for running tests outside of Godot editor
  * Generates HTML report
  * Generates JUnit XML report
* Public marketplace GitHub action to use in your own CI workflow [gdunit4-action](https://github.com/marketplace/actions/gdunit4-test-runner-action)
* C# support by [gdUnit4Net](https://github.com/MikeSchulze/gdUnit4Net/blob/master/README.md)
  * Enables to run and debug on **Visual Studio**, **Visual Studio Code** and **JetBrains Rider** via [VSTest adapter support](https://github.com/MikeSchulze/gdUnit4Net/blob/master/testadapter/README.md)

---

## Basic Test Example

 ```
class_name GdUnitExampleTest
extends GdUnitTestSuite

func test_example():
  assert_str("This is a example message")\
    .has_length(25)\
    .starts_with("This is a ex")
 ```

 ---

## Documentation

<p align="left" style="font-family: Bedrock; font-size:21pt; color:#7253ed; font-style:bold">
  <a href="https://mikeschulze.github.io/gdUnit4/first_steps/install/">How to Install GdUnit</a>
</p>

<p align="left" style="font-family: Bedrock; font-size:21pt; color:#7253ed; font-style:bold">
  <a href="https://mikeschulze.github.io/gdUnit4/">API Documentation</a>
</p>

---

### You Are Welcome To

* [Give Feedback](https://github.com/MikeSchulze/gdUnit4/discussions) on the gdUnit GitHub Discussions page.
* [Suggest Improvements](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=enhancement&template=feature_request.md&title=) by creating a new feature request issue on the gdUnit GitHub Issues page.
* [Report Bugs](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=bug&projects=projects%2F5&template=bug_report.yml&title=GD-XXX%3A+Describe+the+issue+briefly)  by creating a new bug report issue on the gdUnit GitHub Issues page.

---

## GdUnit Test Coverage and Code Quality

### Test Coverage

GdUnit is comprehensively tested to ensure robust functionality.<br>
Continuous Integration (CI) is in place for every pull request to prevent any potential functionality issues.

### Code Formatting

🙏 Special Thanks to @Scony for creating [gdlint](https://github.com/Scony/godot-gdscript-toolkit), a valuable tool contributing to code quality.

---

### Contribution Guidelines

**Thank you for your interest in contributing to GdUnit4!**<br>
To ensure a smooth and collaborative contribution process, please review our [contribution guidelines](https://github.com/MikeSchulze/gdUnit4/blob/master/CONTRIBUTING.md) before getting started. These guidelines outline the standards and expectations we uphold in this project.

Code of Conduct: We strictly adhere to the Godot code of conduct in this project. As a contributor, it is important to respect and follow this code to maintain a positive and inclusive community.

Using GitHub Issues: We utilize GitHub issues for tracking feature requests and bug reports. If you have a general question or wish to engage in discussions, we recommend joining the [GdUnit Discord Server](https://discord.gg/rdq36JwuaJ) for specific inquiries.

We value your input and appreciate your contributions to make GdUnit4 even better!

---

<p align="left" style="font-family: Bedrock; font-size:21pt; color:#7253ed; font-style:bold">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/MikeSchulze/gdunit4">
  <img alt="GitHub closed issues" src="https://img.shields.io/github/issues-closed-raw/MikeSchulze/gdunit4"></br>
  <img src="https://img.shields.io/packagecontrol/dm/SwitchDictionary.svg">
  <img src="https://img.shields.io/packagecontrol/dt/SwitchDictionary.svg">

  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/MikeSchulze/gdunit4">
  <img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/MikeSchulze/gdunit4">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg">
</p>

<p align="left">
  <a href="https://discord.gg/rdq36JwuaJ"><img src="https://discordapp.com/api/guilds/885149082119733269/widget.png?style=banner4" alt="Join GdUnit Server"/></a>
</p>

### Thank you for supporting my project

---

## Sponsors

[<img src="https://github.com/bitbrain.png" alt="bitbrain" width="125"/>](https://github.com/bitbrain) bitbrain
[<img src="https://avatars.githubusercontent.com/u/2313134?v=4" alt="bitbrain" width="125"/>](https://github.com/sebastianhutter) sebastianhutter
