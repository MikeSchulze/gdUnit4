@tool
extends VSplitContainer

signal run_testcase(test_suite_resource_path: String, test_case: String, test_param_index: int, run_debug: bool)
signal run_testsuite()
## Will be emitted when the test index counter is changed
signal test_counters_changed(index: int, total: int, state: GdUnitInspectorTreeConstants.STATE)

const CONTEXT_MENU_RUN_ID = 0
const CONTEXT_MENU_DEBUG_ID = 1
const CONTEXT_MENU_COLLAPSE_ALL = 3
const CONTEXT_MENU_EXPAND_ALL = 4


@onready var _tree: Tree = $Panel/Tree
@onready var _report_list: Node = $report/ScrollContainer/list
@onready var _report_template: RichTextLabel = $report/report_template
@onready var _context_menu: PopupMenu = $contextMenu
@onready var _discover_hint: Control = %discover_hint
@onready var _spinner: Button = %spinner

# loading tree icons
@onready var ICON_SPINNER := GdUnitUiTools.get_spinner()
@onready var ICON_FOLDER := GdUnitUiTools.get_icon("Folder")
# gdscript icons
@onready var ICON_GDSCRIPT_TEST_DEFAULT := GdUnitUiTools.get_icon("GDScript", Color.LIGHT_GRAY)
@onready var ICON_GDSCRIPT_TEST_SUCCESS := GdUnitUiTools.get_GDScript_icon("StatusSuccess", Color.DARK_GREEN)
@onready var ICON_GDSCRIPT_TEST_FLAKY := GdUnitUiTools.get_GDScript_icon("CheckBox", Color.GREEN_YELLOW)
@onready var ICON_GDSCRIPT_TEST_FAILED := GdUnitUiTools.get_GDScript_icon("StatusError", Color.SKY_BLUE)
@onready var ICON_GDSCRIPT_TEST_ERROR := GdUnitUiTools.get_GDScript_icon("StatusError", Color.DARK_RED)
@onready var ICON_GDSCRIPT_TEST_SUCCESS_ORPHAN := GdUnitUiTools.get_GDScript_icon("Unlinked", Color.DARK_GREEN)
@onready var ICON_GDSCRIPT_TEST_FAILED_ORPHAN := GdUnitUiTools.get_GDScript_icon("Unlinked", Color.SKY_BLUE)
@onready var ICON_GDSCRIPT_TEST_ERRORS_ORPHAN := GdUnitUiTools.get_GDScript_icon("Unlinked", Color.DARK_RED)
# csharp script icons
@onready var ICON_CSSCRIPT_TEST_DEFAULT := GdUnitUiTools.get_icon("CSharpScript", Color.LIGHT_GRAY)
@onready var ICON_CSSCRIPT_TEST_SUCCESS := GdUnitUiTools.get_CSharpScript_icon("StatusSuccess", Color.DARK_GREEN)
@onready var ICON_CSSCRIPT_TEST_FAILED := GdUnitUiTools.get_CSharpScript_icon("StatusError", Color.SKY_BLUE)
@onready var ICON_CSSCRIPT_TEST_ERROR := GdUnitUiTools.get_CSharpScript_icon("StatusError", Color.DARK_RED)
@onready var ICON_CSSCRIPT_TEST_SUCCESS_ORPHAN := GdUnitUiTools.get_CSharpScript_icon("Unlinked", Color.DARK_GREEN)
@onready var ICON_CSSCRIPT_TEST_FAILED_ORPHAN := GdUnitUiTools.get_CSharpScript_icon("Unlinked", Color.SKY_BLUE)
@onready var ICON_CSSCRIPT_TEST_ERRORS_ORPHAN := GdUnitUiTools.get_CSharpScript_icon("Unlinked", Color.DARK_RED)


enum GdUnitType {
	FOLDER,
	TEST_SUITE,
	TEST_CASE
}

const META_GDUNIT_ORIGINAL_INDEX = "gdunit_original_index"
const META_GDUNIT_ID := "gdUnit_id"
const META_GDUNIT_NAME := "gdUnit_name"
const META_GDUNIT_STATE := "gdUnit_state"
const META_GDUNIT_TYPE := "gdUnit_type"
const META_GDUNIT_TOTAL_TESTS := "gdUnit_suite_total_tests"
const META_GDUNIT_TEST_INDEX := "gdUnit_test_index"
const META_GDUNIT_SUCCESS_TESTS := "gdUnit_suite_success_tests"
const META_GDUNIT_REPORT := "gdUnit_report"
const META_GDUNIT_ORPHAN := "gdUnit_orphan"
const META_GDUNIT_EXECUTION_TIME := "gdUnit_execution_time"
const META_RESOURCE_PATH := "resource_path"
const META_LINE_NUMBER := "line_number"
const META_SCRIPT_PATH := "script_path"
const META_TEST_PARAM_INDEX := "test_param_index"
const STATE = GdUnitInspectorTreeConstants.STATE


var _tree_root: TreeItem
var _item_hash := Dictionary()
var _tree_view_mode_flat := GdUnitSettings.get_inspector_tree_view_mode() == GdUnitInspectorTreeConstants.TREE_VIEW_MODE.FLAT


func _build_cache_key(resource_path: String, test_name: String) -> Array:
	return [resource_path, test_name]


func find_tree_item(parent: TreeItem, item_name: String) -> TreeItem:
	for child in parent.get_children():
		if child.get_meta(META_GDUNIT_NAME) == item_name:
			return child
	return null


