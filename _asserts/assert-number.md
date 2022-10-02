---
layout: default
title: Number Assert
parent: Asserts
nav_order: 3
---

# Number Assertions (C# only)

An assertion tool to verify number values.<br>
Supported numbers are **sbyte**, **byte**, **short**, **ushort**, **int**, **uint**, **long**, **ulong**, **float**, **double**, **decimal**

**INumberAssert\<V\>**<br>

|Function|Description|
|--- | --- |
|[IsNull](/gdUnit3/asserts/assert-number/#isnull) | Verifies that the current value is null.|
|[IsNotNull](/gdUnit3/asserts/assert-number/#isnotnull) | Verifies that the current value is not null.|
|[IsEqual](/gdUnit3/asserts/assert-number/#isequal) | Verifies that the current value is equal to the given one.|
|[IsNotEqual](/gdUnit3/asserts/assert-number/#isnotequal) | Verifies that the current value is not equal to the given one.|
|[IsLess](/gdUnit3/asserts/assert-number/#isless) | Verifies that the current value is less than the given one.|
|[IsLessEqual](/gdUnit3/asserts/assert-number/#islessequal) | Verifies that the current value is less than or equal the given one.|
|[IsGreater](/gdUnit3/asserts/assert-number/#isgreater) | Verifies that the current value is greater than the given one.|
|[IsGreaterEqual](/gdUnit3/asserts/assert-number/#isgreaterequal) | Verifies that the current value is greater than or equal the given one.|
|[IsEven](/gdUnit3/asserts/assert-number/#iseven) | Verifies that the current value is even.|
|[IsOdd](/gdUnit3/asserts/assert-number/#isodd) | Verifies that the current value is odd.|
|[IsNegative](/gdUnit3/asserts/assert-number/#isnegative) | Verifies that the current value is negative.|
|[IsNotNegative](/gdUnit3/asserts/assert-number/#isnotnegative) | Verifies that the current value is not negative.|
|[IsZero](/gdUnit3/asserts/assert-number/#iszero) | Verifies that the current value is equal to zero.|
|[IsNotZero](/gdUnit3/asserts/assert-number/#isnotzero) | Verifies that the current value is not equal to zero.|
|[IsIn](/gdUnit3/asserts/assert-number/#isin) | Verifies that the current value is in the given set of values.|
|[IsNotIn](/gdUnit3/asserts/assert-number/#isnotin) | Verifies that the current value is not in the given set of values.|
|[IsBetween](/gdUnit3/asserts/assert-number/#isbetween) | Verifies that the current value is between the given boundaries (inclusive).|


---
## NumberAssert Examples

### IsEqual
Verifies that the current value is equal to the given one.

```cs
    INumberAssert AssertThat(<current>).IsEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(23).IsEqual(23);

    // this assertion fails because 23 are not equal to 42
    AssertThat(23).IsEqual(42);
```

### IsNotEqual
Verifies that the current value is not equal to the given one.
```cs
    INumberAssert AssertThat(<current>).IsNotEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(23).IsNotEqual(42);

    // this assertion fails because 23 are equal to 23 
    AssertThat(23).IsNotEqual(23);
```

### IsLess
Verifies that the current value is less than the given one.
```cs
    INumberAssert AssertThat(<current>).IsLess(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(23).IsLess(42);
    AssertThat(23).IsLess(24);

    // this assertion fails because 23 is not less than 23
    AssertThat(23).IsLess(23);
```

### IsLessEqual
Verifies that the current value is less than or equal the given one.
```cs
    INumberAssert AssertThat(<current>).IsLessEqual(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(23).IsLessEqual(42);
    AssertThat(23).IsLessEqual(23);

    // this assertion fails because 23 is not less than or equal to 22
    AssertThat(23).IsLessEqual(22);
```

### IsGreater
Verifies that the current value is greater than the given one.
```cs
    INumberAssert AssertThat(<current>).IsGreater(<expected>)
```
```cs
    // this assertion succeeds
    AssertThat(23).IsGreater(20);
    AssertThat(23).IsGreater(22);

    // this assertion fails because 23 is not greater than 23
    AssertThat(23).IsGreater(23);
```

### IsGreaterEqual
Verifies that the current value is greater than or equal the given one.
```cs
    INumberAssert AssertThat(<current>).IsGreaterEqual(<expected>)
```
```cs
    AssertThat(23).IsGreaterEqual(20)
    AssertThat(23).IsGreaterEqual(23)

    # this assertion fails because 23 is not greater than 23
    AssertThat(23).IsGreaterEqual(24)
```

### IsEven
Verifies that the current value is even.
```cs
    INumberAssert AssertThat(<current>).IsEven()
```
```cs
    // this assertion succeeds
    AssertThat(12).IsEven();

    // this assertion fail because the value '13' is not even
    AssertThat(13).IsEven();
```

### IsOdd
Verifies that the current value is odd.
```cs
    INumberAssert AssertThat(<current>).IsOdd()
```
```cs
    // this assertion succeeds
    AssertThat(13).IsOdd();

    // this assertion fail because the value '12' is even
    AssertThat(12).IsOdd();
```

### IsNegative
Verifies that the current value is negative.
```cs
    INumberAssert AssertThat(<current>).IsNegative()
```
```cs
    // this assertion succeeds
    AssertThat(-13).IsNegative();

    // this assertion fail because the value '13' is positive
    AssertThat(13).IsNegative();
```

### IsNotNegative
Verifies that the current value is not negative.
```cs
    INumberAssert AssertThat(<current>).IsNotNegative()
```
```cs
    // this assertion succeeds
    AssertThat(13).IsNotNegative();

    // this assertion fail because the value '-13' is negative
    AssertThat(-13).IsNotNegative();
```

### IsZero
Verifies that the current value is equal to zero.
```cs
    INumberAssert AssertThat(<current>).IsZero()
```
```cs
    // this assertion succeeds
    AssertThat(0).IsZero();

    // this assertion fail because the value is not zero
    AssertThat(1).IsZero();
```

### IsNotZero
Verifies that the current value is not equal to zero.
```cs
    INumberAssert AssertThat(<current>).IsNotZero()
```
```cs
    // this assertion succeeds
    AssertThat(1).IsNotZero();

    // this assertion fail because the value is zero
    AssertThat(0).IsNotZero();
```

### IsIn
Verifies that the current value is in the given set of values.
```cs
    INumberAssert AssertThat(<current>).IsIn([] <expected>)
```
```cs
    // this assertion succeeds
    AssertThat(5).IsIn(3, 4, 5, 6);

    // this assertion fail because 7 is not in [3, 4, 5, 6]
    AssertThat(7).IsIn(3, 4, 5, 6);
```

### IsNotIn
Verifies that the current value is not in the given set of values.
```cs
    INumberAssert AssertThat(<current>).IsNotIn([] <expected>)
```
```cs
    // this assertion succeeds
    AssertThat(5).IsNotIn(3, 4, 6, 7);

    // this assertion fail because 5 is in [3, 4, 5, 6]
    AssertThat(5).IsNotIn(3, 4, 5, 6);
```

### IsBetween
Verifies that the current value is between the given boundaries (inclusive).
```cs
    INumberAssert AssertThat(<current>).IsBetween(<from>, <to>)
```
```cs
    // this assertion succeeds
    AssertThat(23).IsBetween(20, 30);
    AssertThat(23).IsBetween(23, 24);

    // this assertion fail because the value is zero and not between 1 and 9
    AssertThat(0).IsBetween(1, 9);
```
