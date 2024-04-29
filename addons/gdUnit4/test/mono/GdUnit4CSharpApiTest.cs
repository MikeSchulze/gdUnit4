namespace GdUnit4
{
	using static Assertions;

	[TestSuite]
	public partial class GdUnit4CSharpApiTest
	{

		[TestCase]
		public void IsTestSuite()
		{
			AssertThat(GdUnit4CSharpApi.IsTestSuite("res://addons/gdUnit4/src/mono/GdUnit4CSharpApi.cs")).IsFalse();
			AssertThat(GdUnit4CSharpApi.IsTestSuite("res://addons/gdUnit4/test/mono/ExampleTestSuite.cs")).IsTrue();
		}

		[TestCase]
		public void GetVersion()
		{
			var version = long.Parse(GdUnit4CSharpApi.Version().Replace(".", ""));
			AssertThat(version).IsGreaterEqual(423);
		}
	}
}
