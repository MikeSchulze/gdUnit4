---
layout: default
title: Setup/Installation
nav_order: 1
---

## GdUnit4 C# Test Setup

{% include advice.html
content="Please note that running C# tests is only supported with GdUnit4 version 5.0.0 and higher.<br>
To be able to use the GdUnit4Net C# Test API, at least one Godot-Mono version 4.3.x must be installed."
%}

### How GdUnit4 Integrates C# Test Support

GdUnit4 integrates C# testing capabilities through the [GdUnit4Net](https://github.com/MikeSchulze/gdUnit4Net){:target="_blank"} project.
This integration works by loading the necessary dependencies and utilizing the GdUnit4Net test engine to discover and execute C# tests directly
within the Godot editor environment.

The complete list of features and capabilities provided by the C# testing integration can be found on the
[GdUnit4Net GitHub page](https://github.com/MikeSchulze/gdUnit4Net){:target="_blank"}.

💡 **Recommended Approach:** For optimal C# testing experience, use dedicated IDEs like **JetBrains Rider**, **Visual Studio**,
or **Visual Studio Code** instead of the Godot editor.

⚠️ **Debugging Limitation:** Debugging C# tests inside the Godot editor is **not supported**. Use external IDEs for debugging capabilities.

### Framework Support

With gdUnit4Net version 5.0.0, we fully support .net8, .net9 and LangVersion 12.<br>
This ensures compatibility and access to the enhanced features and capabilities provided by GdUnit4Net's C# testing functionality.

Before diving into gdUnit4 C# testing API, make sure your project is configured appropriately.<br>
Follow the steps outlined in the
[Official Godot documentary](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_basics.html#setting-up-c-for-godot)

GdUnit4 utilizes the C# language standard 12.0. To ensure seamless integration, adjust your project settings accordingly:<br>

1. Setup your Project

   GdUnit4Net C# API supports the frameworks **net8.0** and **net9.0** to support the latest language standard<br>
   Open you project file (\*.csproj), and change:
    * under section `<PropertyGroup>`
        * change the *TargetFramework* to `net8.0` or `net9.0`
        * add `<LangVersion>12.0</LangVersion>`
        * add `<CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>`
    * add the section `<ItemGroup>` see below

    ```cs
      <ItemGroup>
        <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.14.1" />
        <PackageReference Include="gdUnit4.api" Version="5.0.0" />
        <PackageReference Include="gdUnit4.test.adapter" Version="3.0.0" />
        <PackageReference Include="gdUnit4.analyzers" Version="1.0.0">
          <PrivateAssets>none</PrivateAssets>
          <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
        </PackageReference>
      </ItemGroup>
    ```

   **Check for the latest available version on nuget.org**

   * [gdUnit4.analyzer](https://www.nuget.org/packages/gdUnit4.analyzers/#versions-body-tab){:target="_blank"}
   * [gdUnit4.api](https://www.nuget.org/packages/gdUnit4.api/#versions-body-tab){:target="_blank"}
   * [gdUnit4.test.adapter](https://www.nuget.org/packages/gdUnit4.test.adapter/#versions-body-tab){:target="_blank"}

2. Ensure the dotnet 8 or 9 SDK is installed.

   ```bash
   dotnet --list-sdks
   8.0.201 [C:\Program Files\dotnet\sdk]
   9.0.100 [C:\Program Files\dotnet\sdk]
   ```

   If no sdk 8.0 or 9.0 installed, you can [download it here](https://dotnet.microsoft.com/en-us/download/dotnet){:target="_blank"}<br>
   If you encounter issues with older SDKs, consider uninstalling them.<br>
   Here is a complete example of what your project should look like.

   ```cs
   <Project Sdk="Godot.NET.Sdk/4.4.1">
     <PropertyGroup>
       <TargetFrameworks>net8.0</TargetFrameworks>
       <LangVersion>12.0</LangVersion>
       <!--Force nullable warnings, you can disable if you want-->
       <Nullable>enable</Nullable>
       <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
       <!--Disable warning of invalid/incompatible GodotSharp version-->
       <NoWarn>NU1605</NoWarn>
     </PropertyGroup>
     <ItemGroup>
       <!--Required for GdUnit4Net-->
       <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.14.1" />
       <PackageReference Include="gdUnit4.api" Version="5.0.0" />
       <PackageReference Include="gdUnit4.test.adapter" Version="3.0.0" />
       <PackageReference Include="gdUnit4.analyzers" Version="1.0.0">
         <PrivateAssets>none</PrivateAssets>
         <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
       </PackageReference>
     </ItemGroup>
   </Project>
   ```

## The GdUnit4 Godot Editor C# Support

GdUnit4 supports with [GdUnit4Net](https://github.com/MikeSchulze/gdUnit4Net/blob/master/api/README.md){:target="_blank"}
v5.0.0 to write and run tests inside the Godot editor.
For support **Visual Studio**, **Visual Studio Code** and **JetBrains Rider** [check out here](/gdUnit4/csharp_project_setup/vstest-adapter/){:target="_blank"}.

## Test your C# build settings in the Godot Editor

Open the **MSBuild** inspector at the bottom of the Godot editor and press **Rebuild Solution**.
![cs-build-test](/gdUnit4/assets/images/install/cs-build-test.png)
The output should indicate that the project is built successfully.

### Running C# Tests inside the Godot Editor

How to [run test](/gdUnit4/testing/run-tests/)

## Using External C# Editor

Open your Godot editor settings, and navigate to **dotnet** and select your preferred C# tool.
![cs-setup](/gdUnit4/assets/images/install/cs-setup.png)

---
<h4> document version v5.0.0 </h4>
