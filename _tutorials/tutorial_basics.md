---
layout: default
title: Basics
parent: Tutorials
---

# Basics
---

## ***Placeholder for upcoming Tutorial videos***
<figure class="video_container">
  <iframe src="https://www.youtube.com/embed/dy59OLSecrI" frameborder="0" allowfullscreen="true"> </iframe>
</figure>

## Example

{% tabs tuturial-basics %}
{% tab tuturial-basics GdScript %}
```ruby
	extends GdUnitTestSuite

	func test_example():
		assert_str("This is a example message").has_length(25).starts_with("This is a ex")
```
{% endtab %}
{% tab tuturial-basics c# %}
```cs
	[TestCase]
	public Example2()
		AssertString("This is a example message").HasLength(25).StartsWith("This is a ex");

```
{% endtab %}
{% endtabs %}