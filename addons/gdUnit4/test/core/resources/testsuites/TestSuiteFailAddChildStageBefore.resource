# this test suite fails if (https://github.com/MikeSchulze/gdUnit4/issues/106) not fixed on iterating over testcases 
extends GdUnitTestSuite

func before():
	add_child(auto_free(Node.new()))

func test_case1():
	assert_str("test_case1").is_equal("test_case1")

func test_case2():
	assert_str("test_case2").is_equal("test_case2")
