---
layout: default
title: TestCase
nav_order: 2
---

# TestCase

## Definition

A TestCase document described detailed summary of what scenarios will be tested.<br>
Use a meaningfull name for your test to represent what the test does.

---

## Single TestCase

{% tabs faq-test-case-name %}
{% tab faq-test-case-name GdScript %}
To define a TestCase you have to use the prefix `test_` e.g. `test_verify_is_string`<br>
```ruby
func test_string_to_lower() -> void:
   assert_str("AbcD".to_lower()).is_equal("abcd")
```
We named it **test_*string_to_lower()*** because we test the `to_lower` function on a string.<br>

{% endtab %}
{% tab faq-test-case-name C# %}
Use the **[TestCase]** attribute to define a method as a TestCase.
```cs
[TestCase]
public void StringToLower() {
   AssertString("AbcD".ToLower()).IsEqual("abcd");
}
```
We named it **StringToLower()** because we test the `ToLower` function on a string.<br>
{% endtab %}
{% endtabs %}

---

## Parameterized TestCase's
A parameterized test will help you to hold your TestSuite clean if you have equalent test setups.<br>
You can define the required test parameters on the TestCase.

{% tabs faq-test-case-name %}
{% tab faq-test-case-name GdScript %}
To define a TestCase with parameters you have to add the input parameters and the test data set with name **test_parameters**.<br>
This TestCase will now executed three times with the test data given by parameter **test_parameters**.
```ruby
func test_parameterized_int_values(a: int, b :int, c :int, expected :int, test_parameters := [
	[1, 2, 3, 6],
	[3, 4, 5, 12],
	[6, 7, 8, 21] ]):
	
	assert_that(a+b+c).is_equal(expected)
```
{% endtab %}
{% tab faq-test-case-name C# %}
To define a TestCase with parameters you have to use for each case the attribute **[TestCase]** with a test data set.<br>
This TestCase will now executed three times with the test data given the three TestCase attributes.
```cs
[TestCase(1, 2, 3, 6)]
[TestCase(3, 4, 5, 12)]
[TestCase(6, 7, 8, 21)]
public void TestCaseArguments(int a, int b, int c, int expect)
{
   AssertThat(a + b + c).IsEqual(expect);
}
```
You can give each TestCase a custom name by using the **TestName** parameter.
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
content="The TestCase dataset must be match with the requred input parameters and types.<br>If the parameters do not match, a corresponding error is reported."
%}

---

## TestCase attributes
GdUnit allows you to define additional test parameters to get more controll over the test execution.
{% tabs faq-test-case-attr %}
{% tab faq-test-case-attr GdScript %}
| Parameter | Description |
|---| ---|
| timeout | Defines a custom timeout in ms. By default a TestCase will be interuppted after 5min when the test are not finished.|
| fuzzer | Defines a fuzzer to provide test data |
| fuzzer_iterations | Defines the count of TestCase iteration using the fuzzer |
| fuzzer_seed | Defines a seed used by the fuzzer|
| test_parameters | Defines the TestCase dataset for paremeterizes tests|

{% endtab %}
{% tab faq-test-case-attr C# %}
| Parameter | Description |
|---| ---|
| Timeout | Defines a custom timeout in ms. By default a TestCase will be interuppted after 5min when the test are not finished. |
| TestName | Defines a custom TestCase name |
| Seed | Defines a seed to provide test data |
{% endtab %}
{% endtabs %}


### timeout
Sets the timeout for the TestCase in ms. By default, a TestCase is interrupted after 5 minutes if it has not yet finished.<br>
The default timeout can be configured on [GdUnit Settings](/gdUnit3/first_steps/settings/#test-timeout-seconds)<br>
A test case interrupted by a timeout is marked and reported as failed.
{% tabs faq-test-case-attr-timeout %}
{% tab faq-test-case-attr-timeout GdScript %}
Sets the test execution timeout to 2s.
```ruby
func test_with_timeout(timeout=2000):
   ...
```
{% endtab %}
{% tab faq-test-case-attr-timeout C# %}
Sets the test execution timeout to 2s.
```cs
[TestCase(Timeout = 2000)]
public async Task ATestWithTimeout()
{
   ...
```
{% endtab %}
{% endtabs %}

---

## How to fail fast (GdScript only)
{% include advice.html 
content="GdScript does not have exceptions, we need to define manally an exit strategy."
%}

This means a TestCase can fail by one or more assertions and will not aborted at the first failed assertion.<br>
However, to abort after the first error you can use the function *is_failure*.

### Example
```ruby
func test_foo():
   # do some assertions
   assert_str("").is_empty()
   # last assert was succes 
   if is_failure():
      return
   asset_str("abc").is_empty()
   # last assert was failure, now abort the test here
   if is_failure():
      return

   ...
```

