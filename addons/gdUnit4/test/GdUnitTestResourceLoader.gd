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

# loads a test suite as resource and stores is temporary under 'res://addons/gdUnit4/.tmp' to be reload as gdScript
# we need to store it under 'res://' as *.gd otherwise the class is not correct loaded and 'inst_to_dict' will be fail
static func load_test_suite_gd(resource_path :String) -> GdUnitTestSuite:
	var resource_script := load_gd_script(resource_path)
	var temp_dir := "res://addons/gdUnit4/.tmp"
	var parts := resource_script.resource_path.split("res://addons/gdUnit4")
	var new_resource_path := "%s%s" % [temp_dir, parts[1]]
	DirAccess.make_dir_recursive_absolute(new_resource_path.get_base_dir())
	var err := ResourceSaver.save(resource_script, new_resource_path, ResourceSaver.FLAG_BUNDLE_RESOURCES|ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	var script :GDScript = ResourceLoader.load(new_resource_path, "GDScript", ResourceLoader.CACHE_MODE_REPLACE);
	var test_suite :GdUnitTestSuite = script.new()
	test_suite.set_name(new_resource_path.get_file().replace(".gd", ""))
	# complete test suite wiht parsed test cases
	var suite_scanner := GdUnitTestSuiteScanner.new()
	var test_case_names := suite_scanner._extract_test_case_names(script)
	# add test cases to test suite and parse test case line nummber
	suite_scanner._parse_and_add_test_cases(test_suite, script, test_case_names)
	GdUnitTools.delete_directory("res://addons/gdUnit4/.tmp")
	return test_suite

static func load_test_suite_gd_(resource_path :String) -> GdUnitTestSuite:
	var script := load_gd_script(resource_path)
	#script.resource_path = GdUnitTools.create_temp_dir("test") + "/%s" % resource_path.get_file()#.replace(".resource", ".gd")
	var test_suite :GdUnitTestSuite = script.new()
	test_suite.set_name(resource_path.get_file().replace(".resource", "").replace(".gd", ""))
	# complete test suite wiht parsed test cases
	var suite_scanner := GdUnitTestSuiteScanner.new()
	var test_case_names := suite_scanner._extract_test_case_names(script)
	# add test cases to test suite and parse test case line nummber
	script.resource_path = resource_path
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
	script.resource_path = resource_path.replace(".resource", ".gd")
	script.reload()
	return script
	
