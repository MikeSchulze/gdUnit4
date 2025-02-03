class_name GdUnitTestDiscoverer
extends RefCounted


static func run() -> void:
	prints("Running test discovery ..")
	await (Engine.get_main_loop() as SceneTree).process_frame
	GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverStart.new())

	# We run the test discovery in an extra thread so that the main thread is not blocked
	var t:= Thread.new()
	@warning_ignore("return_value_discarded")
	t.start(func () -> void:
		var test_suite_directories :PackedStringArray = GdUnitCommandHandler.scan_all_test_directories(GdUnitSettings.test_root_folder())
		var scanner := GdUnitTestSuiteScanner.new()

		var collected_test_suites: Array[GDScript] = []
		# collect test suites
		for test_suite_dir in test_suite_directories:
			collected_test_suites.append_array(scanner.scan_directory(test_suite_dir))

		# Do sync the main thread before emit the discovered test suites to the inspector
		await (Engine.get_main_loop() as SceneTree).process_frame
		for test_suites_script in collected_test_suites:
			discover_tests(test_suites_script)

		prints("%d test suites discovered." % collected_test_suites.size())
	)
	# wait unblocked to the tread is finished
	while t.is_alive():
		await (Engine.get_main_loop() as SceneTree).process_frame
	# needs finally to wait for finish
	await t.wait_to_finish()
	GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverEnd.new(0, 0))


static func filter_tests(method: Dictionary) -> bool:
	var method_name: String = method["name"]
	return method_name.begins_with("test_")


static func default_discover_sink(test_case: GdUnitTestCase) -> void:
	GdUnitTestDiscoverSink.discover(test_case)


static func discover_tests(source_script: GDScript, discover_sink := default_discover_sink) -> void:
	var test_names := source_script.get_script_method_list()\
		.filter(filter_tests)\
		.map(func(method: Dictionary) -> String: return method["name"])

	# no tests discovered?
	if test_names.is_empty():
		return
	discover_test(source_script, test_names, discover_sink)


static func discover_test(source_script: GDScript, test_names: PackedStringArray, discover_sink := default_discover_sink) -> void:
	var parser := GdScriptParser.new()
	var fds := parser.get_function_descriptors(source_script, test_names)
	for fd in fds:
		var resolver := GdFunctionParameterSetResolver.new(fd)
		for test_case in resolver.resolve_test_cases(source_script):
			discover_sink.call(test_case)
