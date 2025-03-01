class_name GdUnitTestReporter
extends RefCounted


var _statistics := {}
var _summary := {}


func on_gdunit_event(_event: GdUnitEvent) -> void:
	pass


func init_summary() -> void:
	_summary["suite_count"] = 0
	_summary["total_count"] = 0
	_summary["error_count"] = 0
	_summary["failed_count"] = 0
	_summary["skipped_count"] = 0
	_summary["flaky_count"] = 0
	_summary["orphan_nodes"] = 0
	_summary["elapsed_time"] = 0


func processed_suite_count() -> int:
	return _summary["suite_count"]


func total_test_count() -> int:
	return _summary["total_count"]


func total_flaky_count() -> int:
	return _summary["flaky_count"]


func total_error_count() -> int:
	return _summary["error_count"]


func total_failure_count() -> int:
	return _summary["failed_count"]


func total_skipped_count() -> int:
	return _summary["skipped_count"]


func total_orphan_count() -> int:
	return _summary["orphan_nodes"]


func elapsed_time() -> int:
	return _summary["elapsed_time"]
