---
layout: default
title: TestSuite
nav_order: 1
---

# TestSuite

## Definition
A TestSuite is a collection of tests basically alligned to a class you want to test.<br>
When writing tests, it is common to find that several tests need similar test data to created before and cleanup after test run.<br>
GdUnit TestSuite runs in execution stages (hooks) where you allow to define preinitalisized test data.

{% tabs faq-TestSuite-stages %}
{% tab faq-TestSuite-stages GdScript %}
GdUnit use predefined functions to define the execution stages.<br>
To define a test you have to use the prefix `test_` e.g. `test_verify_is_string`

|Stage|Description|
|---| ---|
|before | executed only once at TestSuite run is started|
|after | executed only once at TestSuite run has finished|
|before_test | executed before each test is started|
|after_test | executed after each test has finished|
|test_<name> | executes the test content|
{% endtab %}
{% tab faq-TestSuite-stages C# %}
GdUnit use attributes to define the execution stages and tests.<br>
All GdUnit attributes are contained in the `namespace GdUnit3`

|Stage|Description|
|---| ---|
|[Before] | executed only once at TestSuite run is started|
|[After] | executed only once at TestSuite run has finished|
|[BeforeTest] | executed before each test is started|
|[AfterTest] | executed after each test has finished|
|[TestCase] | executes the test content|
{% endtab %}
{% endtabs %}

---

## Stage *before*
This stage is executed only once at the beginning of a TestSuite execution.<br>
GdUnit3 allows to use asserts within this stage, occurring errors are reported.

{% tabs faq-TestSuite-before %}
{% tab faq-TestSuite-before GdScript %}
**func before()**<br>
Use this function inside your TestSuite to define a pre-hook and prepare your TestSuite data.
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

var _test_data :Node

# create some test data here
func before():
   _test_data = Node.new()
```
{% endtab %}
{% tab faq-TestSuite-before C# %}
**[Before]**<br>
Use this attribute inside your TestSuite to define a method as pre hook to prepare your TestSuite data.
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        private Godot.Node _test_data;

        [Before]
        public void Setup()
        {
            // create some test data here
            _test_data = new Godot.Node();
        }
    }
}
```
{% endtab %}
{% endtabs %}

{% include advice.html 
content="If you create objects in the <b>Before</b> stage, you must release the object at the end in the <b>After</b> stage, otherwise, the object is reported as an orphan node.<br>
Alternatively, you can use the tool <b>auto_free()</b>,  the object is automatically freed at <b>After</b> stage."
%}
{% tabs faq-TestSuite-before %}
{% tab faq-TestSuite-before GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

var _test_data :Node

# create some test data here
func before():
   _test_data = auto_free(Node.new())
```
{% endtab %}
{% tab faq-TestSuite-before C# %}
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        private Godot.Node _test_data;

        [Before]
        public void Setup()
        {
            // create some test data here
            _test_data = AutoFree(new Godot.Node());
        }
    }
}
```
{% endtab %}
{% endtabs %}

---

## Stage *after*
This stage is executed only once at the end of a TestSuite execution.<br>
GdUnit3 allows to use asserts within this stage, occurring errors are reported.

{% tabs faq-TestSuite-after %}
{% tab faq-TestSuite-after GdScript %}
**func after():**<br>
Use this function inside your TestSuite to define a shutdown hook and release your TestSuite data.
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

var _test_data :Node

# give free resources where was created in before()
func after():
   _test_data.free()
```
{% endtab %}
{% tab faq-TestSuite-after C# %}
**[After]**<br>
Use this attribute inside your TestSuite to define a method as shutdown hook to release your TestSuite data.
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        private Godot.Node _test_data;

        [After]
        public void TearDownSuite()
        {
            // give free resources where was created in before()
            _test_data.Free();
        }
    }
}
```
{% endtab %}
{% endtabs %}

---

## Stage *before_test*
This stage is executed before each TestCase.<br>
GdUnit3 allows to use asserts within the this stage, occurring errors are reported.

{% tabs faq-TestSuite-before_test %}
{% tab faq-TestSuite-before_test GdScript %}
**func before_test():**<br>
Use this function inside your TestSuite to define a pre hook to initalize your TestCase data.
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

var _test_data :Node

# initalizize you test data here
func before_test():
   _test_data = Node.new()
```
{% endtab %}
{% tab faq-TestSuite-before_test C# %}
**[BeforeTest]**<br>
Use this attribute inside your TestSuite to define a method as pre hook to initalize your TestCase data.
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        private Godot.Node _test_data;

        [BeforeTest]
        public void SetupTest()
        {
            // initalizize you test data here
            _test_data = new Godot.Node();
        }
    }
}
```
{% endtab %}
{% endtabs %}
{% include advice.html 
content="If you create objects in the <b>before_test</b> stage, you must release the object at the end in the <b>after_test</b> stage, otherwise, the object is reported as an orphan node.<br>
Alternatively, you can use the tool <b>auto_free()</b>,  the object is automatically freed at <b>after_test</b> stage."
%}
{% tabs faq-TestSuite-before_test %}
{% tab faq-TestSuite-before_test GdScript %}
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

var _test_data :Node

# initalizize you test data here
func before_test():
   _test_data = auto_free(Node.new())
```
{% endtab %}
{% tab faq-TestSuite-before_test C# %}
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        private Godot.Node _test_data;

        [BeforeTest]
        public void SetupTest()
        {
            // initalizize you test data here
            _test_data = AutoFree(new Godot.Node());
        }
    }
}
```
{% endtab %}
{% endtabs %}

---

## Stage *after_test*
This stage is executed after each TestCase.<br>
GdUnit3 allows to use asserts within the this stage, occurring errors are reported.

{% tabs faq-TestSuite-after_test %}
{% tab faq-TestSuite-after_test GdScript %}
**func after_test():**<br>
Use this function inside your TestSuite to define a test clean up hook to release your TestCase data if neeed.
```ruby
class_name GdUnitExampleTest
extends GdUnitTestSuite

# clean up your test data
func after_test():
   ...
```
{% endtab %}
{% tab faq-TestSuite-after_test C# %}
**[AfterTest]**<br>
Use this attribute inside your TestSuite to define a method as clean up hook to release your TestCase data if neeed.
```cs
using GdUnit3;
using static GdUnit3.Assertions;

namespace ExampleProject.Tests
{
    [TestSuite]
    public class ExampleTest
    {
        [AfterTest]
        public void TearDownTest()
        {
            // clean up your test data
        }
    }
}
```
{% endtab %}
{% endtabs %}

---

## The execution graph of an TestSuite execution

{% tabs faq-TestSuite-overview %}
{% tab faq-TestSuite-overview GdScript %}
```ruby
 (Run)
   |- func before() -> void: # init the TestSuite
   |    ...
   |
   [...] # loops over all tests
      |     
      |- func before_test() -> void: # init next TestCase
      |    ...
      |
      >--- 
         | func test_1() -> void: # execute TestCase (1-n iterations)
         |   ...
      <---
      |  
      |- func after_test() -> void: # clean-up current TestCase finished
      |     ...
   [...]
   |   
   | - func after() -> void: # clean-up TestSuite finished
   |      ....
 (END)
```
{% endtab %}
{% tab faq-TestSuite-overview C# %}
```cs
 (Run)
   |- [Before] // init the TestSuite
   |  public void Setup() {}
   |
   [...] // loops over all tests
      |     
      |- [BeforeTest] // init next TestCase
      |  public void SetupTest() {}
      |
      >--- 
         | [TestCase] // execute TestCase (1-n iterations)
         | public void TestCase1() {}
      <---
      |  
      |- [AfterTest] // clean-up current TestCase finished
      |  public void TearDownTest() {}
   [...]
   |   
   | - [After] // clean-up TestSuite finished
   |   public void TearDownSuite() {}
 (END)
```
{% endtab %}
{% endtabs %}