func get_tree_item(resource_path: String, item_name: String) -> TreeItem:
	var key := _build_cache_key(resource_path, item_name)
	return _item_hash.get(key, null)


func remove_tree_item(resource_path: String, item_name: String) -> bool:
	var key := _build_cache_key(resource_path, item_name)
	var item :TreeItem= _item_hash.get(key, null)
	if item:
		item.get_parent().remove_child(item)
		item.free()
		return _item_hash.erase(key)
	return false


func add_tree_item_to_cache(resource_path: String, test_name: String, item: TreeItem) -> void:
	var key := _build_cache_key(resource_path, test_name)
	_item_hash[key] = item


func clear_tree_item_cache() -> void:
	_item_hash.clear()


func _find_by_resource_path(current: TreeItem, resource_path: String) -> TreeItem:
	for item in current.get_children():
		if item.get_meta(META_RESOURCE_PATH) == resource_path:
			return item
	return null


func _find_first_item_by_state(parent: TreeItem, item_state: STATE, reverse := false) -> TreeItem:
	var itmes := parent.get_children()
	if reverse:
		itmes.reverse()
	for item in itmes:
		if is_test_case(item) and (is_item_state(item, item_state)):
			return item
		var failure_item := _find_first_item_by_state(item, item_state, reverse)
		if failure_item != null:
			return failure_item
	return null


func _find_last_item_by_state(parent: TreeItem, item_state: STATE) -> TreeItem:
	return _find_first_item_by_state(parent, item_state, true)


func _find_item_by_state(current: TreeItem, item_state: STATE, prev := false) -> TreeItem:
	var next := current.get_prev_in_tree() if prev else current.get_next_in_tree()
	if next == null or next == _tree_root:
		return null
	if is_test_case(next) and is_item_state(next, item_state):
		return next
	return _find_item_by_state(next, item_state, prev)


func is_item_state(item: TreeItem, item_state: STATE) -> bool:
	return item.has_meta(META_GDUNIT_STATE) and item.get_meta(META_GDUNIT_STATE) == item_state


func is_state_running(item: TreeItem) -> bool:
	return is_item_state(item, STATE.RUNNING)


func is_state_success(item: TreeItem) -> bool:
	return is_item_state(item, STATE.SUCCESS)


func is_state_warning(item: TreeItem) -> bool:
	return is_item_state(item, STATE.WARNING)


func is_state_failed(item: TreeItem) -> bool:
	return is_item_state(item, STATE.FAILED)


func is_state_error(item: TreeItem) -> bool:
	return is_item_state(item, STATE.ERROR) or is_item_state(item, STATE.ABORDED)


func is_item_state_orphan(item: TreeItem) -> bool:
	return item.has_meta(META_GDUNIT_ORPHAN)


func is_test_suite(item: TreeItem) -> bool:
	return item.has_meta(META_GDUNIT_TYPE) and item.get_meta(META_GDUNIT_TYPE) == GdUnitType.TEST_SUITE


func is_test_case(item: TreeItem) -> bool:
	return item.has_meta(META_GDUNIT_TYPE) and item.get_meta(META_GDUNIT_TYPE) == GdUnitType.TEST_CASE


func is_folder(item: TreeItem) -> bool:
	return item.has_meta(META_GDUNIT_TYPE) and item.get_meta(META_GDUNIT_TYPE) == GdUnitType.FOLDER


@warning_ignore("return_value_discarded")
func _ready() -> void:
	_context_menu.set_item_icon(CONTEXT_MENU_RUN_ID, GdUnitUiTools.get_icon("Play"))
	_context_menu.set_item_icon(CONTEXT_MENU_DEBUG_ID, GdUnitUiTools.get_icon("PlayStart"))
	_context_menu.set_item_icon(CONTEXT_MENU_EXPAND_ALL, GdUnitUiTools.get_icon("ExpandTree"))
	_context_menu.set_item_icon(CONTEXT_MENU_COLLAPSE_ALL, GdUnitUiTools.get_icon("CollapseTree"))
	# do colorize the icons
	#for index in _context_menu.item_count:
	#	_context_menu.set_item_icon_modulate(index, Color.MEDIUM_PURPLE)

	_spinner.icon = GdUnitUiTools.get_spinner()
	init_tree()
	GdUnitSignals.instance().gdunit_settings_changed.connect(_on_settings_changed)
	GdUnitSignals.instance().gdunit_event.connect(_on_gdunit_event)
	GdUnitSignals.instance().gdunit_test_discovered.connect(on_test_case_discovered)
	var command_handler := GdUnitCommandHandler.instance()
	command_handler.gdunit_runner_start.connect(_on_gdunit_runner_start)
	command_handler.gdunit_runner_stop.connect(_on_gdunit_runner_stop)


# we need current to manually redraw bacause of the animation bug
# https://github.com/godotengine/godot/issues/69330
func _process(_delta: float) -> void:
	if is_visible_in_tree():
		queue_redraw()


