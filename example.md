---
layout: default
title: Basic Test Example
nav_order: 2
---

# Basic Test Example

This small example shows how to define a unit test in GdUnit4.
{% tabs example %}
{% tab example GDScript %}

```gdscript
extends GdUnitTestSuite

func test_example():
  assert_str("This is an example message")\
    .has_length(26)\
    .starts_with("This is an ex")
```

{% endtab %}
{% tab example C# %}

```cs
namespace Examples;

using GdUnit4;

using static GdUnit4.Assertions;


[TestSuite]
public class GdUnitExampleTest
{
    [TestCase]
    public void Example()
    {
        AssertString("This is an example message")
          .HasLength(26)
          .StartsWith("This is an ex");
    }
}

```

{% endtab %}
{% endtabs %}

---
<h4> document version v4.2.5 </h4>
