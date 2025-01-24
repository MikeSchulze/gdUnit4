extends GdUnitTestSuite

# example test discovery sink
class TestDiscoverSink extends GdUnitTestDiscoverSink:

	var _discovered_tests: Array[GdUnitTestCase]

	func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
		_discovered_tests.append(test_case)


func test_discover() -> void:
	# Create two example test cases
	var test_a := GdUnitTestCase.new()
	test_a.guid = GdUnitGUID.new()
	test_a.test_name = "test_a"
	var test_b := GdUnitTestCase.new()
	test_b.guid = GdUnitGUID.new()
	test_b.test_name = "test_a"

	# Create two discovery sinks
	var sink_a := TestDiscoverSink.new()
	var sink_b := TestDiscoverSink.new()
	sink_a.discover(test_a)
	sink_a.discover(test_b)
	sink_b.discover(test_b)

	# verify the discovery contains only the discovered tests
	assert_array(sink_a._discovered_tests).contains_exactly([test_a, test_b])
	assert_array(sink_b._discovered_tests).contains_exactly([test_b])
