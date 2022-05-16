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
GdUnit3 uses the C# language standard 10.0 and therefore we need to adjust the project settings.<br>
1. Open your Godot Editor Settings and configure mono builds to use:
 * For GdUnit3 version 2.0.0+ you have to swtich to `MSBuild (VS Build Tools)`
 * With GdUnit3 version 2.2.0 we fully support .Net6 and LangVersion 10 you have to swtich to `dotnet CLI`

    ![](/gdUnit3/assets/images/install/cs-setup.png)
2. Setup the TargetFramework

    GdUnit3 C# API uses the framework *netstandard2.1* to support the latest language standard<br>
    Open you project file (\*.csproj), and change:
    * under section `<PropertyGroup>`
        * change the *TargetFramework* to `netstandard2.1`
        * add `<LangVersion>`
        * add `<CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>`
    * add the section `<ItemGroup>` see below


{% tabs settings-csharp %}
{% tab settings-csharp V2.0.0-V2.1.0 %}
```cs
    <Project Sdk="Godot.NET.Sdk/3.3.0">
    <PropertyGroup>
        <TargetFramework>netstandard2.1</TargetFramework>
        <LangVersion>8.0</LangVersion>
        <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
    </PropertyGroup>
    <ItemGroup>
        <!--Required for GdUnit3-->
        <PackageReference Include="Microsoft.CodeAnalysis.CSharp" Version="3.2.0" />
    </ItemGroup>
    </Project>
```
{% endtab %}
{% tab settings-csharp V2.2.0 %}
For C# 10 to work, you need the dotnet 6 SDK installed. 

```
dotnet --list-sdks
6.0.101 [C:\Program Files\dotnet\sdk]
```

If no sdk 6.0 installed you can download it [here](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)

If you run in trouble with older SDK's i suggest to uninstall it.
```cs
    <Project Sdk="Godot.NET.Sdk/3.3.0">
    <PropertyGroup>
        <TargetFrameworks>netstandard2.1</TargetFrameworks>
        <LangVersion>10.0</LangVersion>
        <!--Force nullable warnings, you can disable if you want-->
        <Nullable>enable</Nullable>
        <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
    </PropertyGroup>
    <ItemGroup>
        <!--Required for GdUnit3-->
        <PackageReference Include="Microsoft.CSharp" Version="4.7.0" />
        <PackageReference Include="Microsoft.CodeAnalysis.CSharp" Version="4.2.0" />
    </ItemGroup>
    </Project>
```
{% endtab %}
{% endtabs %}

3. Test C# build settings

    Open the `MSBuild` inspector on the bottom of the Godot editor and press `Build Solution`
    ![](/gdUnit3/assets/images/install/cs-build-test.png)
    The output should show the project is build successfully.

### Install Visual Studio GdUnit3 Extension
To run and debug C# sharp tests inside the VS-Code IDE you need to install the GdUnit3 [extension](https://code.visualstudio.com/docs/editor/extension-marketplace)
1. Click on the `Extensions` icon in the activity bar and search for `GdUnit3`

    ![](/gdUnit3/assets/images/install/extensions-install.png)

2. After successful installation you will find the GdUnit3 inspector in the activity bar.

    ![](/gdUnit3/assets/images/install/vsc-extension.png)

### GdUnit3 Extension Settings
You must first configure the GdUnit3 extension settings to set the path for Godot execution.

- Press the settings button on the inspector

    ![](/gdUnit3/assets/images/settings/vsc-extension-settings-button.png)
- Change the path to where you have installed Godot-Mono on your system

    ![](/gdUnit3/assets/images/settings/vsc-extension-settings-godot-path.png)

