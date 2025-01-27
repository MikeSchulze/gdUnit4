class_name GdUnitSignals
extends RefCounted

@warning_ignore("unused_signal")
signal gdunit_client_connected(client_id :int)
@warning_ignore("unused_signal")
signal gdunit_client_disconnected(client_id :int)
@warning_ignore("unused_signal")
signal gdunit_client_terminated()

@warning_ignore("unused_signal")
signal gdunit_event(event :GdUnitEvent)
@warning_ignore("unused_signal")
signal gdunit_event_debug(event :GdUnitEvent)
@warning_ignore("unused_signal")
signal gdunit_add_test_suite(test_suite :GdUnitTestSuiteDto)
@warning_ignore("unused_signal")
signal gdunit_message(message :String)
@warning_ignore("unused_signal")
signal gdunit_set_test_failed(is_failed :bool)
@warning_ignore("unused_signal")
signal gdunit_settings_changed(property :GdUnitProperty)

## Called when a new test case is discovered during the discovery process.
## Custom implementations should connect to this signal and store the discovered test case as needed.[br]
## [member test_case] The discovered test case instance to be processed.
@warning_ignore("unused_signal")
signal gdunit_test_discovered(test_case: GdUnitTestCase)

const META_KEY := "GdUnitSignals"


static func instance() -> GdUnitSignals:
	if Engine.has_meta(META_KEY):
		return Engine.get_meta(META_KEY)
	var instance_ := GdUnitSignals.new()
	Engine.set_meta(META_KEY, instance_)
	return instance_


static func dispose() -> void:
	var signals := instance()
	# cleanup connected signals
	for signal_ in signals.get_signal_list():
		@warning_ignore("unsafe_cast")
		for connection in signals.get_signal_connection_list(signal_["name"] as StringName):
			var _signal: Signal = connection["signal"]
			var _callable: Callable = connection["callable"]
			_signal.disconnect(_callable)
	signals = null
	Engine.remove_meta(META_KEY)
