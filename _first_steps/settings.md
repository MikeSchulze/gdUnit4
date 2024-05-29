---
layout: default
title: Settings
nav_order: 2
---

# Settings

GdUnit4 provides several customizable settings to meet your testing needs. To access these settings, simply press the 'tools' button located in the GdUnit inspector.
![](/gdUnit4/assets/images/settings/inspector-settings.png){:.centered}

---

## Common Settings

![](/gdUnit4/assets/images/settings/settings-common.png){:.centered}

* **Common**
  * **Server Connection Timeout**<br>
   The server connection timeout determines the maximum wait time in minutes for the test runner client when communication between the editor and runner is interrupted.

  * **Update Notification Enabled**<br>
   This option enables or disables the GdUnit update notification. If enabled, a notification will appear when starting Godot to inform you about new updates available for installation.

* **Test**
  * **Test Discovery**<br>
   This setting configures the auto-discovery of tests. If enabled, it will scan the configured Test Root Folder for available tests at startup.

  * **Test Root Folder**<br>
   This setting defines the root folder where automated tests will be generated. By default, tests are usually located parallel to the source code in a folder named 'test'. However, you can customize this location by specifying a different folder path.
   The default root folder is **test**.

      ```python
      res://project/src/folder_a/folder_b/my_class.gd
      res://project/test/folder_a/folder_b/my_class_test.gd
      ```

  * **Test Suite Naming Nonvention**<br>
      Configures how to generate the test-suite file name.

      1. *AUTO_DETECT* - generates the file name by source file naming convention.
      2. *SNAKE_CASE*  - generates the file name in snake case convention.
      3. *PASCAL_CASE* - generates the file name in pascal case convention.

  * **Test Timeout Seconds**<br>
      This setting configures the default timeout for a test case in seconds. If a test case runs longer than the specified timeout, the test will be interrupted and fail. You can override the default timeout on a per-test-case basis by specifying a different timeout using the `timeout` argument.

{% tabs settings-timeout %}
{% tab settings-timeout GdScript %}

```ruby
   # Configures the test case to fail after a maximum of 2 seconds runtime
   func test_foo(timeout = 2000) -> void:
   ...
```

{% endtab %}
{% tab settings-timeout C# %}

```cs
   // Configures the test case to fail after a maximum of 2 seconds runtime
   [TestCase(Timeout = 2000)]
   public async Task foo() {
   }
```

{% endtab %}
{% endtabs %}

---

## UI Settings

![](/gdUnit4/assets/images/settings/settings-ui.png){:.centered}

* **Inspector**
  * **Node Collapse**<br>
      By default, the testsuite node in the Inspector is collapsed after a successful test run. This option controls whether the testsuite node remains collapsed or expanded.
  * **Tree Sort Mode**<br>
      This setting controls the tree sorting by name in ascending or descending order, or by test execution time.
  * **Tree View Mode**<br>
      This setting controls whether the inspector tree is presented as a flat view or a tree view.

* **ToolBar**
  * **Run Overall**<br>
      This setting controls the visibility of the 'run overall' button in the inspector tool bar. By default, the button is hidden, but you can show or hide it as desired.

---

## Shortcuts Settings

![](/gdUnit4/assets/images/settings/settings-shortcuts.png){:.centered}

* **Editor**<br>
 This section allows you to customize the keyboard shortcuts for the script editor in Godot. You can customize the shortcuts for various actions such as create test, run test, and debug test.

* **Filesystem**<br>
In this section, you can customize the keyboard shortcuts for the filesystem inspector in Godot. You can customize shortcuts for various actions, such as running tests and debugging tests.

* **Inspector**<br>
 In this section, you can customize the keyboard shortcuts for the GdUnit inspector in Godot. You can customize shortcuts for various actions, such as running tests, debugging tests, running overall tests, and stopping the current test run.

---

## Report Settings

![](/gdUnit4/assets/images/settings/settings-report.png){:.centered}

* **Asserts**
  * **Strict Number Type Compare**<br>
   This setting controls how numbers are compared in GdUnit. By default, GdUnit performs a type-safe comparison and will always fail if you compare an integer with a floating-point number, even if they have the same value. To allow equal values, such as `0` and `0.0`, you can turn off this configuration.

  * **Verbose Errors**<br>
   This setting suppresses internal error reporting for failed assert conditions in GdUnit. When an assert condition fails, GdUnit normally generates an error message to indicate the failure. By enabling this setting, you can suppress these error messages, which can be useful in certain testing scenarios where error reporting is not necessary or desired.

  * **Verbose Warnings**<br>
   This setting suppresses internal warning reporting for failed assert conditions in GdUnit. When an assert condition fails, GdUnit normally generates a warning message to indicate the failure. By enabling this setting, you can suppress these warning messages, which can be useful in certain testing scenarios where warning reporting is not necessary or desired.

* **Godot**
  * **Push Error**<br>
   This setting reports Godot push_error() notifications in GdUnit and causes the test to fail (by default, this setting is disabled). When Godot encounters an error condition, it can generate a push_error() notification to indicate the error. By enabling this setting, you can capture these notifications in GdUnit and cause the associated test to fail. This can be useful in certain testing scenarios where error reporting is critical.

  * **Script Error**<br>
   This setting reports Godot gdscript errors in GdUnit and causes the associated test to fail. When Godot encounters an error in a gdscript file, such as a syntax error or a runtime error, GdUnit can capture the error and cause the associated test to fail. By enabling this setting, you can ensure that errors in gdscript files are detected and reported in your tests.

* **Common**
  * **Verbose Orphans**<br>
   This setting enables or disables orphan node reporting in GdUnit. When this setting is enabled, GdUnit will report any nodes in your project that are not referenced by any other nodes or resources. These orphan nodes can indicate unused or unnecessary content in your project, which can be helpful in optimizing your project. By disabling this setting, you can suppress the reporting of orphan nodes, which can be useful in certain testing scenarios where orphan node reporting is not necessary or desired.

---

## Templates Settings

When creating a new test-case in GdUnit, you can use this template to generate your test-suite. To do this, simply right-click on the desired function you want to test and select 'Create Test' from the context menu. This will generate a new test-case using the default template, which you can customize to suit your testing needs.

![](/gdUnit4/assets/images/settings/settings-template.png){:.centered}

To personalize your test-suite template in GdUnit, you can use the provided tags to modify it according to your needs.<br>
These tags allow you to add custom placeholders and data fields to your test-suite, making them more informative and easier to manage. To view a list of all the supported tags, simply click on the **Supported Tags** button in the template page.
![](/gdUnit4/assets/images/settings/settings-template-editor-tags.png){:.centered}

---
<h4> document version v4.3.0 </h4>
