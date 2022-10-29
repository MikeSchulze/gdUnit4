class_name GdUnitMemoryPool 
extends Node

const META_PARAM := "MEMORY_POOL"

enum  {
	SUITE_SETUP,
	TEST_SETUP,
	TEST_EXECUTE,
}

var _monitors := {
	SUITE_SETUP : GdUnitMemMonitor.new("SUITE_SETUP"),
	TEST_SETUP : GdUnitMemMonitor.new("TEST_SETUP"),
	TEST_EXECUTE : GdUnitMemMonitor.new("TEST_EXECUTE"),
}

var _monitored_pool_order := Array()
var _current :int
var _orphan_detection_enabled :bool = true

func _init():
	set_name("GdUnitMemoryPool-%d" % get_instance_id())
	configure(GdUnitSettings.is_verbose_orphans())

func configure(orphan_detection :bool):
	_orphan_detection_enabled = orphan_detection
	if not _orphan_detection_enabled:
		prints("!!! Reporting orphan nodes is disabled. Please check GdUnit settings.")

func set_pool(obj :Object, pool_id :int, reset_monitor: bool = false) -> void:
	_current = pool_id
	obj.set_meta(META_PARAM, pool_id)
	var monitor := get_monitor(_current)
	if reset_monitor:
		monitor.reset()
	monitor.start()

func monitor_stop() -> void:
	var monitor := get_monitor(_current)
	monitor.stop()

func free_pool() -> void:
	GdUnitTools.run_auto_free(_current)
	
func get_monitor(pool_id :int) -> GdUnitMemMonitor:
	return _monitors.get(pool_id)

func orphan_nodes() -> int:
	if _orphan_detection_enabled:
		return _monitors.get(_current).orphan_nodes()
	return 0
