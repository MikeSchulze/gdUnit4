# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name GdUnit3MonoAPITest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/mono/GdUnit3MonoAPI.gd'
var _example_source_cs :String

func before_test():
	var temp := create_temp_dir("examples")
	var result := GdUnitTools.copy_file("res://addons/gdUnit4/test/resources/core/sources/TestPerson.cs", temp)
	assert_result(result).is_success()
	_example_source_cs = result.value() as String

func test_create_test_suite() -> void:
	if not GdUnitTools.is_mono_supported():
		# ignore this test checked none mono installations
		return
	var source := load(_example_source_cs)
	var test_suite_path := GdUnitTestSuiteScanner.resolve_test_suite_path(source.resource_path, "test")
	var result := GdUnit3MonoAPI.create_test_suite(source.resource_path, 18, test_suite_path)

	assert_result(result).is_success()
	var info := result.value() as Dictionary
	assert_str(info.get("path")).is_equal("user://tmp/test/examples/TestPersonTest.cs")
	assert_int(info.get("line")).is_equal(16)
