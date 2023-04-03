---
layout: default
title: Basics
parent: Tutorials
nav_order: 5
---


## Examples
This page contains a collection of examples that demonstrate how to use GdUnit4 to write tests for your Godot projects. These examples cover a range of use cases and will be expanded over time to provide more comprehensive coverage of GdUnit4 features.


### Verify a Message for Length and Content
This example demonstrates how to use GdUnit4 to test a given string for expected length and content. This type of test can be useful in verifying the output of various functions, such as text formatting or input validation.

To use this example, simply copy the code into a new GdUnit4 test script and modify the message and expected length and content to match your own requirements. When you run the test, GdUnit4 will compare the actual message length and content to the expected values, and report any discrepancies.

{% tabs tuturial-basics %}
{% tab tuturial-basics GdScript %}
```ruby
extends GdUnitTestSuite

func test_example():
	# Verify the given string by using `assert_str`
	assert_str("This is a example message")\
		# We expect a lenght equal 25 characters
		.has_length(25)\
		# The message must start wiht `This is a ex`
		.starts_with("This is a ex")
```
{% endtab %}
{% tab tuturial-basics C# %}
```cs
[TestCase]
public Example2()
	// Verify the given string by using `AssertString`
	AssertString("This is a example message")
		// We expect a lenght equal 25 characters
		.HasLength(25)
		// The message must start wiht `This is a ex`
		.StartsWith("This is a ex");
```
{% endtab %}
{% endtabs %}
If the test fails, GdUnit4 will report an failure message that shows the expected and actual values.

---
<h4> document version v4.1.0 </h4>