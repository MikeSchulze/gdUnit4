---
layout: default
title: Parameterized Tests
parent: Advanced Testing
nav_order: 2
---

# Testing with Parameterized TestCases

## Parameterized TestCases
Parameterized tests can help keep your test suite organized by allowing you to define multiple test scenarios with different inputs using a single test function. You can define the required test parameters on the TestCase and use them in your test function to generate various test cases. This is especially useful when you have similar test setups with different inputs.

{% tabs faq-test-case-name %}
{% tab faq-test-case-name GdScript %}
To define a TestCase with parameters, you need to add input parameters and a test data set with the name **test_parameters**. This TestCase will be executed multiple times with the test data provided by the **test_parameters** parameter.<br>
Here's an example:
```ruby
func test_parameterized_int_values(a: int, b :int, c :int, expected :int, test_parameters := [
	[1, 2, 3, 6],
	[3, 4, 5, 12],
	[6, 7, 8, 21] ]):
	
	assert_that(a+b+c).is_equal(expected)
```
{% endtab %}
{% tab faq-test-case-name C# %}
To define a TestCase with parameters, you can use the attribute **[TestCase]** and provide it with a test data set for each parameter set. This allows the TestCase to be executed multiple times, once for each set of test data provided by the attributes.<br>
For example:
```cs
[TestCase(1, 2, 3, 6)]
[TestCase(3, 4, 5, 12)]
[TestCase(6, 7, 8, 21)]
public void TestCaseArguments(int a, int b, int c, int expect)
{
   AssertThat(a + b + c).IsEqual(expect);
}
```
The **TestName** parameter can be used to give each parameterized test case a custom name. This is especially useful when multiple test cases are being run with different sets of data, as it allows for easy identification of which test case(s) failed.<br>
Here's an example:
```cs
[TestCase(1, 2, 3, 6, TestName = "TestCaseA")]
[TestCase(3, 4, 5, 12, TestName = "TestCaseB")]
[TestCase(6, 7, 8, 21, TestName = "TestCaseC")]
public void TestCasesWithCustomTestName(int a, double b, int c, int expect)
{
   AssertThat(a + b + c).IsEqual(expect);
}
```
{% endtab %}
{% endtabs %}

{% include advice.html 
content="The TestCase dataset must match the required input parameters and types. If the parameters do not match, a corresponding error is reported."
%}

---
<h4> document version v4.1.0 </h4>