func init_tree() -> void:
	cleanup_tree()
	_tree.set_hide_root(true)
	_tree.ensure_cursor_is_visible()
	_tree.set_allow_reselect(true)
	_tree.set_allow_rmb_select(true)
	_tree.set_columns(2)
	_tree.set_column_clip_content(0, true)
	_tree.set_column_expand_ratio(0, 1)
	_tree.set_column_custom_minimum_width(0, 240)
	_tree.set_column_expand_ratio(1, 0)
	_tree.set_column_custom_minimum_width(1, 100)
	_tree_root = _tree.create_item()
	_tree_root.set_text(0, "tree_root")
	_tree_root.set_meta(META_GDUNIT_NAME, "tree_root")
	_tree_root.set_meta(META_GDUNIT_TOTAL_TESTS, 0)
	_tree_root.set_meta(META_GDUNIT_TEST_INDEX, 0)
	_tree_root.set_meta(META_GDUNIT_STATE, STATE.INITIAL)
	_tree_root.set_meta(META_GDUNIT_SUCCESS_TESTS, 0)
	# fix tree icon scaling
	var scale_factor := EditorInterface.get_editor_scale() if Engine.is_editor_hint() else 1.0
	_tree.set("theme_override_constants/icon_max_width", 16 * scale_factor)


func cleanup_tree() -> void:
	clear_reports()
	clear_tree_item_cache()
	if not _tree_root:
		return
	_free_recursive()
	_tree.clear()


func _free_recursive(items:=_tree_root.get_children()) -> void:
	for item in items:
		_free_recursive(item.get_children())
		item.call_deferred("free")


func sort_tree_items(parent :TreeItem) -> void:
	parent.visible = false
	var items := parent.get_children()

	# do sort by selected sort mode
	match GdUnitSettings.get_inspector_tree_sort_mode():
		GdUnitInspectorTreeConstants.SORT_MODE.UNSORTED:
			items.sort_custom(sort_items_by_original_index)

		GdUnitInspectorTreeConstants.SORT_MODE.NAME_ASCENDING:
			items.sort_custom(sort_items_by_name.bind(true))

		GdUnitInspectorTreeConstants.SORT_MODE.NAME_DESCENDING:
			items.sort_custom(sort_items_by_name.bind(false))

		GdUnitInspectorTreeConstants.SORT_MODE.EXECUTION_TIME:
			items.sort_custom(sort_items_by_execution_time)

	for item in items:
		parent.remove_child(item)
		parent.add_child(item)
		if item.get_child_count() > 0:
			sort_tree_items(item)
	parent.visible = true
	_tree.queue_redraw()


func sort_items_by_name(a: TreeItem, b: TreeItem, ascending: bool) -> bool:
	var type_a: GdUnitType = a.get_meta(META_GDUNIT_TYPE)
	var type_b: GdUnitType = b.get_meta(META_GDUNIT_TYPE)
	 # Compare types first
	if type_a != type_b:
		return type_a == GdUnitType.FOLDER
	var name_a :String = a.get_meta(META_GDUNIT_NAME)
	var name_b :String = b.get_meta(META_GDUNIT_NAME)
	return name_a.naturalnocasecmp_to(name_b) < 0 if ascending else name_a.naturalnocasecmp_to(name_b) > 0


func sort_items_by_execution_time(a: TreeItem, b: TreeItem) -> bool:
	var type_a: GdUnitType = a.get_meta(META_GDUNIT_TYPE)
	var type_b: GdUnitType = b.get_meta(META_GDUNIT_TYPE)
	 # Compare types first
	if type_a != type_b:
		return type_a == GdUnitType.FOLDER
	var execution_time_a :int = a.get_meta(META_GDUNIT_EXECUTION_TIME)
	var execution_time_b :int = b.get_meta(META_GDUNIT_EXECUTION_TIME)
	# if has same execution time sort by name
	if execution_time_a == execution_time_b:
		var name_a :String = a.get_meta(META_GDUNIT_NAME)
		var name_b :String = b.get_meta(META_GDUNIT_NAME)
		return name_a.naturalnocasecmp_to(name_b) > 0
	return execution_time_a > execution_time_b


func sort_items_by_original_index(a: TreeItem, b: TreeItem) -> bool:
	var type_a: GdUnitType = a.get_meta(META_GDUNIT_TYPE)
	var type_b: GdUnitType = b.get_meta(META_GDUNIT_TYPE)
	if type_a != type_b:
		return type_a == GdUnitType.FOLDER
	var index_a :int = a.get_meta(META_GDUNIT_ORIGINAL_INDEX)
	var index_b :int = b.get_meta(META_GDUNIT_ORIGINAL_INDEX)
	return index_a < index_b


func reset_tree_state(parent: TreeItem) -> void:
	if parent == _tree_root:
		_tree_root.set_meta(META_GDUNIT_TEST_INDEX, 0)
		_tree_root.set_meta(META_GDUNIT_STATE, STATE.INITIAL)
		test_counters_changed.emit(0, 0, STATE.INITIAL)

	for item in parent.get_children():
		set_state_initial(item)
		reset_tree_state(item)


func select_item(item: TreeItem) -> TreeItem:
	if item != null:
		# enshure the parent is collapsed
		do_collapse_parent(item)
		item.select(0)
		_tree.ensure_cursor_is_visible()
		_tree.scroll_to_item(item, true)
	return item


func do_collapse_parent(item: TreeItem) -> void:
	if item != null:
		item.collapsed = false
		do_collapse_parent(item.get_parent())


func do_collapse_all(collapse: bool, parent := _tree_root) -> void:
	for item in parent.get_children():
		item.collapsed = collapse
		if not collapse:
			do_collapse_all(collapse, item)


