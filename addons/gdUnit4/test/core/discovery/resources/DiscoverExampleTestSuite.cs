namespace GdUnit4.Tests.Resource
{
	using static Assertions;

	[TestSuite]
	public partial class ExampleTestSuite
	{

		[TestCase]
		public void TestCase1()
		{
			AssertBool(true).IsEqual(true);
		}

		[TestCase]
		public void TestCase2()
		{
			AssertBool(false).IsEqual(false);
		}
	}
}
