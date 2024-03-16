# GdUnit generated TestSuite
class_name GdUnitRunnerConfigTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitRunnerConfig.gd'


func test_initial_config():
	var config := GdUnitRunnerConfig.new()
	assert_dict(config.to_execute()).is_empty()
	assert_dict(config.skipped()).is_empty()


func test_clear_on_initial_config():
	var config := GdUnitRunnerConfig.new()
	config.clear()
	assert_dict(config.to_execute()).is_empty()
	assert_dict(config.skipped()).is_empty()


func test_clear_on_filled_config():
	var config := GdUnitRunnerConfig.new()
	config.add_test_suite("res://foo")
	config.skip_test_suite("res://bar")
	assert_dict(config.to_execute()).is_not_empty()
	assert_dict(config.skipped()).is_not_empty()

	# clear it
	config.clear()
	assert_dict(config.to_execute()).is_empty()
	assert_dict(config.skipped()).is_empty()


func test_set_server_port():
	var config := GdUnitRunnerConfig.new()
	# intial value
	assert_int(config.server_port()).is_equal(-1)

	config.set_server_port(1000)
	assert_int(config.server_port()).is_equal(1000)


func test_self_test():
	var config := GdUnitRunnerConfig.new()
	# initial is empty
	assert_dict(config.to_execute()).is_empty()

	# configure self test
	var to_execute := config.self_test().to_execute()
	assert_dict(to_execute).contains_key_value("res://addons/gdUnit4/test/", PackedStringArray())


func test_add_test_suite():
	var config := GdUnitRunnerConfig.new()
	# skip should have no affect
	config.skip_test_suite("res://bar")

	config.add_test_suite("res://foo")
	assert_dict(config.to_execute()).contains_key_value("res://foo", PackedStringArray())
	# add two more
	config.add_test_suite("res://foo2")
	config.add_test_suite("res://bar/foo")
	assert_dict(config.to_execute())\
		.contains_key_value("res://foo", PackedStringArray())\
		.contains_key_value("res://foo2", PackedStringArray())\
		.contains_key_value("res://bar/foo", PackedStringArray())


func test_add_test_suites():
	var config := GdUnitRunnerConfig.new()
	# skip should have no affect
	config.skip_test_suite("res://bar")

	config.add_test_suites(PackedStringArray(["res://foo2", "res://bar/foo", "res://foo1"]))

	assert_dict(config.to_execute())\
		.contains_key_value("res://foo1", PackedStringArray())\
		.contains_key_value("res://foo2", PackedStringArray())\
		.contains_key_value("res://bar/foo", PackedStringArray())


func test_add_test_case():
	var config := GdUnitRunnerConfig.new()
	# skip should have no affect
	config.skip_test_suite("res://bar")

	config.add_test_case("res://foo1", "testcaseA")
	assert_dict(config.to_execute()).contains_key_value("res://foo1", PackedStringArray(["testcaseA"]))
	# add two more
	config.add_test_case("res://foo1", "testcaseB")
	config.add_test_case("res://foo2", "testcaseX")
	assert_dict(config.to_execute())\
		.contains_key_value("res://foo1", PackedStringArray(["testcaseA", "testcaseB"]))\
		.contains_key_value("res://foo2", PackedStringArray(["testcaseX"]))


func test_add_test_suites_and_test_cases_combi():
	var config := GdUnitRunnerConfig.new()

	config.add_test_suite("res://foo1")
	config.add_test_suite("res://foo2")
	config.add_test_suite("res://bar/foo")
	config.add_test_case("res://foo1", "testcaseA")
	config.add_test_case("res://foo1", "testcaseB")
	config.add_test_suites(PackedStringArray(["res://foo3", "res://bar/foo3", "res://foo4"]))

	assert_dict(config.to_execute())\
		.has_size(6)\
		.contains_key_value("res://foo1", PackedStringArray(["testcaseA", "testcaseB"]))\
		.contains_key_value("res://foo2", PackedStringArray())\
		.contains_key_value("res://foo3", PackedStringArray())\
		.contains_key_value("res://foo4", PackedStringArray())\
		.contains_key_value("res://bar/foo3", PackedStringArray())\
		.contains_key_value("res://bar/foo", PackedStringArray())


func test_skip_test_suite():
	var config := GdUnitRunnerConfig.new()

	config.skip_test_suite("res://foo1")
	assert_dict(config.skipped()).contains_key_value("res://foo1", PackedStringArray())
	# add two more
	config.skip_test_suite("res://foo2")
	config.skip_test_suite("res://bar/foo1")
	assert_dict(config.skipped())\
		.contains_key_value("res://foo1", PackedStringArray())\
		.contains_key_value("res://foo2", PackedStringArray())\
		.contains_key_value("res://bar/foo1", PackedStringArray())


func test_skip_test_suite_and_test_case():
	var possible_paths :PackedStringArray = [
		"/foo/MyTest.gd",
		"res://foo/MyTest.gd",
		"/foo/MyTest.gd:test_x",
		"res://foo/MyTest.gd:test_y",
		"MyTest",
		"MyTest:test",
		"MyTestX",
	]
	var config := GdUnitRunnerConfig.new()
	for path in possible_paths:
		config.skip_test_suite(path)
	assert_dict(config.skipped())\
		.has_size(3)\
		.contains_key_value("res://foo/MyTest.gd", PackedStringArray(["test_x", "test_y"]))\
		.contains_key_value("MyTest", PackedStringArray(["test"]))\
		.contains_key_value("MyTestX", PackedStringArray())


func test_skip_test_case():
	var config := GdUnitRunnerConfig.new()

	config.skip_test_case("res://foo1", "testcaseA")
	assert_dict(config.skipped()).contains_key_value("res://foo1", PackedStringArray(["testcaseA"]))
	# add two more
	config.skip_test_case("res://foo1", "testcaseB")
	config.skip_test_case("res://foo2", "testcaseX")
	assert_dict(config.skipped())\
		.contains_key_value("res://foo1", PackedStringArray(["testcaseA", "testcaseB"]))\
		.contains_key_value("res://foo2", PackedStringArray(["testcaseX"]))


func test_load_fail():
	var config := GdUnitRunnerConfig.new()

	assert_result(config.load_config("invalid_path"))\
		.is_error()\
		.contains_message("Can't find test runner configuration 'invalid_path'! Please select a test to run.")


func test_save_load():
	var config := GdUnitRunnerConfig.new()
	# add some dummy conf
	config.set_server_port(1000)
	config.skip_test_suite("res://bar")
	config.add_test_suite("res://foo2")
	config.add_test_case("res://foo1", "testcaseA")

	var config_file := create_temp_dir("test_save_load") + "/testconf.cfg"

	assert_result(config.save_config(config_file)).is_success()
	assert_file(config_file).exists()

	var config2 := GdUnitRunnerConfig.new()
	assert_result(config2.load_config(config_file)).is_success()
	# verify the config has original enties
	assert_object(config2).is_equal(config).is_not_same(config)
