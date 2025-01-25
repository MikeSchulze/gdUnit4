## A dispatcher class that manages multiple test discovery sinks in GdUnit4.
## Implements the singleton pattern to maintain a central registry of discovery sinks.
## Forwards discovered test cases to all registered sinks.
class_name GdUnitTestDiscoverySinkDispatcher
extends GdUnitTestDiscoverSink


class Singleton extends Node:
	var _instance :Object

	func _init(singleton_name: String, instance_object: Object) -> void:
		set_name(singleton_name)
		_instance = instance_object

	func _notification(what: int) -> void:
		if _instance == null:
			return
		_instance.notification(what)
		if _instance is Node:
			_instance.call_deferred("free")


	func instance() -> Object:
		return _instance


## Array of registered discovery sinks that will receive test case discoveries.
var _discover_sinks: Array[GdUnitTestDiscoverSink] = []


## Returns the singleton instance of the dispatcher.[br]
## Creates a new instance if none exists.
static func instance() -> GdUnitTestDiscoverySinkDispatcher:
	var scene_tree :SceneTree = Engine.get_main_loop()
	var singleton_node: Singleton = scene_tree.root.find_child("GdUnitTestDiscoverySinkDispatcher", false, false)
	if singleton_node == null:
		singleton_node = Singleton.new("GdUnitTestDiscoverySinkDispatcher", GdUnitTestDiscoverySinkDispatcher.new())
		scene_tree.root.add_child(singleton_node, true, Node.INTERNAL_MODE_BACK)
	return singleton_node.instance()


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_discover_sinks.clear()


## Registers a new discovery sink to receive test case discoveries.[br]
## [member discovery_sink] The sink to be registered for receiving test case discoveries.
func register_discovery_sink(discovery_sink: GdUnitTestDiscoverSink) -> void:
	_discover_sinks.append(discovery_sink)


## Forwards discovered test cases to all registered sinks.[br]
## [member test_case] The test case to be forwarded to all registered sinks.
func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
	for sink in _discover_sinks:
		sink.on_test_case_discovered(test_case)
