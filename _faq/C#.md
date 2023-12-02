---
layout: default
title: C# Support
nav_order: 6
---



# C# Testing Support
{% include advice.html 
content="Please note that running C# tests is only supported with GdUnit4 version 4.2.x and higher."
%}
![](/gdUnit4/assets/images/install/cs-test-run.png)
To leverage the GdUnit C# testing API, it's essential to have Godot-Mono version 4.2.x installed.<br>
With GdUnit4 version 2.4.0, we fully support .Net7 and LangVersion 11.
This ensures compatibility and access to the enhanced features and capabilities provided by GdUnit4's C# testing functionality.


## How to Enable C# Test Support?
Before diving into GdUnit's C# testing API, make sure your project is configured appropriately.<br>
Follow the steps outlined in the
[Official Godot documentary](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_basics.html#setting-up-c-for-godot)

GdUnit4 utilizes the C# language standard 11.0. To ensure seamless integration, adjust your project settings accordingly:<br>

1. Setup your Project

    GdUnit4 C# API uses the framework **net7.0** to support the latest language standard<br>
    Open you project file (\*.csproj), and change:
    * under section `<PropertyGroup>`
        * change the *TargetFramework* to `net7.0`
        * add `<LangVersion>11.0</LangVersion>`
        * add `<CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>`
    * add the section `<ItemGroup>` see below
        * add `<PackageReference Include="gdUnit4.api" Version="4.2.0-rc*" />`

2. Ensure the dotnet 7 SDK is installed.

```
dotnet --list-sdks
6.0.101 [C:\Program Files\dotnet\sdk]
7.0.302 [C:\Program Files\dotnet\sdk]
```

If no sdk 7.0 installed, you can download it [here](https://dotnet.microsoft.com/en-us/download/dotnet/7.0)<br>
If you encounter issues with older SDKs, consider uninstalling them.<br>
Here is a complete example of what your project should look like.
```cs
<Project Sdk="Godot.NET.Sdk/4.2.0">
  <PropertyGroup>
    <TargetFrameworks>net7.0</TargetFrameworks>
    <LangVersion>11.0</LangVersion>
    <!--Force nullable warnings, you can disable if you want-->
    <Nullable>enable</Nullable>
    <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
    <!--Disable warning of invalid/incompatible GodotSharp version-->
    <NoWarn>NU1605</NoWarn>
  </PropertyGroup>
  <ItemGroup>
    <!--Required for GdUnit4-->
    <PackageReference Include="gdUnit4.api" Version="4.2.0-rc*" />
  </ItemGroup>
</Project>
```

## Test You C# build Settings
Open the **MSBuild** inspector at the bottom of the Godot editor and press **Rebuild Solution**.
![](/gdUnit4/assets/images/install/cs-build-test.png)
The output should indicate that the project is built successfully.

## Running C# Tests inside Godot
How to [run test](/gdUnit4/faq/run-tests/)

## Using External C# Editor
Open your Godot editor settings, and navigate to **dotnet** and select your preferred C# tool.
![](/gdUnit4/assets/images/install/cs-setup.png)

## Running C# Tests by Visual Studio Test Adapter
{% include advice.html 
content="The VS Test Adapter is currently in a pre-alpha version and has not been released yet."
%}
![](/gdUnit4/assets/images/install/cs-test-adapter.png)


---
<h4> document version v4.2.0 </h4>
