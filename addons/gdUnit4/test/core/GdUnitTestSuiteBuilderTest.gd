# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name GdUnitTestSuiteBuilderTest
extends GdUnitTestSuite

const GdUnitTools := preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")


# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitTestSuiteBuilder.gd'

var _example_source_gd :String


func before_test() -> void:
	var temp := create_temp_dir("examples")
	var result := GdUnitFileAccess.copy_file("res://addons/gdUnit4/test/core/resources/sources/test_person.gd", temp)
	assert_result(result).is_success()
	_example_source_gd = result.value() as String


func after_test() -> void:
	clean_temp_dir()


func assert_tests(test_suite :Script) -> GdUnitArrayAssert:
	# needs to be reload to get fresh method list
	test_suite.reload()
	var methods := test_suite.get_script_method_list()
	var test_cases := Array()
	for method in methods:
		if method.name.begins_with("test_"):
			test_cases.append(method.name)
	return assert_array(test_cases)


func test_create_gd_success() -> void:
	var source := load(_example_source_gd)

	# create initial test suite based checked function selected by line 9
	var result := GdUnitTestSuiteBuilder.create(source, 9)

	assert_result(result).is_success()
	var info := result.value() as Dictionary
	assert_str(info.get("path")).is_equal("user://tmp/test/examples/test_person_test.gd")
	assert_int(info.get("line")).is_equal(11)
	assert_tests(load(info.get("path"))).contains_exactly(["test_first_name"])

	# create additional test checked existing suite based checked function selected by line 15
	result = GdUnitTestSuiteBuilder.create(source, 15)

	assert_result(result).is_success()
	info = result.value() as Dictionary
	assert_str(info.get("path")).is_equal("user://tmp/test/examples/test_person_test.gd")
	assert_int(info.get("line")).is_equal(16)
	assert_tests(load(info.get("path"))).contains_exactly_in_any_order(["test_first_name", "test_fully_name"])


func test_create_gd_fail() -> void:
	var source := load(_example_source_gd)

	# attempt to create an initial test suite based checked the function selected in line 8, which has no function definition
	var result := GdUnitTestSuiteBuilder.create(source, 8)
	assert_result(result).is_error().contains_message("No function found at line: 8.")
