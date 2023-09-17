class_name GdUnitOrphanNodesMonitor
extends GdUnitMonitor


var _parent_monitor :GdUnitOrphanNodesMonitor
var _inital_count :float
var _current_count :float
var _total_count :float


func _init(name :String = "", parent_monitor :GdUnitOrphanNodesMonitor = null):
	super("OrphanNodesMonitor:" + name)
	_parent_monitor = parent_monitor
	_inital_count = 0
	_current_count = 0
	_total_count = 0


func reset():
	_total_count = 0


func start():
	_inital_count = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	print_verbose(id(), "	start: %s (%s)" % [self, _inital_count])


func stop():
	_current_count = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	_total_count = max(0, _current_count - _inital_count)
	print_verbose(id(), "	stop : %s (%d %d %d)" % [self, _inital_count, _current_count, _total_count])


func orphan_nodes() -> int:
	return _total_count as int
