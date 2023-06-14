extends GdUnitTestSuite



func test_fail_on_godot_403():
	prints( "%X" % Engine.get_version_info().hex)
	assert_bool( Engine.get_version_info().hex == 0x40003).is_false()
