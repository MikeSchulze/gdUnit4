@tool
extends PanelContainer

signal failure_next()
signal failure_prevous()
signal request_discover_tests()
signal tree_sort_mode_changed(asscending :bool)
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


func _on_btn_tree_sort_toggled(toggled_on: bool) -> void:
	tree_sort_mode_changed.emit(toggled_on)
