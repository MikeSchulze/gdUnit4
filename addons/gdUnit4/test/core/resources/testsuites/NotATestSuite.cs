namespace GdUnit4.Tests.Resources
{
	using static Assertions;
	
	// will be ignored because of missing `[TestSuite]` anotation
	public partial class NotATestSuite
	{
		[TestCase]
		public void TestFoo()
		{
			AssertBool(true).IsEqual(false);
		}
	}
}
