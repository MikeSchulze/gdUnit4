@tool
extends ProgressBar

@onready var status: Label = $Label
@onready var style: StyleBoxFlat = get("theme_override_styles/fill")

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	GdUnitSignals.instance().gdunit_event.connect(_on_gdunit_event)
	GdUnitSignals.instance().gdunit_test_discovered.connect(on_test_case_discovered)
	style.bg_color = Color.DARK_GREEN
	value = 0
	max_value = 0
	update_text()


## @deprecated
func progress_init() -> void:
	value = 0
	max_value = 0
	style.bg_color = Color.DARK_GREEN
	update_text()


## @deprecated
func progress_update(p_value: int, is_failed: bool) -> void:
	value += p_value
	update_text()
	if is_failed:
		style.bg_color = Color.DARK_RED


func update_text() -> void:
	status.text = "%d:%d" % [value, max_value]


@warning_ignore("unused_parameter")
func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
	max_value += 1
	update_text()


## @deprecated
func _on_gdunit_event(event: GdUnitEvent) -> void:
	match event.type():

		GdUnitEvent.DISCOVER_START:
			progress_init()

		GdUnitEvent.TESTCASE_STATISTICS:
			progress_update(1, event.is_failed() or event.is_error())

		GdUnitEvent.TESTSUITE_AFTER:
			progress_update(0, event.is_failed() or event.is_error())
