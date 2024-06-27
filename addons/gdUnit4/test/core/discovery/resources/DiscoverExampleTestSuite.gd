extends GdUnitTestSuite


func test_case1() -> void:
	assert_bool(true).is_equal(true);


func test_case2() -> void:
	assert_bool(false).is_equal(false);
