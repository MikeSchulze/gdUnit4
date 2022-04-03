


# GdUnit3 - Embedded Godot Unit Test Framework
![Godot v3.2.3](https://img.shields.io/badge/Godot-v3.2.3-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.2.4](https://img.shields.io/badge/Godot-v3.2.4-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3](https://img.shields.io/badge/Godot-v3.3-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.1](https://img.shields.io/badge/Godot-v3.3.1-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.2](https://img.shields.io/badge/Godot-v3.3.2-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.3](https://img.shields.io/badge/Godot-v3.3.3-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.3.4](https://img.shields.io/badge/Godot-v3.3.4-%23478cbf?logo=godot-engine&logoColor=white)
![Godot v3.4](https://img.shields.io/badge/Godot-v3.4-%23478cbf?logo=godot-engine&logoColor=white)



***
## GdUnit3 V2.0.0 - Beta

 * You are welcome to test in and send me your feedback
 * You are welcome to suggest improvements
 * You are welcome to report bugs
***


GdUnit is a testing framework for Godot. GdUnit is important in the development of test-driven development and will help you to get your code bug free.

[[https://github.com/MikeSchulze/gdUnit3/wiki/images/GdUnit.png]]

## Main Features
* Fully integrated in the Godot editor
* Run test-suite(s) by using the context menu on FileSystem, ScriptEditor or GdUnitInspector
* Create test's directly from the ScriptEditor
* Configurable template for the creation of a new test-suite
* A spacious set of Asserts use to verify your code
* Argument matchers to verify the behavior of a function call by a specified argument type.
* Fluent syntax support
* Test Fuzzing support
* Mocking a class to simulate the implementation which you define the output of certain function
* Spy on a instance to verify that a function has been called with certain parameters.
* Mock or Spy on a Scene 
* Provides a scene runner to simulate interactions on a scene 
  * Simulate by Input events like mouse and/or keyboard
  * Simulate scene processing by a certain number of frames
  * Simulate scene proccessing by waiting for a specific signal
* Update Notifier to install latest version from GitHub
* Command Line Tool


## Example

<!DOCTYPE html>
<html lang="en-us">
    <head>
        ...
    </head>
    <body>
        {{ 
            {% tabs example %}

            {% tab example GdScript %}
            ``` python
            extends GdUnitTestSuite

            func test_example():
                assert_str("This is a example message").has_length(25).starts_with("This is a ex")
            ```
            {% endtab %}

            {% tab example CSharp %}
            ``` python
            [TestCase(Description = "Small example test")]
            public void Example() {
                AssertString("This is a example message").HasLength(25).StartsWith("This is a ex");
            }
            ```
            {% endtab %}

            {% endtabs %}
         }}
        <script src="/assets/js/tabs.js"></script>
    </body>
</html>



For more details see [Basic writing and formatting syntax](https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/MikeSchulze/gdUnit3/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
