
<h1 align="center">GdUnit4 <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/MikeSchulze/gdunit4" width="18%"> </h1>
<h2 align="center">A Godot Embedded Unit Testing Framework</h2>


---
<h1 align="center">GdUnit4 Beta </h1>
<p align="center">This is a beta version of GdUnit4 which is based on Godot <strong>v4.0.rc4.official [e0de3573f]</strong> (master branch)</p>

<h1 align="center">ATTENTION!</h1>

### You need the deactivate the old version before deinstall and install this version!


<h2 align="center">Please read the following disclaimer carefully before proceeding!

This version is NOT bug free and may cause the Godot editor to crash.
If you find a bug or problem please report it via [report bug](https://github.com/MikeSchulze/gdUnit4/issues/new/choose).

The C# support is currently not enabled and is untested.
</h2>


---

<p align="center">
  <img src="https://img.shields.io/badge/Godot-v4.x.x-%23478cbf?logo=godot-engine&logoColor=cyian&color=red">
</p>

<p align="center"><a href="https://github.com/MikeSchulze/gdUnit4"><img src="https://github.com/MikeSchulze/gdUnit4/blob/master/assets/gdUnit4-animated.gif" width="100%"/></p><br/>


<p align="center">
  <img alt="GitHub branch checks state" src="https://img.shields.io/github/checks-status/MikeSchulze/gdunit4/master"></br>
  <img src="https://github.com/MikeSchulze/gdUnit4/actions/workflows/selftest-4.x.yml/badge.svg?branch=master"></br>
  <img src="https://github.com/MikeSchulze/gdUnit4/actions/workflows/selftest-4.x-mono.yml/badge.svg?branch=master"></br>
</p>



## What is GdUnit4
gdunit4 is a framework for testing Gd-Scrips/C# and Scenes within the Godot editor. GdUnit4 is very useful for test-driven development and will help you get your code bug-free.


## Features
* Fully embedded in the Godot editor
* Run test-suite(s) by using the context menu on FileSystem, ScriptEditor or GdUnitInspector
* Create tests directly from the ScriptEditor
* Configurable template for the creation of a new test-suite
* A spacious set of Asserts use to verify your code
* Argument matchers to verify the behavior of a function call by a specified argument type.
* Fluent syntax support
* Test Fuzzing support
* Parameterized Tests (Test Cases)
* Mocking a class to simulate the implementation in which you define the output of the certain function
* Spy on an instance to verify that a function has been called with certain parameters.
* Mock or Spy on a Scene
* Provides a scene runner to simulate interactions on a scene
  * Simulate by Input events like mouse and/or keyboard
  * Simulate scene processing by a certain number of frames
  * Simulate scene processing by waiting for a specific signal
* Update Notifier to install the latest version from GitHub
* Command Line Tool
* CI - Continuous Integration support
  * generates HTML report
  * generates JUnit report
* Visual Studio Code extension
---


## Short Example
 ```
 # this assertion succeeds
assert_int(13).is_not_negative()

# this assertion fails because the value '-13' is negative
assert_int(-13).is_not_negative()
 ```

 ---

## Documentation
<p align="left" style="font-family: Bedrock; font-size:21pt; color:#7253ed; font-style:bold">
  <a href="https://mikeschulze.github.io/gdUnit3/first_steps/install/">How to Install GdUnit</a>
</p>

<p align="left" style="font-family: Bedrock; font-size:21pt; color:#7253ed; font-style:bold">
  <a href="https://mikeschulze.github.io/gdUnit3/">API Documentation</a>
</p>



---

### You are welcome to:
  * [Give Feedback](https://github.com/MikeSchulze/gdUnit4/discussions/228)
  * [Suggest Improvements](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=enhancement&template=feature_request.md&title=)
  * [Report Bugs](https://github.com/MikeSchulze/gdUnit4/issues/new?assignees=MikeSchulze&labels=bug%2C+task&template=bug_report.md&title=)



<h1 align="center"></h1>
<p align="left">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/MikeSchulze/gdunit4">
  <img alt="GitHub closed issues" src="https://img.shields.io/github/issues-closed-raw/MikeSchulze/gdunit4"></br>
  <!-- <img src="https://img.shields.io/packagecontrol/dm/SwitchDictionary.svg">
  <img src="https://img.shields.io/packagecontrol/dt/SwitchDictionary.svg">
   -->
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/MikeSchulze/gdunit4">
  <img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/MikeSchulze/gdunit4">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg">
</p>

<p align="left">
  <a href="https://discord.gg/rdq36JwuaJ"><img src="https://discordapp.com/api/guilds/885149082119733269/widget.png?style=banner4" alt="Join GdUnit Server"/></a>
</p>

### Thank you for supporting my project!
---
## Sponsors:
* bitbrain - [<img src="https://github.com/bitbrain.png" alt="bitbrain" width="125"/>](https://github.com/bitbrain)
