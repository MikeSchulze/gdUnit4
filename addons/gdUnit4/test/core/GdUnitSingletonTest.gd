extends GdUnitTestSuite

func test_instance() -> void:
	var n = GdUnitSingleton.instance("singelton_test", func(): return Node.new() )
	assert_object(n).is_instanceof(Node)
	n.free()
	Engine.remove_meta("singelton_test")
