@tool
extends PanelContainer

signal failure_next()
signal failure_prevous()
signal request_discover_tests()

signal tree_view_mode_changed(flat :bool)

@onready var _errors := %error_value
@onready var _failures := %failure_value
@onready var _button_errors := %btn_errors
@onready var _button_failures := %btn_failures
@onready var _button_failure_up := %btn_failure_up
@onready var _button_failure_down := %btn_failure_down
@onready var _button_sync := %btn_tree_sync
@onready var _button_view_mode := %btn_tree_mode
@onready var _button_sort_mode := %btn_tree_sort


var total_failed := 0
var total_errors := 0


var sort_mappings := {
	GdUnitInspectorTreeConstants.SORT_MODE.UNSORTED : GdUnitUiTools.get_icon("TripleBar"),
	GdUnitInspectorTreeConstants.SORT_MODE.NAME_ASCENDING : GdUnitUiTools.get_icon("Sort"),
	GdUnitInspectorTreeConstants.SORT_MODE.NAME_DESCENDING : GdUnitUiTools.get_flipped_icon("Sort"),
	GdUnitInspectorTreeConstants.SORT_MODE.EXECUTION_TIME : GdUnitUiTools.get_icon("History"),
}


func _ready() -> void:
	GdUnitSignals.instance().gdunit_event.connect(_on_gdunit_event)
	_failures.text = "0"
	_errors.text = "0"
	_button_errors.icon = GdUnitUiTools.get_icon("StatusError")
	_button_failures.icon = GdUnitUiTools.get_icon("StatusError", Color.SKY_BLUE)
	_button_failure_up.icon = GdUnitUiTools.get_icon("ArrowUp")
	_button_failure_down.icon = GdUnitUiTools.get_icon("ArrowDown")
	_button_sync.icon = GdUnitUiTools.get_icon("Loop")
	_button_view_mode.icon = GdUnitUiTools.get_icon("Tree", Color.GHOST_WHITE)
	_button_sort_mode.icon = GdUnitUiTools.get_icon("Sort")
	_set_sort_mode_menu_options()
	GdUnitSignals.instance().gdunit_settings_changed.connect(_on_settings_changed)


func _set_sort_mode_menu_options() -> void:
	# construct context sort menu according to the available modes
	var context_menu :PopupMenu = _button_sort_mode.get_popup()
	context_menu.clear()

	if not context_menu.index_pressed.is_connected(_on_sort_mode_changed):
		context_menu.index_pressed.connect(_on_sort_mode_changed)

	var sort_mode_property := GdUnitSettings.get_property(GdUnitSettings.INSPECTOR_TREE_SORT_MODE)
	var selected_sort_mode :int = sort_mode_property.value()
	for sort_mode in sort_mode_property.value_set():
		var enum_value :int =  GdUnitInspectorTreeConstants.SORT_MODE.get(sort_mode)
		var icon :Texture2D = sort_mappings[enum_value]
		context_menu.add_icon_check_item(icon, normalise(sort_mode), enum_value)
		context_menu.set_item_checked(enum_value, selected_sort_mode == enum_value)


func normalise(value: String) -> String:
	var parts := value.to_lower().split("_")
	parts[0] = parts[0].capitalize()
	return " ".join(parts)


func status_changed(errors: int, failed: int) -> void:
	total_failed += failed
	total_errors += errors
	_failures.text = str(total_failed)
	_errors.text = str(total_errors)


func _on_gdunit_event(event: GdUnitEvent) -> void:
	match event.type():
		GdUnitEvent.INIT:
			total_failed = 0
			total_errors = 0
			status_changed(0, 0)
		GdUnitEvent.TESTCASE_BEFORE:
			pass
		GdUnitEvent.TESTCASE_AFTER:
			if event.is_error():
				status_changed(event.error_count(), 0)
			else:
				status_changed(0, event.failed_count())
		GdUnitEvent.TESTSUITE_BEFORE:
			pass
		GdUnitEvent.TESTSUITE_AFTER:
			if event.is_error():
				status_changed(event.error_count(), 0)
			else:
				status_changed(0, event.failed_count())


func _on_failure_up_pressed() -> void:
	failure_prevous.emit()


func _on_failure_down_pressed() -> void:
	failure_next.emit()


func _on_tree_sync_pressed() -> void:
	request_discover_tests.emit()


func _on_btn_tree_mode_toggled(toggled_on: bool) -> void:
	tree_view_mode_changed.emit(toggled_on)


func _on_sort_mode_changed(index: int) -> void:
	var selected_sort_mode :GdUnitInspectorTreeConstants.SORT_MODE = GdUnitInspectorTreeConstants.SORT_MODE.values()[index]
	GdUnitSettings.set_inspector_tree_sort_mode(selected_sort_mode)


func _on_settings_changed(property :GdUnitProperty) -> void:
	if property.name() == GdUnitSettings.INSPECTOR_TREE_SORT_MODE:
		_set_sort_mode_menu_options()
