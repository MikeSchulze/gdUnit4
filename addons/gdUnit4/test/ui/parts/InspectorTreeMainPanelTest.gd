# GdUnit generated TestSuite
class_name InspectorTreeMainPanelTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/ui/parts/InspectorTreeMainPanel.gd'

var TEST_SUITE_A :String
var TEST_SUITE_B :String
var TEST_SUITE_C :String

var _inspector

func before_test():
	_inspector = load("res://addons/gdUnit4/src/ui/parts/InspectorTreePanel.tscn").instantiate()
	add_child(_inspector)
	_inspector.init_tree()
	
	# load a testsuite 
	for test_suite in setup_test_env():
		_inspector.add_test_suite(toDto(test_suite))
	# verify no failures are exists
	assert_array(_inspector.collect_failures_and_errors()).is_empty()


func after_test():
	_inspector.cleanup_tree()
	remove_child(_inspector)
	_inspector.free()


func toDto(test_suite :Node) -> GdUnitTestSuiteDto:
	var dto := GdUnitTestSuiteDto.new()
	return dto.deserialize(dto.serialize(test_suite)) as GdUnitTestSuiteDto


func setup_test_env() -> Array:
	var test_suite_a := GdUnitTestResourceLoader.load_test_suite("res://addons/gdUnit4/test/ui/parts/resources/foo/ExampleTestSuiteA.resource")
	var test_suite_b := GdUnitTestResourceLoader.load_test_suite("res://addons/gdUnit4/test/ui/parts/resources/foo/ExampleTestSuiteB.resource")
	var test_suite_c := GdUnitTestResourceLoader.load_test_suite("res://addons/gdUnit4/test/ui/parts/resources/foo/ExampleTestSuiteC.resource")
	TEST_SUITE_A = test_suite_a.get_script().resource_path
	TEST_SUITE_B = test_suite_b.get_script().resource_path
	TEST_SUITE_C = test_suite_c.get_script().resource_path
	return Array([auto_free(test_suite_a), auto_free(test_suite_b), auto_free(test_suite_c)])


func mark_as_failure(inspector, test_cases :Array) -> void:
	var tree_root :TreeItem = inspector._tree_root
	assert_object(tree_root).is_not_null()
	# mark all test as failed
	for parent in tree_root.get_children():
		inspector.set_state_succeded(parent)
		for item in parent.get_children():
			if test_cases.has(item.get_text(0)):
				inspector.set_state_failed(parent)
				inspector.set_state_failed(item)
			else:
				inspector.set_state_succeded(item)
			item = item.get_next()
		parent = parent.get_next()

func get_item_state(parent :TreeItem, item_name :String) -> int:
	var item = _inspector._find_by_name(parent, item_name)
	return item.get_meta(_inspector.META_GDUNIT_STATE)

