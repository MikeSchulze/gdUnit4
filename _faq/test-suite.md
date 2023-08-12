---
layout: default
title: TestSuite
nav_order: 5
---

# TestSuite

## Definition
A TestSuite is a collection of tests that are aligned to a specific class or module that you want to test. When writing tests, it is common to find that several tests require similar test data to be created before and cleaned up after the test run. GdUnit TestSuites allow you to define pre-initialized test data and cleanup functions that will be executed at specific points during test execution.

In addition to containing multiple test cases, a TestSuite can also contain setup and teardown functions that are executed before and after each test case, as well as before and after the entire TestSuite. This allows you to control the test environment and ensure that tests are executed in a consistent and repeatable manner.


## TestSuite Hooks
GdUnit TestSuites provide the following hooks that allow you to control the test environment. GdUnit4 allows you to use asserts within these stages, and any errors that occur will be reported.

{% tabs faq-TestSuite-stages %}
{% tab faq-TestSuite-stages GdScript %}
GdUnit uses predefined functions to define the execution stages.<br>
To define a test, you must use the prefix `test_`, e.g. `test_verify_is_string`.

|Stage|Description|
|---| ---|
| before        | executed only once at the start of the TestSuite run        |
| after         | executed only once at the end of the TestSuite run          |
| before_test   | executed before each test is started                        |
| after_test    | executed after each test has finished                       |
| test_<name>   | executes the test content, where `<name>` is the test name  |
{% endtab %}
{% tab faq-TestSuite-stages C# %}
GdUnit use attributes to define the execution stages and tests.<br>
All GdUnit attributes are contained in the `namespace GdUnit4`

|Stage|Description|
|---| ---|
|[Before]     | executed only once at the start of the TestSuite run |
|[After]      | executed only once at the end of the TestSuite run   |
|[BeforeTest] | executed before each test is started                 |
|[AfterTest]  | executed after each test has finished                |
|[TestCase]   | executes the test content                            |
{% endtab %}
{% endtabs %}

---

## The stage *before*
This function is executed once at the beginning of the TestSuite and is used to set up any resources or data that will be required by all of the test cases in the suite. For example, if you need to create a database connection or initialize a global configuration object, you would do so in this function.

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
using GdUnit4;
using static GdUnit4.Assertions;

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
content="If you create objects in the <b>before</b> stage, you must release the object at the end in the <b>after</b> stage, otherwise, the object is reported as an orphan node.<br>
Alternatively, you can use the tool <b>auto_free()</b>,  the object is automatically freed at <b>after</b> stage."
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
using GdUnit4;
using static GdUnit4.Assertions;

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
This function is executed once at the end of the TestSuite and is used to clean up any resources or data that was created or modified during the test run. For example, if you need to close a database connection or delete temporary files, you would do so in this function.

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
using GdUnit4;
using static GdUnit4.Assertions;

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
This function is executed before each test case and is used to set up any resources or data that are required by the test case. For example, if you need to create a temporary file or initialize a class instance, you would do so in this function.

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
using GdUnit4;
using static GdUnit4.Assertions;

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
using GdUnit4;
using static GdUnit4.Assertions;

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
This function is executed after each test case and is used to clean up any resources or data that were created or modified during the test case. For example, if you need to delete a temporary file or close a network connection, you would do so in this function.

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
using GdUnit4;
using static GdUnit4.Assertions;

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

## The Execution Graph of a TestSuite Execution

{% tabs faq-TestSuite-overview %}
{% tab faq-TestSuite-overview GdScript %}
```ruby
 (Run)
   |- func before() -> void: # Initialize the TestSuite
   |    ...
   |
   [...] # Loops over all tests
      |     
      |- func before_test() -> void: # Initialize next TestCase
      |    ...
      |
      >--- 
         | func test_1() -> void: # Execute TestCase (1-n iterations)
         |   ...
      <---
      |  
      |- func after_test() -> void: # Clean up current TestCase finished
      |     ...
   [...]
   |   
   |- func after() -> void: # Clean up TestSuite finished
   |      ....
 (End)
```
{% endtab %}
{% tab faq-TestSuite-overview C# %}
```cs
 (Run)
   |- [Before] // Initialize the TestSuite
   |  public void Setup() {}
   |
   [...] // Loops over all tests
      |     
      |- [BeforeTest] // Initialize next TestCase
      |  public void SetupTest() {}
      |
      >--- 
         | [TestCase] // Execute TestCase (1-n iterations)
         | public void TestCase1() {}
      <---
      |  
      |- [AfterTest] // Clean up current TestCase finished
      |  public void TearDownTest() {}
   [...]
   |   
   |- [After] // Clean up TestSuite finished
   |   public void TearDownSuite() {}
 (End)

```
{% endtab %}
{% endtabs %}

---
<h4> document version v4.1.0 </h4>