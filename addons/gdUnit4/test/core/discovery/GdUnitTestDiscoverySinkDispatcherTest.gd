# GdUnit generated TestSuite
class_name GdUnitTestDiscoverySinkDispatcherTest
extends GdUnitTestSuite

# example test discovery sink
class TestDiscoverSink extends GdUnitTestDiscoverSink:

	var _discovered_tests: Array[GdUnitTestCase]

	func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
		_discovered_tests.append(test_case)


func test_singleton() -> void:
	var dispatcher_a := GdUnitTestDiscoverySinkDispatcher.instance()
	var dispatcher_b := GdUnitTestDiscoverySinkDispatcher.instance()

	assert_object(dispatcher_a).is_same(dispatcher_b)


func test_register_discovery_sink() -> void:
	var dispatcher := GdUnitTestDiscoverySinkDispatcher.instance()
	var sink_a := TestDiscoverSink.new()
	var sink_b := TestDiscoverSink.new()

	dispatcher.register_discovery_sink(sink_a)
	dispatcher.register_discovery_sink(sink_b)

	assert_array(dispatcher._discover_sinks).contains_exactly([sink_a, sink_b])


func test_discover() -> void:
	var dispatcher := GdUnitTestDiscoverySinkDispatcher.instance()
	var sink_a := TestDiscoverSink.new()
	var sink_b := TestDiscoverSink.new()

	dispatcher.register_discovery_sink(sink_a)
	dispatcher.register_discovery_sink(sink_b)

	var test_a := GdUnitTestCase.new()
	test_a.guid = GdUnitGUID.new()
	test_a.test_name = "test_a"
	var test_b := GdUnitTestCase.new()
	test_b.guid = GdUnitGUID.new()
	test_b.test_name = "test_a"

	# simulate test discovery
	dispatcher.discover(test_a)
	dispatcher.discover(test_b)

	# verify the discovery is dispached to the sinks
	assert_array(sink_a._discovered_tests).contains_exactly([test_a, test_b])
	assert_array(sink_b._discovered_tests).contains_exactly([test_a, test_b])
