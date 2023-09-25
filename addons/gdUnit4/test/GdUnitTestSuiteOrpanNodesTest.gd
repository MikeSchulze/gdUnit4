extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


var before_node
var before_test_node

func before():
	before_node = auto_free(Node.new())
	add_child(before_node)
	Node.new()


func before_test():
	#before_test_node = auto_free(Node.new())
	Node.new()
	Node.new()


func test_auto_free_before() -> void:
	# test suite orphan warning
	pass


func test_3auto_free() -> void:
	Node.new()
	Node.new()
	Node.new()
	add_child(Node.new())


func test_4() -> void:
	Node.new()
	Node.new()
	Node.new()
	Node.new()


func test_auto_free_local() -> void:
	# works fine
	var local_test_node = auto_free(Node.new())
	add_child(local_test_node)
