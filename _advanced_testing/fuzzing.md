---
layout: default
title: Fuzzing
parent: Advanced Testing
nav_order: 4
---

# Testing with Fuzzers

## ***Fuzzing is current only supported for GdScripts!***

### Definition
Fuzz Testing or Fuzzing is a software testing technique of putting invalid or random data called FUZZ into software system to discover coding errors and security loopholes. The purpose of fuzz testing is inserting data using automated or semi-automated techniques and testing the system for various exceptions like system crashing or failure of built-in code, etc.

{% tabs fuzzing-definition %}
{% tab fuzzing-definition GdScript %}
```ruby
    func test_my_test(fuzzer := <Fuzzer>, <fuzzer_iterations>, <fuzzer_seed>):
```
{% endtab %}
{% tab fuzzing-definition C# %}
```cs
```
{% endtab %}
{% endtabs %}

---

### Using Fuzzers
To use a fuzzer you only need to extend you test by the argument 'fuzzer = <Fuzzer>'. 

{% tabs fuzzing-using %}
{% tab fuzzing-using GdScript %}
The fuzzer argument *name must always start with a prefix `fuzzer`*, allowed pattern is <fuzzer>['_', 'a-z', 'A_Z', '0-9'].

```ruby
    func test_name(fuzzer := <Fuzzer>, <fuzzer_iterations>, <fuzzer_seed>):
```
{% endtab %}
{% tab fuzzing-using C# %}

```cs
    ..
```
{% endtab %}
{% endtabs %}

If your test is configured with an fuzzer argument it will be now iterate multiple times with an new value given by the fuzzer implementation.

The default iteration is set to 1000 and can by configured by the optional argument 'fuzzer_iterations'.
If you want to have the same fuzzer results you can configure a seed by the optional argument 'fuzzer_seed'

```ruby
    func test_name(fuzzer := <Fuzzer>, <fuzzer_iterations>, <fuzzer_seed>):
```
Here an example to use a fuzzer where produces random values in a range from -23 to 22 and iterates 100 times
```ruby
    func test_fuzzer_inject_value(fuzzer := Fuzzers.random_rangei(-23, 22), fuzzer_iterations = 100):
        assert_int(fuzzer.next_value()).is_in_range(-23, 22)
```

### *multiple fuzzers are allowed*
```ruby
    func test_fuzzer_inject_value(fuzzer_a := Fuzzers.random_rangei(-23, 22), fuzzer_b := Fuzzers.random_rangei(0, 42), fuzzer_iterations = 100):
        assert_int(fuzzer_a.next_value()).is_in_range(-23, 22)
        assert_int(fuzzer_b.next_value()).is_in_range(-23, 22)
```


### Configure Fuzzer Iterations
If you want to iterate more than the default of 1000 iterations you can do this by set the amount of iteration by the 'fuzzer_iterations' argument.

```ruby
    # execute this test 5000 times
    func test_fuzzer_inject_value(fuzzer := Fuzzers.random_rangei(-100000, 100000), fuzzer_iterations=5000):
```



### Setting Fuzzer Seed
If you want to have always the same test results for a random generating fuzzer you can specifiy a seed by the 'fuzzer_seed' argument.

```ruby
    # execute this test with a seed value of 123456
    func test_fuzzer_inject_value(fuzzer := Fuzzers.random_rangei(-100000, 100000), fuzzer_seed=123456):
```


### Fuzzers
For now GdUnit provides only this very small set of Fuzzer implementations and will be extend later!

|Fuzzer|Description|
|rangei(from, to) | Generates an random integer in a range form to |
|eveni(from, to) | Generates an integer in a range form to that can be divided exactly by 2|
|oddi(from, to) | Generates an integer in a range form to that cannot be divided exactly by 2 |
|rangev2(from, to) | Generates an random Vector2 in a range form to  |
|rangev3(from, to) | Generates an random Vector3 in a range form to  |
|rand_str(min_length, max_length, charset)| Generates an random string value by a given min_length and max_length and specified charset |



### Create Custom Fuzzer
If you need a custom fuzzer you do this by extend from class 'Fuzzer' and implement the function 'next_value'

```ruby
    # Base interface for fuzz testing
    # https://en.wikipedia.org/wiki/Fuzzing
    class_name Fuzzer
    extends Resource

        # generates the next fuzz value
        # needs to be implement 
        func next_value():
            push_error("Invalid vall. Fuzzer not implemented 'next_value()'")
            return null
```

Here a small example custom fuzzer implementation

```ruby
    # a simple test fuzzer where provided a hard coded value set
    class TestFuzzer extends Fuzzer:
        var _data := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

        func next_value():
            return _data[randi_range(0, _data.size())]
```
