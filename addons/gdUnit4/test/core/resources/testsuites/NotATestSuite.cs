namespace GdUnit3.Tests.Resources
{
    using static GdUnit3.Assertions;

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
