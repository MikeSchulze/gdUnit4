---
layout: default
title: Scene Runner
parent: Tutorials
---

# Using Scene Runner
---

## ***Placeholder for upcoming Tutorial videos***
<figure class="video_container">
  <iframe src="https://www.youtube.com/embed/dy59OLSecrI" frameborder="0" allowfullscreen="true"> </iframe>
</figure>

## Example

{% tabs scene-runner-definition %}
{% tab scene-runner-definition GdScript %}
Use the scene runner with **scene_runner(\<scene\>)** in which you load the scene to be tested.
```ruby
    var runner := scene_runner("res://my_scene.tscn")
```
{% endtab %}
{% tab scene-runner-definition C# %}
Use the scene runner with **ISceneRunner.Load(\<scene\>)** in which you load the scene to be tested.
```cs
    ISceneRunner runner = ISceneRunner.Load("res://my_scene.tscn");
```
{% endtab %}
{% endtabs %}