## A dispatcher class that manages multiple test discovery sinks in GdUnit4.
## Implements the singleton pattern to maintain a central registry of discovery sinks.
## Forwards discovered test cases to all registered sinks.
class_name GdUnitTestDiscoverySinkDispatcher
extends GdUnitTestDiscoverSink


## Array of registered discovery sinks that will receive test case discoveries.
var _discover_sinks: Array[GdUnitTestDiscoverSink] = []


## Returns the singleton instance of the dispatcher.[br]
## Creates a new instance if none exists.
static func instance() -> GdUnitTestDiscoverySinkDispatcher:
	if Engine.has_meta("GdUnitTestDiscoverySinkDispatcher"):
		return Engine.get_meta("GdUnitTestDiscoverySinkDispatcher")
	var instance_ := GdUnitTestDiscoverySinkDispatcher.new()
	Engine.set_meta("GdUnitTestDiscoverySinkDispatcher", instance_)
	return instance_


## Registers a new discovery sink to receive test case discoveries.[br]
## [member discovery_sink] The sink to be registered for receiving test case discoveries.
func register_discovery_sink(discovery_sink: GdUnitTestDiscoverSink) -> void:
	_discover_sinks.append(discovery_sink)


## Forwards discovered test cases to all registered sinks.[br]
## [member test_case] The test case to be forwarded to all registered sinks.
func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
	for sink in _discover_sinks:
		sink.on_test_case_discovered(test_case)
