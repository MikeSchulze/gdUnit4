---
layout: default
title: Settings
nav_order: 2
---

# Settings
To open the setting press the tools button on the GdUnit inspector.<br>
![](/gdUnit3/assets/images/settings/inspector-settings.png)

![](/gdUnit3/assets/images/settings/settings-dialog.png)

---

## Common Settings
### Common
![](/gdUnit3/assets/images/settings/settings-common.png)
#### **server connection timeout**
The server connection timeout specifies the maximum time in minutes that the test runner client waits when the communication between editor and runner is interrupted.

#### **update notification enabled**
Enables/disables the GdUnit update notification. When enabled, an update notification is displayed when Godot is started to inform about a new update to be installed.

### Test
![](/gdUnit3/assets/images/settings/settings-test.png)
#### **test root folder**
Defines the root folder where tests are generated.

The tests are usually located parallel to the source code under 'test'. You can leave it empty to create tests in the source folder.
```python
   res://project/src/folder_a/folder_b/my_class.gd
   res://project/test/folder_a/folder_b/my_class_test.gd
```

#### **test suite naming convention**
Configures how to generate the test-suite file name. 
1. *AUTO_DETECT* - generates the file name by source file naming convention.
2. *SNAKE_CASE*  - generates the file name in snake case convention.
3. *PASCAL_CASE* - generates the file name in pascal case convention.

#### **test timeout seconds**
Configures the default timeout for the test case in seconds. If a test case runs longer than the specified timeout, the test is interrupted and fails.
The default timeout can be overriden on test-case level by using the argument *timeout*.

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

### UI
![](/gdUnit3/assets/images/settings/settings-ui.png)
#### **inspector node collapse**
Controls whether the testsuite node in the Inspector is collapsed after a successful test run.
By default, the testsuite node is collapsed when all tests are successful.

---

## Report Settings
![](/gdUnit3/assets/images/settings/settings-report.png)


### Asserts 
![](/gdUnit3/assets/images/settings/settings-asserts.png)
#### **strict number type compare**
Controls how numbers are compared.<br>
By default GdUnit does a typesave comparison and will always fail if you compare **int** with **float** even if they are supposed to have the same value.<br>
To allow equal values e.g. 0 == 0.0 you can switch off this configuration.


#### **verbose errors**
Suppresses internal error reporting for failed assert conditions.

#### **verbose warnings**
Suppresses internal warning reporting for failed assert conditions.

### Godot
![](/gdUnit3/assets/images/settings/settings-godot.png)
#### **Push Error**
Reports Godot push_error() notifications and let the test fail (default disabled)

#### **Script Error**
Reports Godot gd script errors and let the test fail

### Common
![](/gdUnit3/assets/images/settings/settings-report-others.png)
#### **verbose orphans**
Enable/disable the orphan node reporting

---

## Templates
![](/gdUnit3/assets/images/settings/settings-template.png)

#### **test suite template**

This template is used to create your test-suite by using the context menu in the editor to create a new test-case.

You can modify and personalize the template using the tags provided.  

![](/gdUnit3/assets/images/settings/settings-template-editor.png)
All supported tags can be viewed by pressing the *Supported Tags* button.
![](/gdUnit3/assets/images/settings/settings-template-editor-tags.png)
