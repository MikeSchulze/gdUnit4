extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


var before_node
var before_test_node

func before():
	before_node = auto_free(Node.new())
	pass

func before_test():
	prints("add auto_free")
	before_test_node = auto_free(Node.new())




func _test_auto_free_before_test() -> void:
	# test case orphan warning
	add_child(before_test_node)

func test_auto_free_before() -> void:
	# test suite orphan warning
	add_child(before_node)

func test_auto_free_local() -> void:
	# works fine
	var local_test_node = auto_free(Node.new())
	add_child(local_test_node)
