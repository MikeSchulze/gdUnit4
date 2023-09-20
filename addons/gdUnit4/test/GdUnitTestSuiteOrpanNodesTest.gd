extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


var before_node
var before_test_node

func before():
	before_node = auto_free(Node.new())


func before_test():
	#before_test_node = auto_free(Node.new())
	auto_free(Node.new())
	auto_free(Node.new())


func test_auto_free_before() -> void:
	# test suite orphan warning
	#add_child(before_node)
	pass


func test_auto_free() -> void:
	Node.new()
	Node.new()
	Node.new()
	Node.new()
	# test suite orphan warning
	#add_child(before_node)
	pass


func _test_auto_free_local() -> void:
	# works fine
	var local_test_node = auto_free(Node.new())
	add_child(local_test_node)
