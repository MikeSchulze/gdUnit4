---
layout: default
title: Your First Test
nav_order: 3
---

# Create your first Test

## Before you start
Create a new folder **first_steps** in your root project and copy this class into it.<br>
It should be located at `res://first-steps/TestPerson.gd`
{% tabs first-step-test_class %}
{% tab first-step-test_class TestPerson.gd %}
```ruby
class_name TestPerson
extends Node

var _first_name :String
var _last_name :String

func _init(first_name :String, last_name :String):
	_first_name = first_name
	_last_name = last_name

func full_name() -> String:
	return _first_name + " " + _last_name

```
{% endtab %}
{% endtabs %}

## Create the Test

The fastest way to create a test is to use the built-in "Create Test" function.
To do this, open your script that you want to test and right-click on a function and then click "Create Test".

![](/gdUnit3/assets/images/first-steps/context-menu.png)

We selected the function `full_name` to generate a test for it.

Thats all, your first test is created!

![](/gdUnit3/assets/images/first-steps/generated-test-suite.png)


A test is defined as a function following the pattern `test_name([args]):` and must start with the prefix "test_" to be identified as a test.
The `name` is freely selectable, but should correspond to the function to be tested. 
Test arguments are optional and will be explainted later in the advanced testing section.

## Execute your Test

After your first test is created we want to execute it. Do this by select your test in the editor via right mouse button and click on "Run Tests" or "Debug Tests"
![](/gdUnit3/assets/images/first-steps/run-selected-test-case.png)


The test run is is visualisized in the GdUnit3 inspector and allows you to inspect the test results.
![](/gdUnit3/assets/images/first-steps/first-test-run-result.png)

As you can see your first test run results with an failure. 
```
line 10: Test not implemented!
```
By default, a generated test first fails with the failure message "Test not implemented" because the assertion `assert_not_yet_implemented()` is used in the test.
By double-clicking on the failed test you can jump directly to the test failure.

![](/gdUnit3/assets/images/first-steps/jump-to-failure.png)




## Complete your first Test
To define your test, you must specify what you want to test.<br>
For testing, GdUnit provides a large number of asserts to compare an actual value with an expected value.

Remember that we did a test for the function `func full_name() -> String:` with has a return type of **String**.
To verify the return value of the function replace to complte your test by:

{% tabs first-step-test_case %}
{% tab first-step-test_case (load by path) %}
```ruby
func test_full_name() -> void:
   var person = load("res://first-steps/TestPerson.gd").new("King", "Arthur")
   assert_str(person.full_name()).is_equal("King Arthur")
```
{% endtab %}
{% tab first-step-test_case (by class_name) %}
```ruby
func test_full_name() -> void:
   var person := TestPerson.new("King", "Arthur")
   assert_str(person.full_name()).is_equal("King Arthur")
```
{% endtab %}
{% endtabs %}


Now run the test again by pressing the **Run Debug Button** in the inspector.<br>
For more details about the inspector buttons, see [Button Bar](/gdUnit3/faq/inspector/#button-bar)

![](/gdUnit3/assets/images/first-steps/rerun-test.png)

The test failure is fixed but now we get a warning?

![](/gdUnit3/assets/images/first-steps/rerun-test-result.png)

The report shows a message **Detect <1> orphan nodes during test execution** what happened?

This warning indicates that we have forgotten to release an object. We still have to release the used object (TestPerson) after the test to avoid memory leaks. 

You can do this manually or with the included `auto_free` tool
{% tabs first-step-orphan %}
{% tab first-step-orphan GdScript (manual) %}
```ruby
func test_full_name() -> void:
	var person := TestPerson.new("King", "Arthur")
	assert_str(person.full_name()).is_equal("King Arthur")
	person.free()
```
{% endtab %}
{% tab first-step-orphan GdScript (auto_free) %}
```ruby
func test_full_name() -> void:
   var person :TestPerson = auto_free(TestPerson.new("King", "Arthur"))
   assert_str(person.full_name()).is_equal("King Arthur")
```
{% endtab %}
{% endtabs %}


GdUnit offers [Asserts](/gdUnit3/asserts/index/) for all basic build-in types and much more. 
A collection of tests is called `Test Suite` in GdUnit, look into [Test Suite](/gdUnit3/faq/test-suite) for more details.

Now run your test again and it will complete successful. 
Congratulations you have successfully written your first test.


