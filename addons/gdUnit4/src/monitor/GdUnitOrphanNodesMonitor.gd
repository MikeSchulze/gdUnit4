class_name GdUnitOrphanNodesMonitor
extends GdUnitMonitor

var _initial_count := 0
var _orphan_count := 0
var _orphan_detection_enabled :bool


func _init(name :String = ""):
	super("OrphanNodesMonitor:" + name)
	_orphan_detection_enabled = GdUnitSettings.is_verbose_orphans()


func start():
	_initial_count = _orphans()
	#print_verbose(id(), "	start  : %s (initial: %d, orphans: %d)" % [self, _initial_count, _orphan_count])


func stop():
	_orphan_count = max(0, _orphans() - _initial_count)
	#print_verbose(id(), "	stop  : %s (initial: %d, orphans: %d)" % [self, _initial_count, _orphan_count])


func _orphans() -> int:
	return Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) as int


func orphan_nodes() -> int:
	return _orphan_count if _orphan_detection_enabled else 0