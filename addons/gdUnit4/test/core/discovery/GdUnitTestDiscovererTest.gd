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


func test_serde_testcase() -> void:
	var test_case := GdUnitTestCase.new()
	test_case.suite_name = "TestSuiteA"
	test_case.test_name = "test_foo"
	test_case.fully_qualified_name = "foo.bar.TestSuiteA.test_foo"
	test_case.source_file = "res://foo/bar/TestSuiteA.gd"
	test_case.line_number = 42
	test_case.attribute_index = 0
	test_case.require_godot_runtime = true


	var json := JSON.stringify(var_to_str(test_case), "\t")
	prints("json:", json)

	var test :Variant = str_to_var( JSON.parse_string(json))
	assert_object(test).is_equal(test_case)
	pass
