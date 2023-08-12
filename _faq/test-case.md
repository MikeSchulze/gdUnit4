---
layout: default
title: TestCase
nav_order: 4
---

# TestCase

## Definition

Test cases are essential in software testing because they provide a way to ensure that the software is working as intended and meets the requirements and specifications of the project. By executing a set of test cases, testers can identify and report any defects or issues in the software, which can then be addressed by the development team.<br>
A test is defined as a function that follows the pattern **test_*****name***(*[arguments]*) -> *void*. The function name must start with the prefix **test_** to be identified as a test. You can choose any name for the ***name*** part, but it should correspond to the function being tested. Test *[arguments]* are optional and will be explained later in the advanced testing section.<br>
When naming your tests, use a descriptive name that accurately represents what the test does.


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


## Using Parameterized TestCases
See [Testing with Parameterized TestCases](/gdUnit4/advanced_testing/paramerized_tests/#testing-with-parameterized-testcases)<br>

## Using Fuzzers on Tests
See [Testing with Fuzzers](/gdUnit4/advanced_testing/fuzzing/#testing-with-fuzzers)<br>


## TestCase parameters
GdUnit allows you to define additional test parameters to have more control over the test execution.
{% tabs faq-test-case-attr %}
{% tab faq-test-case-attr GdScript %}
| Parameter | Description |
|---| ---|
| timeout | Defines a custom timeout in milliseconds. By default, a TestCase will be interrupted after 5 minutes if the tests are not finished.|
| fuzzer | Defines a fuzzer to provide test data. |
| fuzzer_iterations | Defines the number of times a TestCase will be run using the fuzzer. |
| fuzzer_seed | Defines a seed used by the fuzzer. |
| test_parameters | Defines the TestCase dataset for parameterized tests. |

{% endtab %}
{% tab faq-test-case-attr C# %}
| Parameter | Description |
|---| ---|
| Timeout | Defines a custom timeout in milliseconds. By default, a TestCase will be interrupted after 5 minutes if the tests are not finished. |
| TestName | Defines a custom TestCase name. |
| Seed | Defines a seed to provide test data. |
{% endtab %}
{% endtabs %}


### timeout
The **timeout** paramater sets the duration in milliseconds before a test case is interrupted. By default, a test case will be interrupted after 5 minutes if it has not finished executing.
You can customize the default timeout value in the [GdUnit Settings](/gdUnit4/first_steps/settings/#test-timeout-seconds). A test case that is interrupted by a timeout is marked and reported as a failure.

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


### fuzzer parameters
To learn how to use the fuzzer parameter, please refer to the [Using Fuzzers](/gdUnit4/advanced_testing/fuzzing/#using-fuzzers) section


### test_parameters
To learn how to use paramaterized tests, please refer to the [Parameterized TestCases](/gdUnit4/faq/test-case/#parameterized-testcases) section


---

## How to fail fast (GdScript only)
{% include advice.html 
content="Since GdScript does not have exceptions, we need to manually define an exit strategy to fail fast and avoid unnecessary test execution."
%}

This means a TestCase can fail by one or more assertions and will not be aborted at the first failed assertion. However, to abort after the first error and fail fast, you can use the function **is_failure()**.

Here's an example:
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

---
<h4> document version v4.1.0 </h4>