func set_state_initial(item: TreeItem) -> void:
	item.set_text(0, str(item.get_meta(META_GDUNIT_NAME)))
	item.set_custom_color(0, Color.LIGHT_GRAY)
	item.set_tooltip_text(0, "")
	item.set_text_overrun_behavior(0, TextServer.OVERRUN_TRIM_CHAR)
	item.set_expand_right(0, true)

	item.set_custom_color(1, Color.LIGHT_GRAY)
	item.set_text(1, "")
	item.set_expand_right(1, true)
	item.set_tooltip_text(1, "")

	item.set_meta(META_GDUNIT_STATE, STATE.INITIAL)
	item.set_meta(META_GDUNIT_SUCCESS_TESTS, 0)
	item.set_meta(META_GDUNIT_EXECUTION_TIME, 0)
	if item.has_meta(META_GDUNIT_TOTAL_TESTS) and item.get_meta(META_GDUNIT_TOTAL_TESTS) > 0:
		item.set_text(0, "(0/%d) %s" % [item.get_meta(META_GDUNIT_TOTAL_TESTS), item.get_meta(META_GDUNIT_NAME)])
	item.remove_meta(META_GDUNIT_REPORT)
	item.remove_meta(META_GDUNIT_ORPHAN)

	set_item_icon_by_state(item)


func set_state_running(item: TreeItem) -> void:
	if is_state_running(item):
		return
	item.set_custom_color(0, Color.DARK_GREEN)
	item.set_custom_color(1, Color.DARK_GREEN)
	item.set_icon(0, ICON_SPINNER)
	item.set_meta(META_GDUNIT_STATE, STATE.RUNNING)
	item.collapsed = false
	var parent := item.get_parent()
	if parent != _tree_root:
		set_state_running(parent)
	# force scrolling to current test case
	@warning_ignore("return_value_discarded")
	select_item(item)


func set_state_succeded(item: TreeItem) -> void:
	item.set_custom_color(0, Color.GREEN)
	item.set_custom_color(1, Color.GREEN)
	item.set_meta(META_GDUNIT_STATE, STATE.SUCCESS)
	item.collapsed = GdUnitSettings.is_inspector_node_collapse()
	set_item_icon_by_state(item)


func set_state_flaky(item: TreeItem, event: GdUnitEvent) -> void:
	# Do not overwrite higher states
	if is_state_error(item):
		return
	var retry_count := event.statistic(GdUnitEvent.RETRY_COUNT)
	item.set_meta(META_GDUNIT_STATE, STATE.FLAKY)
	if retry_count > 1:
		var item_text: String = item.get_meta(META_GDUNIT_NAME)
		if item.has_meta(META_GDUNIT_TOTAL_TESTS):
			var success_count: int = item.get_meta(META_GDUNIT_SUCCESS_TESTS)
			item_text = "(%d/%d) %s" % [success_count, item.get_meta(META_GDUNIT_TOTAL_TESTS), item.get_meta(META_GDUNIT_NAME)]
		item.set_text(0, "%s (%s retries)" % [item_text, retry_count])
	item.set_custom_color(0, Color.GREEN_YELLOW)
	item.set_custom_color(1, Color.GREEN_YELLOW)
	item.collapsed = false
	set_item_icon_by_state(item)


func set_state_skipped(item: TreeItem) -> void:
	item.set_meta(META_GDUNIT_STATE, STATE.SKIPPED)
	item.set_text(1, "(skipped)")
	item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	item.set_custom_color(0, Color.DARK_GRAY)
	item.set_custom_color(1, Color.DARK_GRAY)
	item.collapsed = false
	set_item_icon_by_state(item)


func set_state_warnings(item: TreeItem) -> void:
	# Do not overwrite higher states
	if is_state_error(item) or is_state_failed(item):
		return
	item.set_meta(META_GDUNIT_STATE, STATE.WARNING)
	item.set_custom_color(0, Color.YELLOW)
	item.set_custom_color(1, Color.YELLOW)
	item.collapsed = false
	set_item_icon_by_state(item)


func set_state_failed(item: TreeItem, event: GdUnitEvent) -> void:
	# Do not overwrite higher states
	if is_state_error(item):
		return
	var retry_count := event.statistic(GdUnitEvent.RETRY_COUNT)
	if retry_count > 1:
		var item_text: String = item.get_meta(META_GDUNIT_NAME)
		if item.has_meta(META_GDUNIT_TOTAL_TESTS):
			var success_count: int = item.get_meta(META_GDUNIT_SUCCESS_TESTS)
			item_text = "(%d/%d) %s" % [success_count, item.get_meta(META_GDUNIT_TOTAL_TESTS), item.get_meta(META_GDUNIT_NAME)]
		item.set_text(0, "%s (%s retries)" % [item_text, retry_count])
	item.set_meta(META_GDUNIT_STATE, STATE.FAILED)
	item.set_custom_color(0, Color.LIGHT_BLUE)
	item.set_custom_color(1, Color.LIGHT_BLUE)
	item.collapsed = false
	set_item_icon_by_state(item)


func set_state_error(item: TreeItem) -> void:
	item.set_meta(META_GDUNIT_STATE, STATE.ERROR)
	item.set_custom_color(0, Color.ORANGE_RED)
	item.set_custom_color(1, Color.ORANGE_RED)
	set_item_icon_by_state(item)
	item.collapsed = false


func set_state_aborted(item: TreeItem) -> void:
	item.set_meta(META_GDUNIT_STATE, STATE.ABORDED)
	item.set_custom_color(0, Color.ORANGE_RED)
	item.set_custom_color(1, Color.ORANGE_RED)
	item.clear_custom_bg_color(0)
	item.set_text(1, "(aborted)")
	item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	set_item_icon_by_state(item)
	item.collapsed = false


