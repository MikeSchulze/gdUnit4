---
layout: default
title: C# Support
nav_order: 4
---

{% include advice.html
content="C# is currently <b>not</b> supported with version v4.1.0 and will be reimplemented with version v4.2.0.<br> This page will be updated with the next major release."
%}


# GdUnit and C# Testing
To use the GdUnit C# testing API, you need to have Godot-Mono version 4.0.x installed.


## How to enable the C# test support?
Before using the GdUnit C# test API we need to configure the project.
[Official Godot documentary](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_basics.html#setting-up-c-for-godot)

## Enable the GdUnit C# Support
GdUnit4 uses the C# language standard 10.0 and therefore we need to adjust the project settings.<br>
1. Open your Godot Editor Settings and configure mono builds to use:
 * With GdUnit4 version 2.3.0 we fully support .Net6 and LangVersion 10 you have to swtich to `dotnet CLI`

    ![](/gdUnit4/assets/images/install/cs-setup.png)
2. Setup your Project

    GdUnit4 C# API uses the framework *netstandard2.1* to support the latest language standard<br>
    Open you project file (\*.csproj), and change:
    * under section `<PropertyGroup>`
        * change the *TargetFramework* to `netstandard2.1`
        * add `<LangVersion>10.0</LangVersion>`
        * add `<CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>`
    * add the section `<ItemGroup>` see below
        * add `<PackageReference Include="gdUnit3Mono" Version="2.3.1-release*"/>`

3. For C# 10 to work, you need the dotnet 6 SDK installed. 

```
dotnet --list-sdks
6.0.101 [C:\Program Files\dotnet\sdk]
```

If no sdk 6.0 installed you can download it [here](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)

If you run in trouble with older SDK's i suggest to uninstall it.

Here is a complete example of what your project should look like.
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
		<!--Required for GdUnit4 C#-->
		<PackageReference Include="gdUnit3Mono" Version="2.3.1-release*"/>
	</ItemGroup>
</Project>
```

## Test you C# build settings

    Open the `MSBuild` inspector on the bottom of the Godot editor and press `Build Solution`
    ![](/gdUnit4/assets/images/install/cs-build-test.png)
    The output should show the project is build successfully.


## Install Visual Studio GdUnit4 Extension
To run and debug C# sharp tests inside the VS-Code IDE you need to install the GdUnit4 [extension](https://code.visualstudio.com/docs/editor/extension-marketplace)
1. Click on the `Extensions` icon in the activity bar and search for `GdUnit4`

    ![](/gdUnit4/assets/images/install/extensions-install.png)

2. After successful installation you will find the GdUnit4 inspector in the activity bar.

    ![](/gdUnit4/assets/images/install/vsc-extension.png)

## GdUnit4 Extension Settings
You must first configure the GdUnit4 extension settings to set the path for Godot execution.

- Press the settings button on the inspector

    ![](/gdUnit4/assets/images/settings/vsc-extension-settings-button.png)
- Change the path to where you have installed Godot-Mono on your system

    ![](/gdUnit4/assets/images/settings/vsc-extension-settings-godot-path.png)


## Using GdUnit4 on VisualStudio-Code
GdUnit provides an VS-Code extension like the GdUnit-Inspector for the Godot editor.

The extension allows you to create run and debug C# sharp test direct inside the VS-Code IDE.
<figure class="video_container">
  <iframe src="https://www.youtube.com/embed/qD-1BQuWwLs" frameborder="0" allowfullscreen="true"> </iframe>
</figure> 