func test_collect_failures_and_errors() -> void:
	# mark some test as failed
	mark_as_failure(_inspector, ["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])
	
	assert_array(_inspector.collect_failures_and_errors())\
		.extract("get_text", [0])\
		.contains_exactly(["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])

func test_select_first_failure() -> void:
	# test initial nothing is selected
	assert_object(_inspector._tree.get_selected()).is_null()
	
	# we have no failures or errors
	_inspector.collect_failures_and_errors()
	_inspector.select_first_failure()
	assert_object(_inspector._tree.get_selected()).is_null()
	
	# add failures
	mark_as_failure(_inspector, ["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])
	_inspector.collect_failures_and_errors()
	# select first failure
	_inspector.select_first_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_aa")

func test_select_last_failure() -> void:
	# test initial nothing is selected
	assert_object(_inspector._tree.get_selected()).is_null()
	
	# we have no failures or errors
	_inspector.collect_failures_and_errors()
	_inspector.select_last_failure()
	assert_object(_inspector._tree.get_selected()).is_null()
	
	# add failures
	mark_as_failure(_inspector, ["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])
	_inspector.collect_failures_and_errors()
	# select last failure
	_inspector.select_last_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ce")


func test_clear_failures() -> void:
	assert_array(_inspector._current_failures).is_empty()
	
	mark_as_failure(_inspector, ["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])
	_inspector.collect_failures_and_errors()
	assert_array(_inspector._current_failures).is_not_empty()
	
	# clear it
	_inspector.clear_failures()
	assert_array(_inspector._current_failures).is_empty()

func test_select_next_failure() -> void:
	# test initial nothing is selected
	assert_object(_inspector._tree.get_selected()).is_null()
	
	# first time select next but no failure exists
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected()).is_null()
	
	# add failures
	mark_as_failure(_inspector, ["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])
	_inspector.collect_failures_and_errors()
	
	# first time select next than select first failure
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_aa")
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ad")
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_cb")
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_cc")
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ce")
	# if current last failure selected than select first as next
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_aa")
	_inspector.select_next_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ad")

func test_select_previous_failure() -> void:
	# test initial nothing is selected
	assert_object(_inspector._tree.get_selected()).is_null()
	
	# first time select previous but no failure exists
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected()).is_null()
	
	# add failures
	mark_as_failure(_inspector, ["test_aa", "test_ad", "test_cb", "test_cc", "test_ce"])
	_inspector.collect_failures_and_errors()
	
	# first time select previous than select last failure
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ce")
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_cc")
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_cb")
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ad")
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_aa")
	# if current first failure selected than select last as next
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_ce")
	_inspector.select_previous_failure()
	assert_str(_inspector._tree.get_selected().get_text(0)).is_equal("test_cc")

func test_find_item_for_test_suites() -> void:
	var suite_a: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_A)
	assert_str(suite_a.get_meta(_inspector.META_GDUNIT_NAME)).is_equal("ExampleTestSuiteA")
	
	var suite_b: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_B)
	assert_str(suite_b.get_meta(_inspector.META_GDUNIT_NAME)).is_equal("ExampleTestSuiteB")

func test_find_item_for_test_cases() -> void:
	var case_aa: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_A, "test_aa")
	assert_str(case_aa.get_meta(_inspector.META_GDUNIT_NAME)).is_equal("test_aa")
	
	var case_ce: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_C, "test_ce")
	assert_str(case_ce.get_meta(_inspector.META_GDUNIT_NAME)).is_equal("test_ce")

func test_suite_text_shows_amount_of_cases() -> void:
	var suite_a: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_A)
	assert_str(suite_a.get_text(0)).is_equal("(0/5) ExampleTestSuiteA")
	
	var suite_b: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_B)
	assert_str(suite_b.get_text(0)).is_equal("(0/3) ExampleTestSuiteB")

func test_suite_text_responds_to_test_case_events() -> void:
	var suite_a: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_A)
	
	var success_aa := GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_aa")
	_inspector._on_gdunit_event(success_aa)
	assert_str(suite_a.get_text(0)).is_equal("(1/5) ExampleTestSuiteA")
	
	var error_ad := GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_ad", {GdUnitEvent.ERRORS: true})
	_inspector._on_gdunit_event(error_ad)
	assert_str(suite_a.get_text(0)).is_equal("(1/5) ExampleTestSuiteA")
	
	var failure_ab := GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_ab", {GdUnitEvent.FAILED: true})
	_inspector._on_gdunit_event(failure_ab)
	assert_str(suite_a.get_text(0)).is_equal("(1/5) ExampleTestSuiteA")
	
	var skipped_ac := GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_ac", {GdUnitEvent.SKIPPED: true})
	_inspector._on_gdunit_event(skipped_ac)
	assert_str(suite_a.get_text(0)).is_equal("(1/5) ExampleTestSuiteA")
	
	var success_ae := GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_ae")
	_inspector._on_gdunit_event(success_ae)
	assert_str(suite_a.get_text(0)).is_equal("(2/5) ExampleTestSuiteA")

# test coverage for issue GD-117
func test_update_test_case_on_multiple_test_suite_with_same_name() -> void:
	# add a second test suite where has same name as TEST_SUITE_A
	var test_suite = auto_free(GdUnitTestResourceLoader.load_test_suite("res://addons/gdUnit4/test/ui/parts/resources/bar/ExampleTestSuiteA.resource"))
	var test_suite_aa_path = test_suite.get_script().resource_path
	_inspector.add_test_suite(toDto(test_suite))
	
	# verify the items exists checked the tree
	assert_str(TEST_SUITE_A).is_not_equal(test_suite_aa_path)
	var suite_a: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_A)
	var suite_aa: TreeItem = _inspector._find_item(_inspector._tree_root, test_suite_aa_path)
	assert_object(suite_a).is_not_same(suite_aa)
	assert_str(suite_a.get_meta(_inspector.META_RESOURCE_PATH)).is_equal(TEST_SUITE_A)
	assert_str(suite_aa.get_meta(_inspector.META_RESOURCE_PATH)).is_equal(test_suite_aa_path)
	
	# verify inital state
	assert_str(suite_a.get_text(0)).is_equal("(0/5) ExampleTestSuiteA")
	assert_int(get_item_state(suite_a, "test_aa")).is_equal(_inspector.STATE.INITIAL)
	assert_str(suite_aa.get_text(0)).is_equal("(0/5) ExampleTestSuiteA")
	
	# set test starting checked TEST_SUITE_A
	_inspector._on_gdunit_event(GdUnitEvent.new().test_before(TEST_SUITE_A, "ExampleTestSuiteA", "test_aa"))
	_inspector._on_gdunit_event(GdUnitEvent.new().test_before(TEST_SUITE_A, "ExampleTestSuiteA", "test_ab"))
	assert_str(suite_a.get_text(0)).is_equal("(0/5) ExampleTestSuiteA")
	assert_int(get_item_state(suite_a, "test_aa")).is_equal(_inspector.STATE.RUNNING)
	assert_int(get_item_state(suite_a, "test_ab")).is_equal(_inspector.STATE.RUNNING)
	# test test_suite_aa_path is not affected
	assert_str(suite_aa.get_text(0)).is_equal("(0/5) ExampleTestSuiteA")
	assert_int(get_item_state(suite_aa, "test_aa")).is_equal(_inspector.STATE.INITIAL)
	assert_int(get_item_state(suite_aa, "test_ab")).is_equal(_inspector.STATE.INITIAL)
	
	# finish the tests with success
	_inspector._on_gdunit_event(GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_aa"))
	_inspector._on_gdunit_event(GdUnitEvent.new().test_after(TEST_SUITE_A, "ExampleTestSuiteA", "test_ab"))
	
	# verify updated state checked TEST_SUITE_A
	assert_str(suite_a.get_text(0)).is_equal("(2/5) ExampleTestSuiteA")
	assert_int(get_item_state(suite_a, "test_aa")).is_equal(_inspector.STATE.SUCCESS)
	assert_int(get_item_state(suite_a, "test_ab")).is_equal(_inspector.STATE.SUCCESS)
	# test test_suite_aa_path is not affected
	assert_str(suite_aa.get_text(0)).is_equal("(0/5) ExampleTestSuiteA")
	assert_int(get_item_state(suite_aa, "test_aa")).is_equal(_inspector.STATE.INITIAL)
	assert_int(get_item_state(suite_aa, "test_ab")).is_equal(_inspector.STATE.INITIAL)


# Test coverage for issue GD-278: GdUnit Inspector: Test marks as passed if both warning and error
func test_update_icon_state() -> void:
	var TEST_SUITE_PATH = "res://addons/gdUnit4/test/core/resources/testsuites/TestSuiteFailAndOrpahnsDetected.resource"
	var TEST_SUITE_NAME = "TestSuiteFailAndOrpahnsDetected"
	var test_suite = auto_free(GdUnitTestResourceLoader.load_test_suite(TEST_SUITE_PATH))
	_inspector.add_test_suite(toDto(test_suite))
	
	var suite: TreeItem = _inspector._find_item(_inspector._tree_root, TEST_SUITE_PATH)
	
	# Verify the inital state
	assert_str(suite.get_text(0)).is_equal("(0/2) "+ TEST_SUITE_NAME)
	assert_str(suite.get_meta(_inspector.META_RESOURCE_PATH)).is_equal(TEST_SUITE_PATH)
	assert_int(get_item_state(_inspector._tree_root, TEST_SUITE_NAME)).is_equal(_inspector.STATE.INITIAL)
	assert_int(get_item_state(suite, "test_case1")).is_equal(_inspector.STATE.INITIAL)
	assert_int(get_item_state(suite, "test_case2")).is_equal(_inspector.STATE.INITIAL)
	
	# Set tests to running
	_inspector._on_gdunit_event(GdUnitEvent.new().test_before(TEST_SUITE_PATH, TEST_SUITE_NAME, "test_case1"))
	_inspector._on_gdunit_event(GdUnitEvent.new().test_before(TEST_SUITE_PATH, TEST_SUITE_NAME, "test_case2"))
	# Verify all items on state running.
	assert_str(suite.get_text(0)).is_equal("(0/2) " + TEST_SUITE_NAME)
	assert_int(get_item_state(suite, "test_case1")).is_equal(_inspector.STATE.RUNNING)
	assert_int(get_item_state(suite, "test_case2")).is_equal(_inspector.STATE.RUNNING)
	
	# Simulate test processed.
	# test_case1 succeeded
	_inspector._on_gdunit_event(GdUnitEvent.new().test_after(TEST_SUITE_PATH, TEST_SUITE_NAME, "test_case1"))
	# test_case2 is failing by an orphan warning and an failure
	_inspector._on_gdunit_event(GdUnitEvent.new()\
		.test_after(TEST_SUITE_PATH, TEST_SUITE_NAME, "test_case2", {GdUnitEvent.FAILED: true}))
	# We check whether a test event with a warning does not overwrite a higher object status, e.g. an error.
	_inspector._on_gdunit_event(GdUnitEvent.new()\
		.test_after(TEST_SUITE_PATH, TEST_SUITE_NAME, "test_case2", {GdUnitEvent.WARNINGS: true}))
	
	# Verify the final state
	assert_str(suite.get_text(0)).is_equal("(1/2) " + TEST_SUITE_NAME)
	assert_int(get_item_state(suite, "test_case1")).is_equal(_inspector.STATE.SUCCESS)
	assert_int(get_item_state(suite, "test_case2")).is_equal(_inspector.STATE.FAILED)
