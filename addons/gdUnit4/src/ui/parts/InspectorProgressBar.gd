@tool
extends ProgressBar

@onready var status: Label = $Label
@onready var style: StyleBoxFlat = get("theme_override_styles/fill")

var _discovery_sink: GdUnitTestDiscoverSink

## Using discovery sink to set max progress count
class ProgressTestDiscoverySink extends GdUnitTestDiscoverSink:

	var _progress_bar: ProgressBar

	func _init(progress_bar: ProgressBar) -> void:
		#GdUnitTestDiscoverySinkDispatcher.instance().register_discovery_sink(self)
		_progress_bar = progress_bar
		_progress_bar.value = 0
		_progress_bar.max_value = 0
		_progress_bar.call("update_text")


	@warning_ignore("unused_parameter")
	func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
		_progress_bar.max_value += 1
		_progress_bar.call("update_text")


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	GdUnitSignals.instance().gdunit_event.connect(_on_gdunit_event)
	style.bg_color = Color.DARK_GREEN
	_discovery_sink = ProgressTestDiscoverySink.new(self)

## @deprecated
func progress_init(p_max_value: int) -> void:
	value = 0
	max_value = p_max_value
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


## @deprecated
func _on_gdunit_event(event: GdUnitEvent) -> void:
	match event.type():
		GdUnitEvent.INIT:
			progress_init(event.total_count())

		GdUnitEvent.DISCOVER_END:
			progress_init(event.total_count())

		GdUnitEvent.TESTCASE_STATISTICS:
			progress_update(1, event.is_failed() or event.is_error())

		GdUnitEvent.TESTSUITE_AFTER:
			progress_update(0, event.is_failed() or event.is_error())
