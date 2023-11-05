namespace GdUnit4
{
	using static Assertions;

	[TestSuite]
	public partial class GdUnit4MonoApiTest
	{
	
		[TestCase]
		public void IsTestSuite()
		{
			AssertThat(GdUnit4MonoAPI.IsTestSuite("res://addons/gdUnit4/src/mono/GdUnit4MonoApi.cs")).IsFalse();
			AssertThat(GdUnit4MonoAPI.IsTestSuite("res://addons/gdUnit4/test/mono/ExampleTestSuite.cs")).IsTrue();
		}

		[TestCase]
		public void GetVersion()
		{
			GdUnit4MonoApi api = new GdUnit4MonoApi();
			AssertThat(api.Version()).IsEqual("4.2.0.0");
		}
	}
}