func set_state_orphan(item: TreeItem, event: GdUnitEvent) -> void:
	var orphan_count := event.statistic(GdUnitEvent.ORPHAN_NODES)
	if orphan_count == 0:
		return
	if item.has_meta(META_GDUNIT_ORPHAN):
		orphan_count += item.get_meta(META_GDUNIT_ORPHAN)
	item.set_meta(META_GDUNIT_ORPHAN, orphan_count)
	if item.get_meta(META_GDUNIT_STATE) != STATE.FAILED:
		item.set_custom_color(0, Color.YELLOW)
		item.set_custom_color(1, Color.YELLOW)
	item.set_tooltip_text(0, "Total <%d> orphan nodes detected." % orphan_count)
	set_item_icon_by_state(item)


func update_state(item: TreeItem, event: GdUnitEvent, add_reports := true) -> void:
	# we do not show the root
	if item == null:
		return

	if event.is_success() and event.is_flaky():
		set_state_flaky(item, event)
	elif event.is_success():
		set_state_succeded(item)
	elif event.is_skipped():
		set_state_skipped(item)
	elif event.is_error():
		set_state_error(item)
	elif event.is_failed():
		set_state_failed(item, event)
	elif event.is_warning():
		set_state_warnings(item)
	if add_reports:
		for report in event.reports():
			add_report(item, report)
	set_state_orphan(item, event)

	update_state(item.get_parent(), event, false)


func add_report(item: TreeItem, report: GdUnitReport) -> void:
	var reports: Array[GdUnitReport] = []
	if item.has_meta(META_GDUNIT_REPORT):
		reports = get_item_reports(item)
	reports.append(report)
	item.set_meta(META_GDUNIT_REPORT, reports)


func abort_running(items:=_tree_root.get_children()) -> void:
	for item in items:
		if is_state_running(item):
			set_state_aborted(item)
			abort_running(item.get_children())


func select_first_failure() -> TreeItem:
	return select_item(_find_first_item_by_state(_tree_root, STATE.FAILED))


func _on_select_next_item_by_state(item_state: int) -> TreeItem:
	var current_selected := _tree.get_selected()
	# If nothing is selected, the first error is selected or the next one in the vicinity of the current selection is found
	current_selected = _find_first_item_by_state(_tree_root, item_state) if current_selected == null else _find_item_by_state(current_selected, item_state)
	# If no next failure found, then we try to select first
	if current_selected == null:
		current_selected = _find_first_item_by_state(_tree_root, item_state)
	return select_item(current_selected)


func _on_select_previous_item_by_state(item_state: int) -> TreeItem:
	var current_selected := _tree.get_selected()
	# If nothing is selected, the first error is selected or the next one in the vicinity of the current selection is found
	current_selected = _find_last_item_by_state(_tree_root, item_state) if current_selected == null else _find_item_by_state(current_selected, item_state, true)
	# If no next failure found, then we try to select first last
	if current_selected == null:
		current_selected = _find_last_item_by_state(_tree_root, item_state)
	return select_item(current_selected)


func select_first_orphan() -> void:
	for parent in _tree_root.get_children():
		if not is_state_success(parent):
			for item in parent.get_children():
				if is_item_state_orphan(item):
					parent.set_collapsed(false)
					@warning_ignore("return_value_discarded")
					select_item(item)
					return


func clear_reports() -> void:
	for child in _report_list.get_children():
		_report_list.remove_child(child)
		child.queue_free()


func show_failed_report(selected_item: TreeItem) -> void:
	clear_reports()
	if selected_item == null or not selected_item.has_meta(META_GDUNIT_REPORT):
		return
	# add new reports
	for report in get_item_reports(selected_item):
		var reportNode: RichTextLabel = _report_template.duplicate()
		_report_list.add_child(reportNode)
		reportNode.append_text(report.to_string())
		reportNode.visible = true


func update_test_suite(event: GdUnitEvent) -> void:
	var item := get_tree_item(extract_resource_path(event), event.suite_name())
	if not item:
		push_error("Internal Error: Can't find test suite %s" % event.suite_name())
		return
	if event.type() == GdUnitEvent.TESTSUITE_BEFORE:
		set_state_running(item)
		return
	if event.type() == GdUnitEvent.TESTSUITE_AFTER:
		update_item_elapsed_time_counter(item, event.elapsed_time())
		update_state(item, event)
		update_progress_counters(item, 23)



func update_test_case(event: GdUnitEvent) -> void:
	var item := get_tree_item(extract_resource_path(event), event.test_name())
	if not item:
		push_error("Internal Error: Can't find test case %s:%s" % [event.suite_name(), event.test_name()])
		return
	if event.type() == GdUnitEvent.TESTCASE_BEFORE:
		set_state_running(item)
		return

	if event.type() == GdUnitEvent.TESTCASE_AFTER:
		update_item_elapsed_time_counter(item, event.elapsed_time())
		if event.is_success() or event.is_warning():
			update_item_processed_counter(item)
		update_state(item, event)
		update_progress_counters(item, event.retry_count())



