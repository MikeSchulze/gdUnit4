---
layout: default
title: Skip Tests
parent: Advanced Testing
nav_order: 10
---

# How to Skip Tests in GdUnit4

In GdUnit4, you can skip individual test cases or entire test suites using the `do_skip` parameter. This parameter allows you to specify conditions
under which a test should be skipped during execution. By default, tests are not skipped unless specified.

## Skipping Individual Test Cases

To skip an individual test case, you can use the `do_skip` parameter when defining the test case function. Set the parameter to `true` to skip the test case.

Here's an example of skipping an individual test case:

{% tabs faq-test-skip_test %}
{% tab faq-test-skip_test GdScript %}

```gd
func test_case1(_do_skip := true):
    ...
```

💡 To avoid warnings about unused arguments, use the underscore prefix `_` or use `@warning_ignore(“unused_parameter”)`.

{% endtab %}
{% tab faq-test-skip_test C# %}

```cs
[TestCase(DoSkip = true)]
public void Case1()
{
   ...
```

{% endtab %}
{% endtabs %}

In this example, the test `test_case1` will be skipped because the `do_skip` parameter is set to `true`.

## Skipping Entire Test Suites

You can skip entire test suites using the `do_skip` parameter on the `before` hook. Set the parameter to `true` to skip the test suite.

Here's an example of skipping an entire test suite:

{% tabs faq-test-skip %}
{% tab faq-test-skip GdScript %}

```gd
func before(_do_skip := true):
    # Test hook code here
```

💡 To avoid warnings about unused arguments, use the underscore prefix `_` or use `@warning_ignore(“unused_parameter”)`.

{% endtab %}
{% tab faq-test-skip C# %}

```cs
[Before(DoSkip = true)]
public void Before()
{
```

{% endtab %}
{% endtabs %}

In this example, all tests within this test-suite will be skipped because the `do_skip` parameter is set to `true`.

## Customizing Skip Reasons

You can provide a custom skip reason using the `skip_reason` parameter. This reason will be displayed when the test is skipped. It helps provide context for
why the test is being skipped.

{% tabs faq-test-skip-reason %}
{% tab faq-test-skip-reason GdScript %}

```gd
func test_case1(_do_skip := true, _skip_reason := "Test case under development"):
    # Test case code here
```

💡 To avoid warnings about unused arguments, use the underscore prefix `_` or use `@warning_ignore(“unused_parameter”)`.

{% endtab %}
{% tab faq-test-skip-reason C# %}

```cs
[TestCase(DoSkip = true, SkipReason="Test case under development")]
public void Case1()
{
   ...
```

{% endtab %}
{% endtabs %}

In this example, the test `test_case1` will be skipped with the reason "Test case under development."

## Skipping with Conditional Expressions

You can also use conditional expressions for the `do_skip` parameter to skip tests or a test-suite based on runtime evaluations.
For example, you can use an expression to dynamically decide whether a test should be skipped or not.

Here's an example of using a conditional expression to skip a test case:

{% tabs faq-test-skip-expression %}
{% tab faq-test-skip-expression GdScript %}

```gd
func test_case1(_do_skip := Engine.get_version_info().hex < 0x40100):
    # Test case code here
```

💡 To avoid warnings about unused arguments, use the underscore prefix `_` or use `@warning_ignore(“unused_parameter”)`.

{% endtab %}
{% tab faq-test-skip-expression C# %}

```cs
[TestCase(DoSkip = Engine.get_version_info().hex < 0x40100)]
public void Case1()
{
   ...
```

{% endtab %}
{% endtabs %}

In this example, the test `test_case1` will be skipped for all Godot version before 4.1.x the expression is evaluates at runtime.

## Conclusion

Skipping tests using the `do_skip` parameter allows you to control which tests are executed based on specific conditions.
This can be useful when you want to temporarily exclude tests that are not ready or relevant for the current state of your project.
