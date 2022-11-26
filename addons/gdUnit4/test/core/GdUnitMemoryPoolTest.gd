# GdUnit generated TestSuite
class_name GdUnitMemoryPoolTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitMemoryPool.gd'

var _pool :GdUnitMemoryPool
var _source :Object


func before_test():
	_source = Node.new()
	_pool = GdUnitMemoryPool.new()
	_pool.set_pool(_source, GdUnitMemoryPool.POOL.EXECUTE, true)


func after_test():
	_source.free()


func test_orphan_nodes_report_enabled() -> void:
	# enable orphan detection
	_pool.configure(true)
	# create a orphan node
	var orphan1 = Node.new()
	var orphan2 = Node.new()
	_pool.monitor_stop()
	# we expect to detect one orphan node
	assert_int(_pool.orphan_nodes()).is_equal(2)
	
	# manual cleanup
	orphan1.free()
	orphan2.free()


func test_orphan_nodes_report_disabled() -> void:
	# disable orphan detection
	_pool.configure(false)
	# create a orphan node
	var orphan1 = Node.new()
	var orphan2 = Node.new()
	_pool.monitor_stop()
	# we expect to detect one orphan node
	assert_int(_pool.orphan_nodes()).is_equal(0)
	
	# manual cleanup
	orphan1.free()
	orphan2.free()


func test_is_auto_free_registered() -> void:
	var node = auto_free(Node.new())
	GdUnitMemoryPool.register_auto_free(node, GdUnitMemoryPool.POOL.EXECUTE)
	# test checked selected pool
	assert_bool(GdUnitMemoryPool.is_auto_free_registered(node, GdUnitMemoryPool.POOL.TESTSUITE)).is_false()
	assert_bool(GdUnitMemoryPool.is_auto_free_registered(node, GdUnitMemoryPool.POOL.TESTCASE)).is_false()
	assert_bool(GdUnitMemoryPool.is_auto_free_registered(node, GdUnitMemoryPool.POOL.EXECUTE)).is_true()
	# test checked all pools
	assert_bool(GdUnitMemoryPool.is_auto_free_registered(node)).is_true()