func create_item(parent: TreeItem, test: GdUnitTestCase, item_name: String, type: GdUnitType) -> TreeItem:
	var script_path := ProjectSettings.localize_path(test.source_file)
	var item := _tree.create_item(parent)
	item.collapsed = true
	item.set_meta(META_GDUNIT_ORIGINAL_INDEX, item.get_index())
	item.set_text(0, item_name)
	item.set_meta(META_GDUNIT_ID, test.guid)
	item.set_meta(META_GDUNIT_NAME, item_name)
	item.set_meta(META_GDUNIT_TYPE, type)
	# for folder items we need to get the base path
	var resource_path := test.source_file if type != GdUnitType.FOLDER else test.source_file.get_base_dir()
	item.set_meta(META_RESOURCE_PATH, resource_path)
	item.set_meta(META_SCRIPT_PATH, script_path)
	set_state_initial(item)
	update_item_total_counter(item)
	return item


func set_item_icon_by_state(item :TreeItem) -> void:
	if item == _tree_root:
		return
	var resource_path :String = item.get_meta(META_RESOURCE_PATH)
	var state :STATE = item.get_meta(META_GDUNIT_STATE)
	var is_orphan := is_item_state_orphan(item)
	item.set_icon(0, get_icon_by_file_type(resource_path, state, is_orphan))
	if item.get_meta(META_GDUNIT_TYPE) == GdUnitType.FOLDER:
		item.set_icon_modulate(0, Color.SKY_BLUE)


func update_item_total_counter(item: TreeItem) -> void:
	if item == null:
		return

	var child_count := get_total_child_count(item)
	if child_count > 0:
		item.set_meta(META_GDUNIT_TOTAL_TESTS, child_count)
		item.set_text(0, "(0/%d) %s" % [child_count, item.get_meta(META_GDUNIT_NAME)])

	if item == _tree_root:
		var index: int = item.get_meta(META_GDUNIT_TEST_INDEX)
		var total_test: int = item.get_meta(META_GDUNIT_TOTAL_TESTS)
		var state: STATE = item.get_meta(META_GDUNIT_STATE)
		test_counters_changed.emit(index, total_test, state)

	update_item_total_counter(item.get_parent())


func get_total_child_count(item: TreeItem) -> int:
	var total_count := 0
	for child in item.get_children():
		total_count += child.get_meta(META_GDUNIT_TOTAL_TESTS) if child.has_meta(META_GDUNIT_TOTAL_TESTS) else 1
	return total_count


func update_item_processed_counter(item: TreeItem) -> void:
	if item == _tree_root:
		return

	var success_count: int = item.get_meta(META_GDUNIT_SUCCESS_TESTS) + 1
	item.set_meta(META_GDUNIT_SUCCESS_TESTS, success_count)
	if item.has_meta(META_GDUNIT_TOTAL_TESTS):
		item.set_text(0, "(%d/%d) %s" % [success_count, item.get_meta(META_GDUNIT_TOTAL_TESTS), item.get_meta(META_GDUNIT_NAME)])

	update_item_processed_counter(item.get_parent())


func update_progress_counters(item: TreeItem, rety_count: int) -> void:
	var index: int = _tree_root.get_meta(META_GDUNIT_TEST_INDEX)
	var total_test: int = _tree_root.get_meta(META_GDUNIT_TOTAL_TESTS)
	# We only increment the index counter once for a test
	if  rety_count <= 1:
		index += 1

	var state: STATE = item.get_meta(META_GDUNIT_STATE)
	test_counters_changed.emit(index, total_test, state)
	_tree_root.set_meta(META_GDUNIT_TEST_INDEX, index)


func update_item_elapsed_time_counter(item: TreeItem, time: int) -> void:
	item.set_text(1, "%s" % LocalTime.elapsed(time))
	item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	item.set_meta(META_GDUNIT_EXECUTION_TIME, time)

	var parent := item.get_parent()
	if parent == _tree_root:
		return
	var elapsed_time :int = parent.get_meta(META_GDUNIT_EXECUTION_TIME) + time
	var type :GdUnitType = item.get_meta(META_GDUNIT_TYPE)
	match type:
		GdUnitType.TEST_CASE:
			return
		GdUnitType.TEST_SUITE:
			update_item_elapsed_time_counter(parent, elapsed_time)
		#GdUnitType.FOLDER:
		#	update_item_elapsed_time_counter(parent, elapsed_time)


func get_icon_by_file_type(path: String, state: STATE, orphans: bool) -> Texture2D:
	if path.get_extension() == "gd":
		match state:
			STATE.INITIAL:
				return ICON_GDSCRIPT_TEST_DEFAULT
			STATE.SUCCESS:
				return ICON_GDSCRIPT_TEST_SUCCESS_ORPHAN if orphans else ICON_GDSCRIPT_TEST_SUCCESS
			STATE.ERROR:
				return ICON_GDSCRIPT_TEST_ERRORS_ORPHAN if orphans else ICON_GDSCRIPT_TEST_ERROR
			STATE.FAILED:
				return ICON_GDSCRIPT_TEST_FAILED_ORPHAN if orphans else ICON_GDSCRIPT_TEST_FAILED
			STATE.WARNING:
				return ICON_GDSCRIPT_TEST_SUCCESS_ORPHAN if orphans else ICON_GDSCRIPT_TEST_DEFAULT
			STATE.FLAKY:
				return ICON_GDSCRIPT_TEST_SUCCESS_ORPHAN if orphans else ICON_GDSCRIPT_TEST_FLAKY
			_:
				return ICON_GDSCRIPT_TEST_DEFAULT
	if path.get_extension() == "cs":
		match state:
			STATE.INITIAL:
				return ICON_CSSCRIPT_TEST_DEFAULT
			STATE.SUCCESS:
				return ICON_CSSCRIPT_TEST_SUCCESS_ORPHAN if orphans else ICON_CSSCRIPT_TEST_SUCCESS
			STATE.ERROR:
				return ICON_CSSCRIPT_TEST_ERRORS_ORPHAN if orphans else ICON_CSSCRIPT_TEST_ERROR
			STATE.FAILED:
				return ICON_CSSCRIPT_TEST_FAILED_ORPHAN if orphans else ICON_CSSCRIPT_TEST_FAILED
			STATE.WARNING:
				return ICON_CSSCRIPT_TEST_SUCCESS_ORPHAN if orphans else ICON_CSSCRIPT_TEST_DEFAULT
			_:
				return ICON_CSSCRIPT_TEST_DEFAULT
	match state:
		STATE.INITIAL:
			return ICON_FOLDER
		STATE.ERROR:
			return ICON_FOLDER
		STATE.FAILED:
			return ICON_FOLDER
		_:
			return ICON_FOLDER


