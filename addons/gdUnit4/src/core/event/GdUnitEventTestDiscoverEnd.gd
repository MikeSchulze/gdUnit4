class_name GdUnitEventTestDiscoverEnd
extends GdUnitEvent


var _total_testsuites :int


func _init(p_total_testsuites :int, p_total_count :int) -> void:
	_event_type = DISCOVER_END
	_total_testsuites = p_total_testsuites
	_total_count = p_total_count


func total_test_suites() -> int:
	return _total_testsuites


func total_tests() -> int:
	return _total_count
