# GdUnit generated TestSuite
class_name GdUnitTestDiscovererTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/discovery/GdUnitTestDiscoverer.gd'


func test_build_fully_qualified_name() -> void:
	var test: _TestCase = auto_free(_TestCase.new())
	test.configure("test_a", 42, "res://foo/bar/TestSuiteA.gd")

	var fully_qualified_name := GdUnitTestDiscoverer.build_fully_qualified_name(test)
	assert_str(fully_qualified_name).is_equal("foo.bar.TestSuiteA.gdtest_a")
