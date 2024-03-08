extends GdUnitTestSuite

var test_node :Node

func before() -> void:
	test_node = auto_free(Node3D.new())


func test_foo(name: String, value, test_parameters := [
	["a", auto_free(Node2D.new())],
	["b", auto_free(Node3D.new())],
	["c", test_node],
	["d", 1],
]) -> void:
	prints("test_foo", name, value)

