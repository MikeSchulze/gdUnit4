@tool
class_name GdUnitInspecor
extends Panel


var _command_handler := GdUnitCommandHandler.instance()


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	GdUnitCommandHandler.instance().gdunit_runner_start.connect(func() -> void:
		var control :Control = get_parent_control()
		# if the tab is floating we dont need to set as current
		if control is TabContainer:
			var tab_container :TabContainer = control
			for tab_index in tab_container.get_tab_count():
				if tab_container.get_tab_title(tab_index) == "GdUnit":
					tab_container.set_current_tab(tab_index)
	)


func _process(_delta: float) -> void:
	_command_handler._do_process()


func _on_MainPanel_run_testsuite(test_suite_paths: Array, debug: bool) -> void:
	_command_handler.cmd_run_test_suites(test_suite_paths, debug)


func _on_MainPanel_run_testcase(resource_path: String, test_case: String, test_param_index: int, debug: bool) -> void:
	_command_handler.cmd_run_test_case(resource_path, test_case, test_param_index, debug)


@warning_ignore("redundant_await")
func _on_status_bar_request_discover_tests() -> void:
	await _command_handler.cmd_discover_tests()
