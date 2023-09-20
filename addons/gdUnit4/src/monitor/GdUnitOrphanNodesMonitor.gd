class_name GdUnitOrphanNodesMonitor
extends GdUnitMonitor


var OrphanNodesStart :float
var OrphanCount :float
var _current_count :float


func _init(name :String = ""):
	super("OrphanNodesMonitor:" + name)
	OrphanNodesStart = 0
	OrphanCount = 0


func reset():
	OrphanCount = 0


func start(reset := false):
	if reset:
		reset()
	OrphanNodesStart = GetMonitoredOrphanCount()
	print_verbose(id(), "	start  : %s (initial: %d, orphans: %d)" % [self, OrphanNodesStart, OrphanCount])


func stop():
	OrphanCount = max(0, GetMonitoredOrphanCount() - OrphanNodesStart)
	print_verbose(id(), "	stop  : %s (initial: %d, orphans: %d)" % [self, OrphanNodesStart, OrphanCount])



func GetMonitoredOrphanCount() -> int:
	var n = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	prints("OBJECT_ORPHAN_NODE_COUNT", n)
	return n


func orphan_nodes() -> int:
	return OrphanCount as int
