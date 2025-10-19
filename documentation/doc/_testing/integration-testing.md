---
layout: default
title: Integration Tests
nav_order: 2
---

# Integration Tests

Integration testing is a critical process in game development that ensures different parts of your game work together seamlessly. Unlike unit testing,
which focuses on individual components, integration testing verifies the interaction between multiple components and systems within your scene.

## What is Integration Testing?

Integration testing involves testing the combination of different modules, scenes, or features of your game to ensure they work together as intended.
This type of testing helps identify issues that may not surface during unit testing, such as:

- **Interaction Bugs**: Conflicts between different input actions, such as keyboard shortcuts and mouse events.
- **Scene Transitions**: Ensuring smooth transitions between scenes or UI states.
- **Gameplay Logic**: Verifying that gameplay mechanics function correctly when various elements interact, such as player actions, enemy behavior,
and environment changes.

### Benefits of Integration Testing

- **Early Bug Detection**: Catch issues early in the development cycle by testing how different parts of your game interact.
- **Improved Stability**: Ensure that updates or changes to one part of your game don't unintentionally break other parts.
- **Automated Testing**: With tools like SceneRunner, you can automate complex interactions, making it easier to run tests regularly and consistently.

### Integration Tests: Using the SceneRunner to Test Your Scene

The **SceneRunner** tool in GdUnit4 is specifically designed to facilitate integration testing by simulating interactions and processing within your scene.

<figure class="video_container">
    <iframe width="560" height="315"
        src="https://www.youtube.com/embed/m6tYigD6Oe0?si=SgdLorwkoIGTJvNI"
        title="YouTube video player" frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen>
    </iframe>
</figure>

[Scene Runner]({{site.baseurl}}/advanced_testing/sceneRunner/#scene-runner): How to use the SceneRunner.