func discover_test_suite_added(event: GdUnitEventTestDiscoverTestSuiteAdded) -> void:
	# Check first if the test suite already exists
	var item := get_tree_item(extract_resource_path(event), event.suite_name())
	if item != null:
		return
	# Otherwise create it
	prints("Discovered test suite added: '%s' on %s" % [event.suite_name(), extract_resource_path(event)])
	#do_add_test_suite(event.suite_dto())


func discover_test_added(event: GdUnitEventTestDiscoverTestAdded) -> void:
	# check if the test already exists
	var test_name := event.test_case_dto().name()
	var resource_path := extract_resource_path(event)
	var item := get_tree_item(resource_path, test_name)
	if item != null:
		return

	item = get_tree_item(resource_path, event.suite_name())
	if not item:
		push_error("Internal Error: Can't find test suite %s:%s" % [event.suite_name(), resource_path])
		return
	prints("Discovered test added: '%s' on %s" % [event.test_name(), resource_path])
	# update test case count
	#init_item_counter(item)
	# add new discovered test
	#add_test(item, event.test_case_dto())


func discover_test_removed(event: GdUnitEventTestDiscoverTestRemoved) -> void:
	var resource_path := extract_resource_path(event)
	prints("Discovered test removed: '%s' on %s" % [event.test_name(), resource_path])
	var item := get_tree_item(resource_path, event.test_name())
	if not item:
		push_error("Internal Error: Can't find test suite %s:%s" % [event.suite_name(), resource_path])
		return
	# update test case count on test suite
	var parent := item.get_parent()
	update_item_total_counter(parent)
	# finally remove the test
	@warning_ignore("return_value_discarded")
	remove_tree_item(resource_path, event.test_name())


func add_test_case(test_case: GdUnitTestCase) -> void:
	var test_root_folder := GdUnitSettings.test_root_folder().replace("res://", "")
	var fully_qualified_name := test_case.fully_qualified_name.trim_prefix(test_root_folder).trim_suffix(test_case.display_name)
	var parts := fully_qualified_name.split(".", false)
	parts.append(test_case.display_name)
	# skip tree structure until test root folder
	var index := parts.find(test_root_folder)
	if index != -1:
		parts = parts.slice(index+1)

	var parent := _tree_root
	for item_name in parts:
		var next := find_tree_item(parent, item_name)
		if next != null:
			parent = next
			continue
		if item_name.begins_with(test_case.test_name):
			var is_test_group := item_name == test_case.test_name
			next = create_item(parent, test_case, item_name, GdUnitType.TEST_CASE)
			next.set_meta(META_LINE_NUMBER, test_case.line_number)
			next.set_meta(META_TEST_PARAM_INDEX, -1 if is_test_group else test_case.attribute_index)
			add_tree_item_to_cache(test_case.source_file, item_name, next)
		elif item_name == test_case.suite_name:
			next = create_item(parent, test_case, item_name, GdUnitType.TEST_SUITE)
			next.set_meta(META_LINE_NUMBER, 0)
			add_tree_item_to_cache(test_case.source_file, item_name, next)
		else:
			next = create_item(parent, test_case, item_name, GdUnitType.FOLDER)

		parent = next


@warning_ignore("unused_parameter")
func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
	add_test_case(test_case)


func get_item_reports(item: TreeItem) -> Array[GdUnitReport]:
	return item.get_meta(META_GDUNIT_REPORT)


func _dump_tree_as_json(dump_name: String) -> void:
	var dict := _to_json(_tree_root)
	var file := FileAccess.open("res://%s.json" % dump_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(dict, "\t"))


func _to_json(parent :TreeItem) -> Dictionary:
	var item_as_dict := GdObjects.obj2dict(parent)
	item_as_dict["TreeItem"]["childs"] = parent.get_children().map(func(item: TreeItem) -> Dictionary:
			return _to_json(item))
	return item_as_dict


func extract_resource_path(event: GdUnitEvent) -> String:
	return ProjectSettings.localize_path(event.resource_path())


