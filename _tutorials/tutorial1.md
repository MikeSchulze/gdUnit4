---
layout: default
title: Tuturial 1
---


<figure class="video_container">
  <iframe src="https://www.youtube.com/embed/dy59OLSecrI" frameborder="0" allowfullscreen="true"> </iframe>
</figure>

## Example
{: .d-none .d-md-inline-block }

{% tabs tuturial1 %}

{% tab tuturial1 GdScript %}
``` python
extends GdUnitTestSuite

func test_example():
	assert_str("This is a example message").has_length(25).starts_with("This is a ex")
```
{% endtab %}

{% tab tuturial1 c# %}
```javascript
[TestCase]
public Example2()
	AssertString("This is a example message").HasLength(25).StartsWith("This is a ex");

```
{% endtab %}
{% endtabs %}