# this test suite fails on multiple stages and detects orphans
extends GdUnitTestSuite

var _orphans := Array()

func before():
	# create a node where never freed (orphan)
	_orphans.append(Node.new())

func before_test():
	# create two node where never freed (orphan)
	_orphans.append(Node.new())
	_orphans.append(Node.new())


# ends with warning and 3 orphan detected
func test_case1():
	# create three node where never freed (orphan)
	_orphans.append(Node.new())
	_orphans.append(Node.new())
	_orphans.append(Node.new())

# ends with error and 4 orphan detected
func test_case2():
	# create four node where never freed (orphan)
	_orphans.append(Node.new())
	_orphans.append(Node.new())
	_orphans.append(Node.new())
	_orphans.append(Node.new())
	assert_str("test_case2").override_failure_message("faild on test_case2()").is_empty()

# we manually freeing the orphans from the simulated testsuite to prevent memory leaks here
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		for orphan in _orphans:
			orphan.free()
		_orphans.clear()
