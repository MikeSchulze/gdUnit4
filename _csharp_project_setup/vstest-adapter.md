---
layout: default
title: C# Configure Your IDE
nav_order: 2
---

# The gdUnit4 Test Adapter

The gdUnit4 Test Adapter, designed to facilitate the integration of GdUnit4 with test frameworks supporting the Visual Studio Test Platform [VSTest](https://github.com/microsoft/vstest?tab=readme-ov-file#vstest){:target="_blank"}.

The project repository can be found here [gdunit4.test.adapter](https://github.com/MikeSchulze/gdUnit4Net/tree/master/testadapter/README.md){:target="_blank"}.

## Supported IDE's

|IDE               |Test Discovery|Test Run|Test Debug|Jump to Failure|Solution test config file|Test Filter|Parallel Test Execution|
|---|---|---|---|---|---|
|Visual Studio     |✅|✅|✅|✅|✅|🔜|❌|
|Visual Studio Code|✅|✅|✅|✅|✅|🔜|❌|
|JetBrains Rider   |✅|✅|[☑️](#test-debug-workaround-for-jetbrains-rider)|✅|✅|🔜|❌|

> ✅ - supported<br>
> ☑️ - supported by a workaround (link)<br>
> ❌ - not supported<br>
> 🔜 - not yet implemented<br>

## Install

### Install Nuget Packages and Project References

Add the following framework reference to your csproj:

```cs
    <ItemGroup>
        <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.9.0" />
        <PackageReference Include="gdUnit4.api" Version="4.2.*" />
        <PackageReference Include="gdUnit4.test.adapter" Version="1.*" />
    </ItemGroup>
```

Check the for latest version on nuget.org:

* [gdUnit4.api](https://www.nuget.org/packages/gdUnit4.api/4.2.1.1#versions-body-tab){:target="_blank"}
* [gdUnit4.test.adapter](https://www.nuget.org/packages/gdUnit4.test.adapter/#versions-body-tab){:target="_blank"}

## IDE's

### Preconditions

You need to setup the system environment variable `GODOT_BIN`, the full path to the Godot executable.

  |Platform|Environment Variable|Example Path|
  |---|---|---|
  |Windows|**%GODOT_BIN%**|`d:\development\Godot_v4.2.1-stable_mono_win64\Godot_v4.2.1-stable_mono_win64.exe`|
  |Linux/Unix/Mac|**$GODOT_BIN**|`/Users/MisterX/Documents/develop/GodotMono.app/Contents/MacOS/Godot`|

  Or use the [.runsettings](#the-test-adapter-settings) to define the environment variable.

  ```xml
  <RunSettings>
    <RunConfiguration>
        <EnvironmentVariables>
            <GODOT_BIN>d:\development\Godot_v4.2.1-stable_mono_win64\Godot_v4.2.1-stable_mono_win64.exe</GODOT_BIN>
        </EnvironmentVariables>
    ...
  ```

---

### Visual Studio

![test-adapter](/gdUnit4/assets/images/faq/visualstudio/test-explorer.png)

**Do follow this steps to activate the test explorer:**

* Activate the test explorer
![explorer](/gdUnit4/assets/images/faq/visualstudio/setup-test-1.png)
* Configure the path to your `.runsettings`
![explorer](/gdUnit4/assets/images/faq/visualstudio/setup-test-2.png)
* Restart Visual Studio

---

### Visual Studio Code

![test-adapter](/gdUnit4/assets/images/faq/visualstudio-code/test-explorer.png)

**Do follow this steps to activate the test explorer:**

* Install the C# Dev Kit (v1.5.12 (pre-release) recommended). Detailed instructions can be found [here](https://code.visualstudio.com/docs/csharp/testing){:target="_blank"}.
![devkit](/gdUnit4/assets/images/faq/visualstudio-code/test-setup-1.png)
* Open your `.vscode/settings.json` and add the following property to your project settings:
    It is important to use the correct C# Dev Kit version, which is currently a PreRelease.
    The property is newly introduced by this [issue](https://github.com/microsoft/vscode-dotnettools/issues/156){:target="_blank"}.

    ```json
    "dotnet.unitTests.runSettingsPath": "./test/.runsettings"
    ```

* Restart Visual Studio Code

---

### JetBrains Rider

![enable vstest](/gdUnit4/assets/images/faq/jetbrains/test-explorer.png)

**Do follow this steps to activate the test explorer:**

* Install the Godot Support plugin
  ![godot-support](/gdUnit4/assets/images/faq/jetbrains/plugin-godot-support.png)
{% include advice.html
      content="Minimum Version of <b>2024.1.167</b> is required! <a href=\"https://plugins.jetbrains.com/plugin/13882-godot-support\">Checkout for the latest version</a>"
%}
* [Optional] Configure the path to your `.runsettings`
![runsettings](/gdUnit4/assets/images/faq/jetbrains/setup-test-1.png)
* Enable the [VSTest adapters](https://www.jetbrains.com/help/rider/Reference__Options__Tools__Unit_Testing__VSTest.html#projects-with-unit-tests){:target="_blank"} in the Rider settings
![enable vstest](/gdUnit4/assets/images/faq/jetbrains/setup-test-2.png)
* Restart JetBrains Rider

> **Note:** There is no need to set the `GODOT_BIN` for Rider.

---

### The Test Adapter Settings

To configure the test execution, you can use a **.runsettings** file. Below is an example:
The full guide to configure the settings can be found [here](https://learn.microsoft.com/en-us/visualstudio/test/configure-unit-tests-by-using-a-dot-runsettings-file?view=vs-2022){:target="_blank"}.

```xml
<?xml version="1.0" encoding="utf-8"?>
<RunSettings>
    <RunConfiguration>
        <MaxCpuCount>1</MaxCpuCount>
        <ResultsDirectory>./TestResults</ResultsDirectory>
        <TargetFrameworks>net7.0;net8.0</TargetFrameworks>
        <TestSessionTimeout>180000</TestSessionTimeout>
        <TreatNoTestsAsError>true</TreatNoTestsAsError>
        <EnvironmentVariables>
            <GODOT_BIN>d:\development\Godot_v4.2.1-stable_mono_win64\Godot_v4.2.1-stable_mono_win64.exe</GODOT_BIN>
        </EnvironmentVariables>
    </RunConfiguration>

    <LoggerRunSettings>
        <Loggers>
            <Logger friendlyName="console" enabled="True">
                <Configuration>
                    <Verbosity>detailed</Verbosity>
                </Configuration>
            </Logger>
            <Logger friendlyName="html" enabled="True">
                <Configuration>
                    <LogFileName>test-result.html</LogFileName>
                </Configuration>
            </Logger>
            <Logger friendlyName="trx" enabled="True">
                <Configuration>
                    <LogFileName>test-result.trx</LogFileName>
                </Configuration>
            </Logger>
        </Loggers>
    </LoggerRunSettings>

    <GdUnit4>
        <!-- Additional Godot runtime parameters-->
        <Parameters></Parameters>
        <!-- Controls the Display name attribute of the TestCase. Allowed values are SimpleName and FullyQualifiedName.
             This likely determines how the test names are displayed in the test results.-->
        <DisplayName>FullyQualifiedName</DisplayName>
    </GdUnit4>
</RunSettings>
```

### Issues and Workarounds

|Issue|Solution|
|-|-|
|The test discovery is aborted and not all tests are found|Increase the `<TestSessionTimeout>` in your [RunSettings](#the-test-adapter-settings)|
|Test Debug workaround for JetBrains Rider|[click here](#test-debug-workaround-for-jetbrains-rider)|

#### Test Debug workaround for JetBrains Rider

* Paste this code into your test suite to wait until the debugger is connected to the Godot process.

```cs
    [BeforeTest]
    public void DebugWorkaround()
    {
        while (!Debugger.IsAttached)
        {
        }
    }
```

* Set your breakpoints
* Start debugging test
* Attach the debugger to the running Godot instance.
![attach_debugger](/gdUnit4/assets/images/faq/jetbrains/attach-debug-process.png)
* Search for Godot and select and press attach
![select_process](/gdUnit4/assets/images/faq/jetbrains/select-process.png)

---
<h4> document version v4.2.5 </h4>
