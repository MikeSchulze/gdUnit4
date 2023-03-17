# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/command/GdUnitCommandHandler.gd'

func test__check_test_run_stopped_manually() -> void:
	var inspector :GdUnitCommandHandler = mock(GdUnitCommandHandler, CALL_REAL_FUNC)
	inspector._client_id = 1
	
	# simulate no test is running
	do_return(false).checked(inspector)._is_test_running_but_stop_pressed()
	inspector._check_test_run_stopped_manually()
	verify(inspector, 0).cmd_stop(any_int())
	
	# simulate the test runner was manually stopped by the editor
	do_return(true).checked(inspector)._is_test_running_but_stop_pressed()
	inspector._check_test_run_stopped_manually()
	verify(inspector, 1).cmd_stop(inspector._client_id)
