---
layout: default
title: Test Suite
nav_order: 1
---

# Test-Suite

### Definition
A test-suite is a collection of tests basically alligned to a class you want to test.
When writing tests, it is common to find that several tests need similar test data to created before and cleanup after test run.
GdUnit test-suite runs in execution steps (hooks) where you allow to define preinitalisized test data.

|Execution Step|Description|
|---| ---|
|before | executed only once at test suite run is started|
|after | executed only once at test suite run has finished|
|before_test | executed before each test is started|
|after_test | executed after each test has finished|
|test | executes the test content|

---

## Execution Graph for a test-suite

{% tabs faq-test-suite-overview %}
{% tab faq-test-suite-overview GdScript %}
```ruby
 (Run)
   |- func before() -> void: # init the test-suite
   |    ...
   |
   [...] # loops over all tests
      |     
      |- func before_test() -> void: # init next test-case
      |    ...
      |
      >--- 
         | func test_1() -> void: # execute test-case (1-n iterations)
         |   ...
      <---
      |  
      |- func after_test() -> void: # clean-up current test-case finished
      |     ...
   [...]
   |   
   | - func after() -> void: # clean-up test-suite finished
   |      ....
 (END)
```
{% endtab %}
{% tab faq-test-suite-overview C# %}
```cs
 (Run)
   |- [Before] // init the test-suite
   |  public void Setup() {}
   |
   [...] // loops over all tests
      |     
      |- [BeforeTest] // init next test-case
      |  public void SetupTest() {}
      |
      >--- 
         | [TestCase] // execute test-case (1-n iterations)
         | public void TestCase1() {}
      <---
      |  
      |- [AfterTest] // clean-up current test-case finished
      |  public void TearDownTest() {}
   [...]
   |   
   | - [After] // clean-up test-suite finished
   |   public void TearDownSuite() {}
 (END)
```
{% endtab %}
{% endtabs %}


### Using step *before*

{% tabs faq-test-suite-before %}
{% tab faq-test-suite-before GdScript %}
You can override the **before()** function in your test-suite to define a pre hook and prepare your test data. This function is called only once at the beginning of a test-suite execution.
```ruby
   var _test_data :Node

   func before():
      _test_data = Node.new()
      # create some test data here
      ...
```
{% endtab %}
{% tab faq-test-suite-before C# %}
You can annotate with **[Before]** in your test-suite to define a pre hook and prepare your test data. This method is called only once at the beginning of a test-suite execution.
```cs
   private Godot.Node _test_data;

   [Before]
   public void Setup() {
      _test_data = new Godot.Node()
      // create some test data here
      ...
   }
```
{% endtab %}
{% endtabs %}

When you create objects in the **before** step than you have to manage the object to free at the end of a test-suite execution at step **after**.
Alternativly you can use **auto_free()** to create object where will be automatically freed after test-suite execution. 

### Using step *after*

{% tabs faq-test-suite-after %}
{% tab faq-test-suite-after GdScript %}
You can overwrite the **after()** function in your test-suite  to define a shutdown hook and release pre-initialized test data. This function is called only once at the end of a test-suite execution.

```ruby
   var _test_data :Node

   func after():
      # give free resources where was created in before()
   _test_data.free()
```
{% endtab %}
{% tab faq-test-suite-after C# %}
You can annotate a method with **[After]** in your test-suite to define a shutdown hook and release pre-initialized test data. This function is called only once at the end of a test-suite execution.

```cs
   private Godot.Node _test_data

   [After]
   public void TearDownSuite() {
      // give free resources where was created in before()
      _test_data.Free();
   }
```
{% endtab %}
{% endtabs %}




### Using step *before_test*

{% tabs faq-test-suite-before_test %}
{% tab faq-test-suite-before_test GdScript %}
You can override the function **before_test()** to define a test pre hook to pre-initialized test data for each test. This function is called before each test execution.
```ruby
   var _test_data :Node

   func before_test():
      _test_data = Node.new()
      # initalizize you test data here
      ...
```
{% endtab %}
{% tab faq-test-suite-before_test C# %}
You can annotate a method with **[BeforeTest]** to define a test pre hook to pre-initialized test data for each test. This methos is called before each test execution.
```cs
   private Godot.Node _test_data

   [BeforeTest]
   public void SetupTest() {
      _test_data = new Godot.Node()
      // initalizize you test data here
      ...
   }
```
{% endtab %}
{% endtabs %}


### Using step *after_test*
{% tabs faq-test-suite-after_test %}
{% tab faq-test-suite-after_test GdScript %}
You can override the function **after_test()** to define a shutdown hook if you neeed to clean-up test data for each test. This function is called after each test execution.
   ```ruby

   func after_test():
      # clean up your test data
      ...
```
{% endtab %}
{% tab faq-test-suite-after_test C# %}
You can annotate a method with **[AfterTest]** to define a shutdown hook if you neeed to clean-up test data for each test. This function is called after each test execution.
   ```ruby

   [AfterTest]
   public void TearDownTest() {
      # clean up your test data
      ...
   }
```
{% endtab %}
{% endtabs %}