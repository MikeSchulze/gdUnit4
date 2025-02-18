extends RefCounted


# Caches all test indices for parameterized tests
class TestCaseIndicesCache:
	var _cache := {}

	func _key(resource_path: String, test_name: String) -> StringName:
		return &"%s_%s" % [resource_path, test_name]


	func contains_test_case(resource_path: String, test_name: String) -> bool:
		return _cache.has(_key(resource_path, test_name))


	func validate(resource_path: String, test_name: String, indices: PackedStringArray) -> bool:
		var cached_indicies: PackedStringArray = _cache[_key(resource_path, test_name)]
		return GdArrayTools.has_same_content(cached_indicies, indices)


	func sync(resource_path: String, test_name: String, indices: PackedStringArray) -> void:
		if indices.is_empty():
			_cache[_key(resource_path, test_name)] = []
		else:
			_cache[_key(resource_path, test_name)] = indices

# contains all tracked test suites where discovered since editor start
# key : test suite resource_path
# value: the list of discovered test case names
var _discover_cache := {}

var discovered_test_case_indices_cache := TestCaseIndicesCache.new()


func _init() -> void:
	# Register for discovery events to sync the cache
	@warning_ignore("return_value_discarded")
	GdUnitSignals.instance().gdunit_add_test_suite.connect(sync_cache)


func sync_cache(dto: GdUnitTestSuiteDto) -> void:
	var resource_path := ProjectSettings.localize_path(dto.path())
	var discovered_test_cases: Array[String] = []
	for test_case in dto.test_cases():
		discovered_test_cases.append(test_case.name())
		discovered_test_case_indices_cache.sync(resource_path, test_case.name(), test_case.test_case_names())
	_discover_cache[resource_path] = discovered_test_cases


func discover(script: Script) -> void:
	# for cs scripts we need to recomplie before discover new tests
	if GdObjects.is_cs_script(script):
		await rebuild_project(script)

	if GdObjects.is_test_suite(script):
		# a new test suite is discovered
		var script_path := ProjectSettings.localize_path(script.resource_path)
		var scanner := GdUnitTestSuiteScanner.new()

		# rediscover all tests
		if script is GDScript:
			GdUnitTestDiscoverer.discover_tests(script)
		else:
			## TODO add c# test sidcovery here
			pass

		if not _discover_cache.has(script_path):
			#var dto :GdUnitTestSuiteDto = GdUnitTestSuiteDto.of(test_suite)
			#GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestSuiteAdded.new(script_path, suite_name, dto))
			#sync_cache(dto)
			#test_suite.queue_free()
			return

		var discovered_test_cases :Array[String] = _discover_cache.get(script_path, [] as Array[String])







func extract_test_functions(test_suite :Node) -> PackedStringArray:
	return test_suite.get_children()\
		.filter(func(child: Node) -> bool: return is_instance_of(child, _TestCase))\
		.map(func (child: Node) -> String: return child.get_name())


func is_paramaterized_test(test_suite :Node, test_case_name: String) -> bool:
	return test_suite.get_children()\
		.filter(func(child: Node) -> bool: return child.name == test_case_name)\
		.any(func (test: _TestCase) -> bool: return test.is_parameterized())


# do rebuild the entire project, there is actual no way to enforce the Godot engine itself to do this
func rebuild_project(script: Script) -> void:
	var class_path := ProjectSettings.globalize_path(script.resource_path)
	print_rich("[color=CORNFLOWER_BLUE]GdUnitTestDiscoverGuard: CSharpScript change detected on: '%s' [/color]" % class_path)
	var scene_tree := Engine.get_main_loop() as SceneTree
	await scene_tree.process_frame

	var output := []
	var exit_code := OS.execute("dotnet", ["--version"], output)
	if exit_code == -1:
		print_rich("[color=CORNFLOWER_BLUE]GdUnitTestDiscoverGuard:[/color] [color=RED]Rebuild the project failed.[/color]")
		print_rich("[color=CORNFLOWER_BLUE]GdUnitTestDiscoverGuard:[/color] [color=RED]Can't find installed `dotnet`! Please check your environment is setup correctly.[/color]")
		return
	print_rich("[color=CORNFLOWER_BLUE]GdUnitTestDiscoverGuard:[/color] [color=DEEP_SKY_BLUE]Found dotnet v%s[/color]" % output[0].strip_edges())
	output.clear()

	exit_code = OS.execute("dotnet", ["build"], output)
	print_rich("[color=CORNFLOWER_BLUE]GdUnitTestDiscoverGuard:[/color] [color=DEEP_SKY_BLUE]Rebuild the project ... [/color]")
	for out:Variant in output:
		print_rich("[color=DEEP_SKY_BLUE] 		%s" % out.strip_edges())
	await scene_tree.process_frame
