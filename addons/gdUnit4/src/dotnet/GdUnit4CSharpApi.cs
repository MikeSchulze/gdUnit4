namespace gdUnit4.addons.gdUnit4.src.dotnet;

using System;
using System.Reflection;

using GdUnit4;

using Godot;
using Godot.Collections;

// GdUnit4 GDScript - C# API wrapper
// ReSharper disable once CheckNamespace
public partial class GdUnit4CSharpApi : GodotObject
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

    public static bool IsTestSuite(string classPath)
        => InvokeApiMethod<bool>("IsTestSuite", classPath);

    public static RefCounted Executor(Node listener)
        => InvokeApiMethod<RefCounted>("Executor", listener);

    public static CsNode? ParseTestSuite(string classPath)
        => InvokeApiMethod<CsNode?>("ParseTestSuite", classPath);

    public static Dictionary CreateTestSuite(string sourcePath, int lineNumber, string testSuitePath)
        => InvokeApiMethod<Dictionary>("CreateTestSuite", sourcePath, lineNumber, testSuitePath);
}
