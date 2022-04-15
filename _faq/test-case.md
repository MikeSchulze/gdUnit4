---
layout: default
title: Test Case
nav_order: 2
---

# Test-Case

### Definition

A test case document described detailed summary of what scenarios will be tested.
A test case must be start with the prefix **test_** for GdScripts and annotated with **[TestCase]** for C# tests.

Use a meaningfull name for your test to represent what the test does.


{% tabs faq-test-case-name %}
{% tab faq-test-case-name GdScript %}
We named it **test_*string_to_lower()*** because we test the `to_lower` function on a string.
Remeber we have to use the prefix **test_** to indendicate this function is a test case.

```ruby
   func test_string_to_lower() -> void:
      assert_str("AbcD".to_lower()).is_equal("abcd")
```
{% endtab %}
{% tab faq-test-case-name C# %}
We named it **StringToLower()** because we test the `ToLower` function on a string.
Remeber we have to use the annotation **[TestCase]** to indendicate this method is a test case.

```cs
   [TestCase]
   public void StringToLower() {
      AssertString("AbcD".ToLower()).IsEqual("abcd");
   }
```
{% endtab %}
{% endtabs %}

---

### How to fail fast (Only GdScript)
A test case can fail by one or more assertions. This means that a test is not aborted at the first failed assertion. GdScript does not have exceptions that allow this, so we have to manually deal with a failed assertion here. For this we can use the function **is_failure** to test for an failure and abort.

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