################################################################################
# Tree signal receiver
################################################################################
func _on_tree_item_mouse_selected(mouse_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		_context_menu.position = get_screen_position() + mouse_position
		_context_menu.popup()


func _on_run_pressed(run_debug: bool) -> void:
	_context_menu.hide()
	var item: = _tree.get_selected()
	if item == null:
		print_rich("[color=GOLDENROD]Abort Testrun, no test suite selected![/color]")
		return
	if item.get_meta(META_GDUNIT_TYPE) == GdUnitType.TEST_SUITE or item.get_meta(META_GDUNIT_TYPE) == GdUnitType.FOLDER:
		var resource_path: String = item.get_meta(META_RESOURCE_PATH)
		run_testsuite.emit([resource_path], run_debug)
		return

	var test_suite_resource_path: String = item.get_meta(META_RESOURCE_PATH)
	var test_case: String = item.get_meta(META_GDUNIT_NAME)
	# handle parameterized test selection
	var test_param_index: int = item.get_meta(META_TEST_PARAM_INDEX)
	if test_param_index != -1:
		test_case = item.get_parent().get_meta(META_GDUNIT_NAME)
	run_testcase.emit(test_suite_resource_path, test_case, test_param_index, run_debug)


func _on_Tree_item_selected() -> void:
	# only show report checked manual item selection
	# we need to check the run mode here otherwise it will be called every selection
	if not _context_menu.is_item_disabled(CONTEXT_MENU_RUN_ID):
		var selected_item: TreeItem = _tree.get_selected()
		show_failed_report(selected_item)


# Opens the test suite
func _on_Tree_item_activated() -> void:
	var selected_item := _tree.get_selected()
	if selected_item != null and selected_item.has_meta(META_LINE_NUMBER):
		var script_path: String = (
			selected_item.get_meta(META_RESOURCE_PATH) if is_test_suite(selected_item)
			else selected_item.get_meta(META_SCRIPT_PATH)
		)
		var line_number: int = selected_item.get_meta(META_LINE_NUMBER)
		var resource: Script = load(script_path)

		if selected_item.has_meta(META_GDUNIT_REPORT):
			var reports := get_item_reports(selected_item)
			var report_line_number := reports[0].line_number()
			# if number -1 we use original stored line number of the test case
			# in non debug mode the line number is not available
			if report_line_number != -1:
				line_number = report_line_number

		EditorInterface.get_file_system_dock().navigate_to_path(script_path)
		EditorInterface.edit_script(resource, line_number)
	elif selected_item.get_meta(META_GDUNIT_TYPE) == GdUnitType.FOLDER:
		# Toggle collapse if dir
		selected_item.collapsed = not selected_item.collapsed


################################################################################
# external signal receiver
################################################################################
func _on_gdunit_runner_start() -> void:
	reset_tree_state(_tree_root)
	_context_menu.set_item_disabled(CONTEXT_MENU_RUN_ID, true)
	_context_menu.set_item_disabled(CONTEXT_MENU_DEBUG_ID, true)
	clear_reports()


func _on_gdunit_runner_stop(_client_id: int) -> void:
	_context_menu.set_item_disabled(CONTEXT_MENU_RUN_ID, false)
	_context_menu.set_item_disabled(CONTEXT_MENU_DEBUG_ID, false)
	abort_running()
	sort_tree_items(_tree_root)
	# wait until the tree redraw
	await get_tree().process_frame
	@warning_ignore("return_value_discarded")
	select_first_failure()


func _on_gdunit_event(event: GdUnitEvent) -> void:
	match event.type():
		GdUnitEvent.DISCOVER_START:
			_tree_root.visible = false
			_discover_hint.visible = true
			init_tree()

		GdUnitEvent.DISCOVER_END:
			sort_tree_items(_tree_root)
			_discover_hint.visible = false
			_tree_root.visible = true
			#_dump_tree_as_json("tree_example_discovered")

		GdUnitEvent.DISCOVER_SUITE_ADDED:
			discover_test_suite_added(event as GdUnitEventTestDiscoverTestSuiteAdded)

		GdUnitEvent.DISCOVER_TEST_ADDED:
			discover_test_added(event as GdUnitEventTestDiscoverTestAdded)

		GdUnitEvent.DISCOVER_TEST_REMOVED:
			discover_test_removed(event as GdUnitEventTestDiscoverTestRemoved)

		GdUnitEvent.INIT:
			reset_tree_state(_tree_root)

		GdUnitEvent.STOP:
			sort_tree_items(_tree_root)
			#_dump_tree_as_json("tree_example")

		GdUnitEvent.TESTCASE_BEFORE:
			update_test_case(event)

		GdUnitEvent.TESTCASE_AFTER:
			update_test_case(event)

		GdUnitEvent.TESTSUITE_BEFORE:
			update_test_suite(event)

		GdUnitEvent.TESTSUITE_AFTER:
			update_test_suite(event)


func _on_context_m_index_pressed(index: int) -> void:
	match index:
		CONTEXT_MENU_DEBUG_ID:
			_on_run_pressed(true)
		CONTEXT_MENU_RUN_ID:
			_on_run_pressed(false)
		CONTEXT_MENU_EXPAND_ALL:
			do_collapse_all(false)
		CONTEXT_MENU_COLLAPSE_ALL:
			do_collapse_all(true)


func _on_settings_changed(property :GdUnitProperty) -> void:
	if property.name() == GdUnitSettings.INSPECTOR_TREE_SORT_MODE:
		sort_tree_items(_tree_root)
		# _dump_tree_as_json("tree_sorted_by_%s" % GdUnitInspectorTreeConstants.SORT_MODE.keys()[property.value()])

	if property.name() == GdUnitSettings.INSPECTOR_TREE_VIEW_MODE:
		_tree_view_mode_flat = property.value() == GdUnitInspectorTreeConstants.TREE_VIEW_MODE.FLAT
		GdUnitCommandHandler.instance().cmd_discover_tests()
