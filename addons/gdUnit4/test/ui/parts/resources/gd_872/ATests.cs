using GdUnit4;

namespace Minimal.Tests
{
    [TestSuite]
    public class ATests
    {
        [TestCase]
        public void TestExample()
        {
            Assertions.AssertBool(true).IsTrue();
        }

        [TestCase]
        public void TestExample2()
        {
            Assertions.AssertBool(false).IsFalse();
        }
    }
}
