extends GdUnitTestSuite


func test_discover_many_test() -> void:
	var script: GDScript = load("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.gd")

	var discovered_tests := []
	GdUnitTestDiscoverer.discover_tests(script,
		func discover(test_case: GdUnitTestCase) -> void:
			if test_case.test_name in ["test_case1", "test_case2", "test_parameterized_static"]:
				discovered_tests.append(test_case)
	)

	assert_array(discovered_tests)\
		.extractv(extr("test_name"), extr("display_name"))\
		.contains_exactly([
			tuple("test_case1", "test_case1"),
			tuple("test_case2", "test_case2"),
			tuple("test_parameterized_static", "test_parameterized_static:0 (1, 1)"),
			tuple("test_parameterized_static", "test_parameterized_static:1 (2, 2)"),
			tuple("test_parameterized_static", "test_parameterized_static:2 (3, 3)"),
		])


func test_discover_parameterized_test() -> void:
	var script: GDScript = load("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.gd")

	var discovered_tests := []
	GdUnitTestDiscoverer.discover_tests(script,
		func discover(test_case: GdUnitTestCase) -> void:
			if test_case.test_name == "test_parameterized_static":
				discovered_tests.append(test_case)
	)

	assert_array(discovered_tests)\
		.extractv(extr("test_name"), extr("display_name"))\
		.contains_exactly([
			tuple("test_parameterized_static", "test_parameterized_static:0 (1, 1)"),
			tuple("test_parameterized_static", "test_parameterized_static:1 (2, 2)"),
			tuple("test_parameterized_static", "test_parameterized_static:2 (3, 3)"),
		])


func test_discover_tests() -> void:
	var script: GDScript = load("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.gd")

	var discovered_tests := []
	GdUnitTestDiscoverer.discover_tests(script,\
		func discover(test_case: GdUnitTestCase) -> void:
			discovered_tests.append(test_case)
	)

	assert_array(discovered_tests)\
		.extractv(extr("test_name"), extr("display_name"))\
		.contains_exactly([
			tuple("test_case1", "test_case1"),
			tuple("test_case2", "test_case2"),
			tuple("test_parameterized_static", "test_parameterized_static:0 (1, 1)"),
			tuple("test_parameterized_static", "test_parameterized_static:1 (2, 2)"),
			tuple("test_parameterized_static", "test_parameterized_static:2 (3, 3)"),
			tuple("test_parameterized_static_external", "test_parameterized_static_external:0 (<null>)"),
			tuple("test_parameterized_static_external", "test_parameterized_static_external:1 (%s)" % Vector2.ONE),
			tuple("test_parameterized_static_external", "test_parameterized_static_external:2 (%s)" % Vector2i.ONE),
			tuple("test_parameterized_dynamic", "test_parameterized_dynamic:0 (<null>)"),
			tuple("test_parameterized_dynamic", "test_parameterized_dynamic:1 (%s)" % Vector2.ONE),
			tuple("test_parameterized_dynamic", "test_parameterized_dynamic:2 (%s)" % Vector2i.ONE),
		])


func test_discover_tests_on_GdUnitTestSuite() -> void:
	var script: GDScript = load("res://addons/gdUnit4/src/GdUnitTestSuite.gd")

	var discovered_tests := []
	GdUnitTestDiscoverer.discover_tests(script,\
		func discover(test_case: GdUnitTestCase) -> void:
			discovered_tests.append(test_case)
	)

	# we expect no test covered from the base implementaion of GdUnitTestSuite
	assert_array(discovered_tests).is_empty()


func test_discover_tests_inherited() -> void:
	var script: GDScript = load("res://addons/gdUnit4/test/core/resources/scan_testsuite_inheritance/by_class_name/ExtendsExtendedTest.gd")

	var discovered_tests := []
	GdUnitTestDiscoverer.discover_tests(script,\
		func discover(test_case: GdUnitTestCase) -> void:
			discovered_tests.append(test_case)
	)

	assert_array(discovered_tests)\
		.extractv(extr("test_name"), extr("display_name"), extr("fully_qualified_name"))\
		.contains_exactly([
			tuple("test_foo3", "test_foo3", "addons.gdUnit4.test.core.resources.scan_testsuite_inheritance.by_class_name.ExtendsExtendedTest.test_foo3"),
			tuple("test_foo2", "test_foo2", "addons.gdUnit4.test.core.resources.scan_testsuite_inheritance.by_class_name.ExtendsExtendedTest.test_foo2"),
			tuple("test_foo1", "test_foo1", "addons.gdUnit4.test.core.resources.scan_testsuite_inheritance.by_class_name.ExtendsExtendedTest.test_foo1")
		])


#if GDUNIT4NET_API_V5
func test_discover_csharp_tests(do_skip := !GdUnit4CSharpApiLoader.is_api_loaded()) -> void:
	var script :Script = load("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.cs")
	var discovered_tests := []
	GdUnitTestDiscoverer.discover_tests(script,\
		func discover(test_case: GdUnitTestCase) -> void:
			discovered_tests.append(test_case)
	)
	assert_array(discovered_tests)\
		.extractv(extr("test_name"), extr("display_name"), extr("fully_qualified_name"))\
		.contains_exactly([
			tuple("TestCase1", "TestCase1", "gdUnit4.addons.gdUnit4.test.core.discovery.resources.DiscoverExampleTestSuite.TestCase1"),
			tuple("TestCase2", "TestCase2", "gdUnit4.addons.gdUnit4.test.core.discovery.resources.DiscoverExampleTestSuite.TestCase2")
		])
#endif
