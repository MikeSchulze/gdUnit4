namespace gdUnit4.addons.gdUnit4.test.dotnet;

using GdUnit4;

using src.dotnet;

using static GdUnit4.Assertions;

[TestSuite]
[RequireGodotRuntime]
public class GdUnit4CSharpApiTest
{
    [TestCase]
    public void IsTestSuite()
    {
        AssertThat(GdUnit4CSharpApi.IsTestSuite("res://addons/gdUnit4/src/dotnet/GdUnit4CSharpApi.cs")).IsFalse();
        AssertThat(GdUnit4CSharpApi.IsTestSuite("res://addons/gdUnit4/test/dotnet/ExampleTestSuite.cs")).IsTrue();
    }

    [TestCase]
    public void GetVersion()
    {
        var version = long.Parse(GdUnit4CSharpApi.Version().Replace(".", ""));
        AssertThat(version).IsGreaterEqual(423);
    }
}
