---
layout: default
title: Installation
nav_order: 1
---

# Installation

You have to install the GdUnit3 plugin over the AssetLib in the Godot Editor.
![](/gdUnit3/assets/images/install/activate-gdunit-step0.png)

1. Select the tab AssetLib on the top
2. Enter GdUnit3 in the search bar
3. Select GdUnit3 and press the install button

### Activate the plugin

![](/gdUnit3/assets/images/install/activate-gdunit-step1.png)
1. Open your project settings by Project->Project Settings, click the Plugins tab and activate GdUnit.
2. After activation the GdUnit3 inspector is displayed in the top left
3. Done, GdUnit is ready to use

### GdUnit3 Inspector
After successful installation and activation you will find the GdUnit3 inspector on the left side.
![](/gdUnit3/assets/images/install/activate-gdunit-step2.png)


---
## GdUnit3 and C#
Before using the GdUnit C# test API we need to configure the project.
[Official Godot documentary](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_basics.html#setting-up-c-for-godot)

### Enable the C# Support
GdUnit3 uses the C# language standard 8.0 and therefore we need to adjust the project settings.<br>
1. Open your Godot Editor Settings and configure mono to use `MSBuild (VS Build Tools)`

    ![](/gdUnit3/assets/images/install/cs-setup.png)
2. Setup the TargetFramework

    GdUnit3 C# API uses the framework *netstandard2.1* to support the language standard 8.0.<br>
    Open you project file (\*.csproj), under section `<PropertyGroup>` change the *TargetFramework* to `netstandard2.1` and add the property `<LangVersion>8.0</LangVersion>`
```cs
    <Project Sdk="Godot.NET.Sdk/3.3.0">
    <PropertyGroup>
        ..

        <TargetFramework>netstandard2.1</TargetFramework>
        <LangVersion>8.0</LangVersion>

        ..
    </PropertyGroup>
    </Project>
```
3. Test C# build settings

    Open the `MSBuild` inspector on the bottom of the Godot editor and press `Build Solution`
    ![](/gdUnit3/assets/images/install/cs-build-test.png)
    The output should show the project is build successfully.

### Install Visual Studio GdUnit3 Extension
To run and debug C# sharp tests inside the VS-Code IDE you need to install the GdUnit3 [extension](https://code.visualstudio.com/docs/editor/extension-marketplace)
1. Click on the `Extensions` icon in the activity bar and search for `GdUnit3`

    ![](/gdUnit3/assets/images/install/extensions-view-icon.png)

2. After successful installation you will find the GdUnit3 inspector in the activity bar.

    ![](/gdUnit3/assets/images/install/vsc-extension.png)

### GdUnit3 Extension Settings
You must first configure the GdUnit3 extension settings to set the path for Godot execution.

- Press the settings button on the inspector

    ![](/gdUnit3/assets/images/settings/vsc-extension-settings-button.png)
- Change the path to where you have installed Godot-Mono on your system

    ![](/gdUnit3/assets/images/settings/vsc-extension-settings-godot-path.png)

