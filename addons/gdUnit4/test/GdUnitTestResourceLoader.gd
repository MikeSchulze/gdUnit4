class_name GdUnitTestResourceLoader
extends RefCounted

enum {
	GD_SUITE,
	CS_SUITE
}


static func load_test_suite(resource_path :String, script_type = GD_SUITE) -> Node:
	match script_type:
		GD_SUITE:
			return load_test_suite_gd(resource_path)
		CS_SUITE:
			return load_test_suite_cs(resource_path)
	assert("type '%s' is not impleented" % script_type)
	return null


static func load_test_suite_gd(resource_path :String) -> GdUnitTestSuite:
	var script := load_gd_script(resource_path)
	var test_suite :GdUnitTestSuite = script.new()
	test_suite.set_name(resource_path.get_file().replace(".resource", "").replace(".gd", ""))
	# complete test suite wiht parsed test cases
	var suite_scanner := GdUnitTestSuiteScanner.new()
	var test_case_names := suite_scanner._extract_test_case_names(script)
	# add test cases to test suite and parse test case line nummber
	suite_scanner._parse_and_add_test_cases(test_suite, script, test_case_names)
	return test_suite


static func load_test_suite_cs(resource_path :String) -> Node:
	if not GdUnitTools.is_mono_supported():
		return null
	var script = ClassDB.instantiate("CSharpScript")
	script.source_code = GdUnitTools.resource_as_string(resource_path)
	script.resource_path = resource_path
	script.reload()
	return null

static func load_cs_script(resource_path :String) -> Script:
	if not GdUnitTools.is_mono_supported():
		return null
	var script = ClassDB.instantiate("CSharpScript")
	script.source_code = GdUnitTools.resource_as_string(resource_path)
	script.resource_path = GdUnitTools.create_temp_dir("test") + "/%s" % resource_path.get_file().replace(".resource", ".cs")
	DirAccess.remove_absolute(script.resource_path)
	ResourceSaver.save(script.resource_path, script)
	script.reload()
	return script

static func load_gd_script(resource_path :String) -> GDScript:
	var script := GDScript.new()
	script.source_code = GdUnitTools.resource_as_string(resource_path)
	script.take_over_path(resource_path)
	script.reload()
	return script
	
