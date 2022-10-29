# GdUnit generated TestSuite
class_name GdUnitMemMonitorTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/monitorA/GdUnitMemMonitor.gd'

func test_orphan_nodes_zero():
	var monitor := GdUnitMemMonitor.new()
	assert_str(monitor.id()).is_equal("MemMonitor:")
	assert_int(monitor.orphan_nodes()).is_zero()
	
	# simulate monitor use
	monitor.start()
	monitor.stop()
	assert_int(monitor.orphan_nodes()).is_zero()


func test_orphan_nodes_found():
	var monitorA := GdUnitMemMonitor.new()
	var monitorB := GdUnitMemMonitor.new()
	assert_int(monitorA.orphan_nodes()).is_zero()
	assert_int(monitorB.orphan_nodes()).is_zero()

	var save_orphans = []
	# start montor A
	monitorA.start()
	# create 2 orphan nodes
	save_orphans.append(Node.new())
	save_orphans.append(Node.new())
	# start montor B
	monitorB.start()
	# create 10 additonal orphan nodes
	for n in 10:
		save_orphans.append(Node.new())
	monitorA.stop()
	monitorB.stop()
	assert_int(monitorA.orphan_nodes()).is_equal(12)
	assert_int(monitorB.orphan_nodes()).is_equal(10)
	
	# finally freeing manually all orphan nodes we collected
	for n in save_orphans:
		n.free()
