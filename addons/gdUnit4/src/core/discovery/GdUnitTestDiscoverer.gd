class_name GdUnitTestDiscoverer
extends RefCounted


static func run() -> void:
	prints("Running test discovery ..")
	GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverStart.new())
	await (Engine.get_main_loop() as SceneTree).create_timer(.5).timeout

	# We run the test discovery in an extra thread so that the main thread is not blocked
	var t:= Thread.new()
	@warning_ignore("return_value_discarded")
	t.start(func () -> void:
		var test_suite_directories :PackedStringArray = GdUnitCommandHandler.scan_all_test_directories(GdUnitSettings.test_root_folder())
		var scanner := GdUnitTestSuiteScanner.new()
		var _test_suites_to_process :Array[Node] = []

		for test_suite_dir in test_suite_directories:
			_test_suites_to_process.append_array(scanner.scan(test_suite_dir))

		# Do sync the main thread before emit the discovered test suites to the inspector
		await (Engine.get_main_loop() as SceneTree).process_frame
		var test_case_count :int = 0
		for test_suite in _test_suites_to_process:
			discover_test_suite(test_suite)

			## @Deprecated
			test_case_count += test_suite.get_child_count()
			var ts_dto := GdUnitTestSuiteDto.of(test_suite)
			GdUnitSignals.instance().gdunit_add_test_suite.emit(ts_dto)
			test_suite.free()

		prints("%d test suites discovered." % _test_suites_to_process.size())
		GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverEnd.new(_test_suites_to_process.size(), test_case_count))
		_test_suites_to_process.clear()
	)
	# wait unblocked to the tread is finished
	while t.is_alive():
		await (Engine.get_main_loop() as SceneTree).process_frame
	# needs finally to wait for finish
	await t.wait_to_finish()


static func discover_test_suite(test_suite: Node) -> void:
	for child in test_suite.get_children():
		if child is not _TestCase:
			continue
		var test: _TestCase = child
		var test_case := GdUnitTestCase.new()
		test_case.suite_name = test_suite.get_name()
		test_case.test_name = test.get_name()
		test_case.fully_qualified_name = build_fully_qualified_name(test)
		test_case.source_file = test.script_path()
		test_case.line_number = test.line_number()
		test_case.attribute_index = 0
		test_case.require_godot_runtime = true
		GdUnitTestDiscoverSink.discover(test_case)


static func build_fully_qualified_name(test_case: _TestCase) -> String:
	var name_space := test_case.script_path().trim_prefix("res://").replace("/", ".")
	return name_space + test_case.get_name()
