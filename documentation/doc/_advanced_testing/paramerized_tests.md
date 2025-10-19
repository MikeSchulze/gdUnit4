---
layout: default
title: Parameterized Tests
parent: Advanced Testing
nav_order: 2
---

# Testing with Parameterized TestCases

## Parameterized TestCases

Parameterized tests can help keep your test suite organized by allowing you to define multiple test scenarios with different inputs using a single
test function. You can define the required test parameters on the TestCase and use them in your test function to generate various test cases.
This is especially useful when you have similar test setups with different inputs.

{% tabs faq-test-case-name %}
{% tab faq-test-case-name GdScript %}
To define a TestCase with parameters, you need to add input parameters and a test data set with the name **test_parameters**.
This TestCase will be executed multiple times with the test data provided by the **test_parameters** parameter.<br>
Here's an example:
```gd
func test_parameterized_int_values(a: int, b :int, c :int, expected :int, test_parameters := [
     [1, 2, 3, 6],
     [3, 4, 5, 12],
     [6, 7, 8, 21] ]):
     
     assert_that(a+b+c).is_equal(expected)
```
{% endtab %}
{% tab faq-test-case-name C# %}
To define a TestCase with parameters, you can use the attribute **[TestCase]** and provide it with a test data set for each parameter set.
This allows the TestCase to be executed multiple times, once for each set of test data provided by the attributes.<br>
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
The **TestName** parameter can be used to give each parameterized test case a custom name.
This is especially useful when multiple test cases are being run with different sets of data,
as it allows for easy identification of which test case(s) failed.<br>
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

💡 **Note:** The TestCase dataset must match the required input parameters and types. If the parameters do not match, a corresponding error is reported.

---

## Data-Driven Tests with Dynamic Test Data (C# Only)

GdUnit4Net supports advanced data-driven testing through the `[DataPoint]` attribute, which allows you to define dynamic test data using properties,
methods, or external data sources. This feature is only available in the C# API and provides more flexibility than static TestCase attributes.

### Key Features of DataPoint Testing

- **Dynamic Data Generation**: Create test data at runtime based on conditions or external sources
- **Async Support**: Generate test data asynchronously for complex scenarios
- **External Sources**: Reference data from other classes or assemblies
- **Parameterized Factories**: Pass parameters to data generation methods
- **Lazy Evaluation**: Use yield return for memory-efficient data generation
- **Timeout Support**: Async data generation respects test timeout settings

💡 **Performance Tip:** Use yielded or async DataPoints for large datasets to improve memory efficiency and test performance.

⚠️ **C# Only Feature:** Data-driven tests with dynamic test data using the `[DataPoint]` attribute are only available in the GdUnit4Net C# API.
     GdScript users should use the standard parameterized TestCase approach.

### Basic DataPoint Usage

You can use the `[DataPoint]` attribute to reference static properties or methods that provide test data:

```cs
public class DataDrivenTestSuite
{
    // Static property providing test data
    public static IEnumerable<object[]> AdditionTestData => 
    [
        [1, 2, 3],
        [4, 5, 9],
        [10, 15, 25]
    ];

    // Static method providing test data
    public static IEnumerable<object[]> MultiplicationTestData() => 
    [
        [2, 3, 6],
        [4, 5, 20],
        [7, 8, 56]
    ];

    [TestCase]
    [DataPoint(nameof(AdditionTestData))]
    public void TestAddition(int a, int b, int expected)
    {
        AssertThat(a + b).IsEqual(expected);
    }

    [TestCase]
    [DataPoint(nameof(MultiplicationTestData))]
    public void TestMultiplication(int a, int b, int expected)
    {
        AssertThat(a * b).IsEqual(expected);
    }
}
```

### Single Value DataPoints

For tests that only need a single parameter, you can use `IEnumerable<T>`:

```cs
public static IEnumerable<int> SingleValues => [1, 2, 3, 4, 5];

[TestCase]
[DataPoint(nameof(SingleValues))]
public void TestSingleValue(int value)
{
    AssertThat(value).IsGreater(0);
}
```

### Parameterized DataPoint Methods

DataPoint methods can accept parameters to generate dynamic test data:

```cs
public static IEnumerable<object[]> GenerateTestData(int multiplier) => 
[
    [1 * multiplier, 1 * multiplier],
    [2 * multiplier, 2 * multiplier],
    [3 * multiplier, 3 * multiplier]
];

[TestCase]
[DataPoint(nameof(GenerateTestData), 5)]
public void TestWithMultiplier(int value, int expected)
{
    AssertThat(value).IsEqual(expected);
}
```

### External DataPoint Sources

You can reference data from external classes:

```cs
public class ExternalDataPoints
{
    public static IEnumerable<object[]> ExternalTestData => 
    [
        [100, 200, 300],
        [150, 250, 400]
    ];
}

[TestCase]
[DataPoint(nameof(ExternalDataPoints.ExternalTestData), typeof(ExternalDataPoints))]
public void TestWithExternalData(int a, int b, int expected)
{
    AssertThat(a + b).IsEqual(expected);
}
```

### Asynchronous DataPoints

GdUnit4Net supports asynchronous data generation using `IAsyncEnumerable<T>`:

```cs
public static async IAsyncEnumerable<object[]> AsyncTestData()
{
    for (int i = 0; i < 3; i++)
    {
        await Task.Delay(10); // Simulate async work
        yield return [i, i + 1, i + i + 1];
    }
}

[TestCase]
[DataPoint(nameof(AsyncTestData))]
public void TestAsyncData(int a, int b, int expected)
{
    AssertThat(a + b).IsEqual(expected);
}
```

### Yielded DataPoints

You can use `yield return` for lazy data generation:

```cs
public static IEnumerable<object[]> YieldedTestData()
{
    yield return [1, 1, 2];
    yield return [2, 2, 4];
    yield return [3, 3, 6];
}

[TestCase]
[DataPoint(nameof(YieldedTestData))]
public void TestYieldedData(int a, int b, int expected)
{
    AssertThat(a * b).IsEqual(expected);
}
```

### DataPoint with Timeout

Asynchronous DataPoints respect test timeouts:

```cs
public static async IAsyncEnumerable<object[]> SlowAsyncData()
{
    await Task.Delay(500); // This will exceed the timeout
    yield return [1, 2, 3];
}

[TestCase(Timeout = 100)]
[DataPoint(nameof(SlowAsyncData))]
[ThrowsException(typeof(AsyncDataPointCanceledException), "The execution has timed out after 100ms.")]
public void TestTimeoutHandling(int a, int b, int expected)
{
    AssertThat(a + b).IsEqual(expected);
}
```
