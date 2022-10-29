# this test suite ends with success, no failures or errors
extends GdUnitTestSuite

func before():
	assert_str("suite before").is_equal("suite before")

func after():
	assert_str("suite after").is_equal("suite after")

func before_test():
	assert_str("test before").is_equal("test before")

func after_test():
	assert_str("test after").is_equal("test after")

func test_case1():
	assert_str("test_case1").is_equal("test_case1")

func test_case2():
	assert_str("test_case2").is_equal("test_case2")
