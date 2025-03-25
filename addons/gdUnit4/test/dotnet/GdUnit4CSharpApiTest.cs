namespace gdUnit4.addons.gdUnit4.test.dotnet;

using System.IO;
using System.Linq;

using GdUnit4;

using Godot;
using Godot.Collections;

using src.dotnet;

using static GdUnit4.Assertions;

[TestSuite]
[RequireGodotRuntime]
public class GdUnit4CSharpApiTest
{
    [TestCase]
    public void IsTestSuite()
    {
        AssertThat(GdUnit4CSharpApi.IsTestSuite(GD.Load<CSharpScript>("res://addons/gdUnit4/src/dotnet/GdUnit4CSharpApi.cs"))).IsFalse();
        AssertThat(GdUnit4CSharpApi.IsTestSuite(GD.Load<CSharpScript>("res://addons/gdUnit4/test/dotnet/ExampleTestSuite.cs"))).IsTrue();
        AssertThat(GdUnit4CSharpApi.IsTestSuite(GD.Load<CSharpScript>("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.cs"))).IsTrue();
    }

    [TestCase]
    public void GetVersion()
    {
        var version = long.Parse(GdUnit4CSharpApi.Version().Replace(".", ""));
        AssertThat(version).IsGreaterEqual(423);
    }

    [TestCase]
    public void DiscoverTestsFromScript()
    {
        var script = GD.Load<CSharpScript>("res://addons/gdUnit4/test/dotnet/ExampleTestSuite.cs");
        var fullScriptPath = Path.GetFullPath(ProjectSettings.GlobalizePath(script.ResourcePath));
        var tests = GdUnit4CSharpApi.DiscoverTests(script);

        // Filter out the Guid from each test dictionary before comparing
        var testsWithoutGuids = tests.Select(dict =>
        {
            var newDict = new Dictionary();
            newDict.Merge(dict);
            newDict.Remove("Guid");
            return newDict;
        }).ToArray();

        AssertThat(testsWithoutGuids).HasSize(14)
            // Check for single test `IsFoo`
            .Contains(new Dictionary
                {
                    ["test_name"] = "IsFoo",
                    ["source_file"] = "res://addons/gdUnit4/test/dotnet/ExampleTestSuite.cs",
                    ["line_number"] = 16,
                    ["attribute_index"] = 0,
                    ["require_godot_runtime"] = true,
                    ["code_file_path"] = fullScriptPath,
                    ["fully_qualified_name"] = "gdUnit4.addons.gdUnit4.test.dotnet.ExampleTestSuite.IsFoo",
                    ["simple_name"] = "IsFoo",
                    ["managed_type"] = "gdUnit4.addons.gdUnit4.test.dotnet.ExampleTestSuite"
                },
                // Check exemplary two of the `ParameterizedTest` (index 0, index 11)
                new Dictionary
                {
                    ["test_name"] = "ParameterizedTest",
                    ["source_file"] = "res://addons/gdUnit4/test/dotnet/ExampleTestSuite.cs",
                    ["line_number"] = 32,
                    ["attribute_index"] = 0,
                    ["require_godot_runtime"] = true,
                    ["code_file_path"] = fullScriptPath,
                    ["fully_qualified_name"] = "gdUnit4.addons.gdUnit4.test.dotnet.ExampleTestSuite.ParameterizedTest.ParameterizedTest:0 (A, 2)",
                    ["simple_name"] = "ParameterizedTest:0 (A, 2)",
                    ["managed_type"] = "gdUnit4.addons.gdUnit4.test.dotnet.ExampleTestSuite"
                },
                new Dictionary
                {
                    ["test_name"] = "ParameterizedTest",
                    ["source_file"] = "res://addons/gdUnit4/test/dotnet/ExampleTestSuite.cs",
                    ["line_number"] = 32,
                    ["attribute_index"] = 11,
                    ["require_godot_runtime"] = true,
                    ["code_file_path"] = fullScriptPath,
                    ["fully_qualified_name"] = "gdUnit4.addons.gdUnit4.test.dotnet.ExampleTestSuite.ParameterizedTest.ParameterizedTest:11 (\"HalloWorld\", 4)",
                    ["simple_name"] = "ParameterizedTest:11 (\"HalloWorld\", 4)",
                    ["managed_type"] = "gdUnit4.addons.gdUnit4.test.dotnet.ExampleTestSuite"
                });
    }
}
