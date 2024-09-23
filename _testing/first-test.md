---
layout: default
title: Unit Tests
nav_order: 1
---

# Unit Test

What is Unit Testing?
Unit testing is a fundamental practice in software development that involves testing individual components or "units" of your code to ensure they work as expected in isolation. In game development, a unit typically refers to a small piece of functionality, such as a single function, method, or class. The goal of unit testing is to verify that each unit of your code performs its intended task correctly and to catch bugs early in the development process.

## Key Characteristics of Unit Testing

* **Isolation:** Each test targets a specific piece of code, independent of other parts of the system. This isolation helps identify which component is responsible for any given issue.
* **Automated:** Unit tests are usually automated, allowing developers to run them frequently, quickly, and consistently. This automation is especially useful for catching regressions after changes are made to the codebase.
* **Fast and Focused:** Unit tests should be small and fast to execute, focusing on a single "unit" of functionality. This makes them ideal for verifying specific behaviors, such as a character’s movement logic or a function that calculates in-game scores.

## Benefits of Unit Testing

* **Early Bug Detection:** By testing individual components, you can detect and fix bugs early in the development cycle before they affect other parts of your game.
Improved Code Quality:** Writing unit tests encourages developers to write modular, maintainable, and well-documented code. It also helps ensure that each unit of functionality behaves as intended.
* **Refactoring Confidence:** Unit tests act as a safety net when refactoring or optimizing code. If all tests pass after changes are made, you can be confident that your updates haven’t introduced new bugs.
* **Documentation:** Unit tests serve as a form of documentation by demonstrating how specific functions or classes are intended to be used, making it easier for other developers to understand the codebase.

## Writing Unit Tests in Game Development

In the context of game development, unit tests can be used to verify:

* **Game Logic:** Testing rules and mechanics, such as character health calculations, score updates, or level progression.
* **Math Functions:** Verifying mathematical calculations, such as physics equations or vector operations.
* **Utility Functions:** Testing helper functions that perform operations like data parsing, string manipulation, or AI decision-making.
* **State Management:** Ensuring that game states (e.g., paused, active, game-over) transition correctly and behave as expected.

## GdUnit4 TestCase Definition

Test cases are essential in software testing because they provide a way to ensure that the software is working as intended and meets the requirements and specifications of the project. By executing a set of test cases, testers can identify and report any defects or issues in the software, which can then be addressed by the development team.<br>
A test is defined as a function that follows the pattern **test_*****name***(*[arguments]*) -> *void*. The function name must start with the prefix **test_** to be identified as a test. You can choose any name for the ***name*** part, but it should correspond to the function being tested. Test *[arguments]* are optional and will be explained later in the advanced testing section.<br>
When naming your tests, use a descriptive name that accurately represents what the test does.

---

## Single TestCase

{% tabs faq-test-case-name %}
{% tab faq-test-case-name GdScript %}
To define a TestCase you have to use the prefix `test_` e.g. `test_verify_is_string`<br>

```ruby
extends GdUnitTestSuite

func test_string_to_lower() -> void:
   assert_str("AbcD".to_lower()).is_equal("abcd")
```

We named it **test_*string_to_lower()*** because we test the `to_lower` function on a string.<br>

{% endtab %}
{% tab faq-test-case-name C# %}
Use the **[TestCase]** attribute to define a method as a TestCase.

```cs
namespace Examples;

using GdUnit4;
using static GdUnit4.Assertions;

[TestSuite]
public class GdUnitExampleTest
{
   [TestCase]
   public void StringToLower() {
      AssertString("AbcD".ToLower()).IsEqual("abcd");
   }
}
```

We named it **StringToLower()** because we test the `ToLower` function on a string.<br>
{% endtab %}
{% endtabs %}

## Using Parameterized TestCases

See [Testing with Parameterized TestCases](/gdUnit4/advanced_testing/paramerized_tests/#testing-with-parameterized-testcases)<br>

## Using Fuzzers on Tests

See [Testing with Fuzzers](/gdUnit4/advanced_testing/fuzzing/#testing-with-fuzzers)<br>

## TestCase Parameters

GdUnit allows you to define additional test parameters to have more control over the test execution.
{% tabs faq-test-case-attr %}
{% tab faq-test-case-attr GdScript %}

| Parameter | Description |
|---| ---|
| timeout | Defines a custom timeout in milliseconds. By default, a TestCase will be interrupted after 5 minutes if the tests are not finished.|
| do_skip | Set to 'true' to skip the test. Conditional expressions are supported. |
| skip_reason | Adds a comment why you want to skip this test. |
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

To learn how to use parameterized tests, please refer to the [Parameterized TestCases](/gdUnit4/advanced_testing/paramerized_tests/#testing-with-parameterized-testcases) section

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
