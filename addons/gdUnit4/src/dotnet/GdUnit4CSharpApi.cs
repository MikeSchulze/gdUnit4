using System;
using System.Reflection;
using GdUnit4;
using Godot;
using Godot.Collections;


// GdUnit4 GDScript - C# API wrapper
// ReSharper disable once CheckNamespace
public partial class GdUnit4CSharpApi : GodotObject
{
	private static Type? _apiType;

	private static Type GetApiType()
	{
		if (_apiType == null)
		{
			var assembly = Assembly.Load("gdUnit4Api");
			_apiType = assembly.GetType("GdUnit4.GdUnit4NetAPI");
			GD.PrintS($"GdUnit4CSharpApi type:{_apiType} loaded.");
		}

		return _apiType!;
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
		catch (Exception e)
		{
			return false;
		}
	}

	public static string Version()
	{
		return GdUnit4NetVersion().ToString();
	}

	public static bool IsTestSuite(string classPath)
	{
		return InvokeApiMethod<bool>("IsTestSuite", classPath);
	}

	public static RefCounted Executor(Node listener)
	{
		return InvokeApiMethod<RefCounted>("Executor", listener);
	}

	public static CsNode? ParseTestSuite(string classPath)
	{
		return InvokeApiMethod<CsNode?>("ParseTestSuite", classPath);
	}

	public static Dictionary CreateTestSuite(string sourcePath, int lineNumber, string testSuitePath)
	{
		return InvokeApiMethod<Dictionary>("CreateTestSuite", sourcePath, lineNumber, testSuitePath);
	}
}
