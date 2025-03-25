namespace gdUnit4.addons.gdUnit4.src.dotnet;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using GdUnit4.Core.Discovery;

using Godot;
using Godot.Collections;

// GdUnit4 GDScript - C# API wrapper
// ReSharper disable once CheckNamespace
public partial class GdUnit4CSharpApi : RefCounted
{
    private static Type? apiType;

    private static Type GetApiType()
    {
        if (apiType != null)
            return apiType;
        var assembly = Assembly.Load("gdUnit4Api");
        apiType = assembly.GetType("GdUnit4.GdUnit4NetAPI");
        GD.PrintS($"GdUnit4CSharpApi type:{apiType} loaded.");

        return apiType!;
    }

    private static Version GdUnit4NetVersion()
    {
        var assembly = Assembly.Load("gdUnit4Api");
        return assembly.GetName().Version!;
    }

    private static T InvokeApiMethod<T>(string methodName, params object[] args)
    {
        var method = GetApiType().GetMethod(methodName)!;
        return (T)method.Invoke(null, args)!;
    }

    public static bool FindGdUnit4NetAssembly()
    {
        try
        {
            var assembly = Assembly.Load("gdUnit4Api");
            return assembly.GetType("GdUnit4.GdUnit4NetAPI") != null;
        }
        catch (Exception)
        {
            return false;
        }
    }

    public static string Version()
        => GdUnit4NetVersion().ToString();

    public static bool IsTestSuite(CSharpScript script)
        => InvokeApiMethod<bool>("IsTestSuite", script);

    public static Array<Dictionary> DiscoverTests(CSharpScript sourceScript)
    {
        try
        {
            // Get the list of test case descriptors from the API
            var testCaseDescriptors = InvokeApiMethod<List<TestCaseDescriptor>>("DiscoverTestsFromScript", sourceScript);
            // Convert each TestCaseDescriptor to a Dictionary
            return testCaseDescriptors
                .Select(descriptor => new Dictionary
                {
                    ["Guid"] = descriptor.Id.ToString(),
                    ["managed_type"] = descriptor.ManagedType,
                    ["test_name"] = descriptor.ManagedMethod,
                    ["source_file"] = sourceScript.ResourcePath,
                    ["line_number"] = descriptor.LineNumber,
                    ["attribute_index"] = descriptor.AttributeIndex,
                    ["require_godot_runtime"] = descriptor.RequireRunningGodotEngine,
                    ["code_file_path"] = descriptor.CodeFilePath ?? "",
                    ["simple_name"] = descriptor.SimpleName,
                    ["fully_qualified_name"] = descriptor.FullyQualifiedName
                })
                .Aggregate(new Array<Dictionary>(), (array, dict) =>
                {
                    array.Add(dict);
                    return array;
                });
        }
        catch (Exception e)
        {
            GD.PrintErr($"Error discovering tests: {e.Message}\n{e.StackTrace}");
            return new Array<Dictionary>();
        }
    }

    public static Dictionary CreateTestSuite(string sourcePath, int lineNumber, string testSuitePath)
        => InvokeApiMethod<Dictionary>("CreateTestSuite", sourcePath, lineNumber, testSuitePath);
}
