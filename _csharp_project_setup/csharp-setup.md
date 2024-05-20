---
layout: default
title: C# Setup
nav_order: 1
---


## GdUnit4 C# Test Setup

With gdUnit4 version 4.2.2, we fully support .net7, .net8 and LangVersion 11.<br>
This ensures compatibility and access to the enhanced features and capabilities provided by GdUnit4's C# testing functionality.

Before diving into gdUnit4 C# testing API, make sure your project is configured appropriately.<br>
Follow the steps outlined in the
[Official Godot documentary](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_basics.html#setting-up-c-for-godot)

GdUnit4 utilizes the C# language standard 11.0. To ensure seamless integration, adjust your project settings accordingly:<br>

1. Setup your Project

    gdUnit4Net C# API supports the frameworks **net7.0** and **net8.0** to support the latest language standard<br>
    Open you project file (\*.csproj), and change:
    * under section `<PropertyGroup>`
        * change the *TargetFramework* to `net8.0`
        * add `<LangVersion>11.0</LangVersion>`
        * add `<CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>`
    * add the section `<ItemGroup>` see below

    ```cs
      <ItemGroup>
        <PackageReference Include="gdUnit4.api" Version="4.2.*" />
      </ItemGroup>
    ```

2. Ensure the dotnet 8 SDK is installed.

```bash
dotnet --list-sdks
7.0.404 [C:\Program Files\dotnet\sdk]
8.0.201 [C:\Program Files\dotnet\sdk]
```

If no sdk 8.0 installed, you can download it [here](https://dotnet.microsoft.com/en-us/download/dotnet/8.0){:target="_blank"}<br>
If you encounter issues with older SDKs, consider uninstalling them.<br>
Here is a complete example of what your project should look like.

```cs
<Project Sdk="Godot.NET.Sdk/4.2.1">
  <PropertyGroup>
    <TargetFrameworks>net8.0</TargetFrameworks>
    <LangVersion>11.0</LangVersion>
    <!--Force nullable warnings, you can disable if you want-->
    <Nullable>enable</Nullable>
    <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
    <!--Disable warning of invalid/incompatible GodotSharp version-->
    <NoWarn>NU1605</NoWarn>
  </PropertyGroup>
  <ItemGroup>
    <!--Required for GdUnit4-->
    <PackageReference Include="gdUnit4.api" Version="4.2.*" />
  </ItemGroup>
</Project>
```

## The GdUnit4 Godot Editor C# Support

{% include advice.html
content="Please note that running C# tests is only supported with GdUnit4 version 4.2.x and higher.<br>
To be able to use the GdUnit4 C# Test API, at least one Godot-Mono version 4.2.x must be installed."
%}

GdUnit4 supports with [gdUnit4.api](https://github.com/MikeSchulze/gdUnit4Net/blob/master/api/README.md){:target="_blank"} v4.2.0 to write and run tests inside the Godot editor.
For support **Visual Studio**, **Visual Studio Code** and **JetBrains Rider** [click here](/gdUnit4/csharp_project_setup/vstest-adapter/){:target="_blank"}.

## Test You C# build Settings in the Godot Editor

Open the **MSBuild** inspector at the bottom of the Godot editor and press **Rebuild Solution**.
![](/gdUnit4/assets/images/install/cs-build-test.png)
The output should indicate that the project is built successfully.

### Running C# Tests inside the Godot Editor

How to [run test](/gdUnit4/testing/run-tests/)


## Using External C# Editor

Open your Godot editor settings, and navigate to **dotnet** and select your preferred C# tool.
![](/gdUnit4/assets/images/install/cs-setup.png)

---
<h4> document version v4.2.4 </h4>
