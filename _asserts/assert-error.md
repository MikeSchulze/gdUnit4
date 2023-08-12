---
layout: default
title: Error Assert
parent: Asserts
nav_order: 13
---

# Error Assertion

The `assert_error` function in GdUnit4 is designed to test for Godot runtime errors, such as failing asserts, script runtime errors, `push_error`, and `push_warning` messages. This function allows you to ensure that specific error conditions are met during the execution of your code.


{% tabs assert-error-overview %}
{% tab assert-error-overview GdScript %}
**GdUnitGodotErrorAssert**<br>

|Function|Description|
|--- | --- |
|[is_success](/gdUnit4/asserts/assert-error/#testing-for-success)| Verifies if the executed code runs without any runtime errors.|
|[is_runtime_error](/gdUnit4/asserts/assert-error/#testing-for-assert-failed)| Verifies if the executed code runs into a runtime error.|
|[is_push_warning](/gdUnit4/asserts/assert-error/#testing-for-push-warnings-and-push-errors)| Verifies if the executed code has a push_warning() used.|
|[is_push_error](/gdUnit4/asserts/assert-error/#testing-for-push-warnings-and-push-errors)| Verifies if the executed code has a push_error() used.|

{% endtab %}
{% tab assert-error-overview C# %}
**IErrorAssert**<br>

### Not implemented yet!

|Function|Description|
|--- | --- |
|[IsSuccess](/gdUnit4/asserts/assert-error/#testing-for-success)| Verifies if the executed code runs without any runtime errors.|
|[IsRuntimeError](/gdUnit4/asserts/assert-error/#testing-for-assert-failed)| Verifies if the executed code runs into a runtime error.|
|[IsPushWarning](/gdUnit4/asserts/assert-error/#testing-for-push-warnings-and-push-errors)| Verifies if the executed code has a push_warning() used.|
|[IsPushError](/gdUnit4/asserts/assert-error/#testing-for-push-warnings-and-push-errors)| Verifies if the executed code has a push_error() used.|

{% endtab %}
{% endtabs %}

## Testing for Success

To test whether a specific code snippet runs successfully without any errors, you can use the `is_success()` function with `assert_error`. Here's an example:

{% tabs assert-error-is_success %}
{% tab assert-error-is_success GdScript %}
```gdscript
    func assert_error(<Callable>).is_success() -> GdUnitGodotErrorAssert:
```

```gdscript
    func test_is_success() -> void:
        await assert_error(func(): <code to execute>).is_success()
```
{% endtab %}
{% tab assert-error-is_success C# %}
### Not implemented yet!
```cs
```
{% endtab %}
{% endtabs %}

Replace `<code to execute>` with the actual code snippet you want to test. If the code executes without any runtime errors, the test will pass; otherwise, it will fail.

## Testing for Assert Failed

You can use `assert_error` to verify that an assertion failure occurs during the execution of your code. This can help you ensure that your asserts are working correctly. Here's an example:

{% tabs assert-error-is_failed %}
{% tab assert-error-is_failed GdScript %}
```gdscript
    func assert_error(<Callable>).is_runtime_error(<message>) -> GdUnitGodotErrorAssert:
```

```gdscript
    func test_is_assert_failed() -> void:
        await assert_error(func(): <code to execute>)\
            .is_runtime_error('Assertion failed: this is an assert error')
```
{% endtab %}
{% tab assert-error-is_failed C# %}
### Not implemented yet!
```cs
```
{% endtab %}
{% endtabs %}

Replace `<code to execute>` with the code snippet that contains the assertion you want to test. The `is_runtime_error` function checks whether the expected assertion error message is generated. If the assertion fails as expected, the test will pass; otherwise, it will fail.

## Testing for Push Warnings and Push Errors

You can also use `assert_error` to test for specific push warnings and push errors that may occur during the execution of your code. Here are examples for both cases:

{% tabs assert-error-is_push %}
{% tab assert-error-is_push GdScript %}
```gdscript
    func assert_error(<Callable>).is_push_warning(<message>) -> GdUnitGodotErrorAssert:
    func assert_error(<Callable>).is_push_error(<message>) -> GdUnitGodotErrorAssert:
```

```gdscript
    func test_is_push_warning() -> void:
        await assert_error(func(): <code to execute>)\
            .is_push_warning('this is a push_warning')

    func test_is_push_error() -> void:
        await assert_error(func(): <code to execute>)\
            .is_push_error('this is a push_error')
```
{% endtab %}
{% tab assert-error-is_push C# %}
### Not implemented yet!
```cs
```
{% endtab %}
{% endtabs %}

Replace `<code to execute>` with the relevant code snippet that may generate a push warning or a push error. The `is_push_warning` and `is_push_error` functions check whether the expected warning or error message is generated during code execution. If the message is generated as expected, the test will pass; otherwise, it will fail.

## Conclusion

Using `assert_error` in GdUnit4 allows you to test for specific runtime errors and conditions that may occur during the execution of your Godot code. This helps you ensure the reliability and correctness of your application by catching and verifying error scenarios.

---
<h4> document version v4.1.4 </h4>