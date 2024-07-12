# GdUnit generated TestSuite
class_name GdUnitTestDiscoverGuardTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const GdUnitTestDiscoverGuard = preload("res://addons/gdUnit4/src/core/discovery/GdUnitTestDiscoverGuard.gd")





func test_inital() -> void:
	var discoverer := GdUnitTestDiscoverGuard.new()

	assert_dict(discoverer._discover_cache).is_empty()


func test_sync_cache() -> void:
	var discoverer := GdUnitTestDiscoverGuard.new()

	var dto := create_test_dto("res://test/my_test_suite.gd", ["test_a", "test_b"])
	discoverer.sync_cache(dto)

	assert_dict(discoverer._discover_cache).contains_key_value("res://test/my_test_suite.gd", ["test_a", "test_b"])


func test_discover_on_GDScript() -> void:
	var discoverer :GdUnitTestDiscoverGuard = spy(GdUnitTestDiscoverGuard.new())

	# connect to catch the events emitted by the test discoverer
	var emitted_events :Array[GdUnitEvent] = []
	GdUnitSignals.instance().gdunit_event.connect(func on_gdunit_event(event :GdUnitEvent) -> void:
		emitted_events.append(event)
	)

	var script := load("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.gd")
	assert_that(script).is_not_null()
	if script == null:
		return

	await discoverer.discover(script)
	# verify the rebuild is NOT called for gd scripts
	verify(discoverer, 0).rebuild_project(script)

	assert_array(emitted_events).has_size(1)
	assert_object(emitted_events[0]).is_instanceof(GdUnitEventTestDiscoverTestSuiteAdded)
	assert_dict(discoverer._discover_cache).contains_key_value("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.gd", ["test_case1", "test_case2"])


@warning_ignore("unused_parameter")
func test_discover_on_CSharpScript(do_skip := !GdUnit4CSharpApiLoader.is_mono_supported()) -> void:
	var discoverer :GdUnitTestDiscoverGuard = spy(GdUnitTestDiscoverGuard.new())

	# connect to catch the events emitted by the test discoverer
	var emitted_events :Array[GdUnitEvent] = []
	GdUnitSignals.instance().gdunit_event.connect(func on_gdunit_event(event :GdUnitEvent) -> void:
		emitted_events.append(event)
	)

	var script :Script = load("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.cs")

	await discoverer.discover(script)
	# verify the rebuild is called for cs scripts
	verify(discoverer, 1).rebuild_project(script)
	assert_array(emitted_events).has_size(1)
	assert_object(emitted_events[0]).is_instanceof(GdUnitEventTestDiscoverTestSuiteAdded)
	assert_dict(discoverer._discover_cache).contains_key_value("res://addons/gdUnit4/test/core/discovery/resources/DiscoverExampleTestSuite.cs", ["TestCase1", "TestCase2"])


func create_test_dto(path: String, test_cases: PackedStringArray) -> GdUnitTestSuiteDto:
	var dto := GdUnitTestSuiteDto.new()
	dto._path = path
	for test_case in test_cases:
		var test_dto := GdUnitTestCaseDto.new()
		test_dto._name = test_case
		test_dto._line_number = 42
		dto.add_test_case(test_dto)
	return dto
