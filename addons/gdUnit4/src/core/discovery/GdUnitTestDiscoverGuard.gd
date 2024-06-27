extends RefCounted

# contains all tracked test suites where discovered since editor start
# key : test suite resource_path
# value: the list of discovered test case names
var _discover_cache := {}


func _init() -> void:
	# Register for discovery events to sync the cache
	GdUnitSignals.instance().gdunit_add_test_suite.connect(sync_cache)


func sync_cache(dto :GdUnitTestSuiteDto) -> void:
	var resource_path := ProjectSettings.localize_path(dto.path())
	var discovered_test_cases :Array[String] = []
	for test_case in dto.test_cases():
		discovered_test_cases.append(test_case.name())
	_discover_cache[resource_path] = discovered_test_cases


func discover(script: Script) -> void:
	# for cs scripts we need to recomplie before discover new tests
	if GdObjects.is_cs_script(script):
		await rebuild_project(script)

	if GdObjects.is_test_suite(script):
		# a new test suite is discovered
		var script_path := ProjectSettings.localize_path(script.resource_path)
		var scanner := GdUnitTestSuiteScanner.new()
		var test_suite := scanner._parse_test_suite(script)
		var suite_name := test_suite.get_name()

		if not _discover_cache.has(script_path):
			var dto :GdUnitTestSuiteDto = GdUnitTestSuiteDto.of(test_suite)
			GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestSuiteAdded.new(script_path, suite_name, dto))
			sync_cache(dto)
			test_suite.queue_free()
			return

		var discovered_test_cases :Array[String] = _discover_cache.get(script_path, [] as Array[String])
		var script_test_cases := extract_test_functions(test_suite)

		# first detect removed/renamed tests
		var tests_removed := PackedStringArray()
		for test_case in discovered_test_cases:
			if not script_test_cases.has(test_case):
				tests_removed.append(test_case)
		# second detect new added tests
		var tests_added :Array[String] = []
		for test_case in script_test_cases:
			if not discovered_test_cases.has(test_case):
				tests_added.append(test_case)

		# finally notify changes to the inspector
		if not tests_removed.is_empty() or not tests_added.is_empty():
			# emit deleted tests
			for test_name in tests_removed:
				discovered_test_cases.erase(test_name)
				GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestRemoved.new(script_path, suite_name, test_name))

			# emit new discovered tests
			for test_name in tests_added:
				discovered_test_cases.append(test_name)
				var test_case := test_suite.find_child(test_name, false, false)
				var dto := GdUnitTestCaseDto.new()
				dto = dto.deserialize(dto.serialize(test_case))
				GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestAdded.new(script_path, suite_name, dto))
			# update the cache
			_discover_cache[script_path] = discovered_test_cases
			test_suite.queue_free()


func extract_test_functions(test_suite :Node) -> PackedStringArray:
	return test_suite.get_children()\
		.map(func (child: Node) -> String: return child.get_name())


# do rebuild the entire project, there is actual no way to enforce the Godot engine itself to do this
func rebuild_project(script: Script) -> void:
	var class_path := ProjectSettings.globalize_path(script.resource_path)
	print_rich("[color=CORNFLOWER_BLUE]GdUnitTestDiscoverGuard: CSharpScript change detected on: '%s' [/color]" % class_path)
	await Engine.get_main_loop().process_frame

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
	await Engine.get_main_loop().process_frame
