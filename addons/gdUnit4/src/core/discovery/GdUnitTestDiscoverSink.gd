## An abstract sink class for handling test case discovery events in GdUnit4.
## Provides a base implementation for collecting and processing discovered test cases during test discovery.
## Custom test discovery implementations should extend this class and implement the required methods.
class_name GdUnitTestDiscoverSink
extends RefCounted


## Processes a discovered test case by sending it to the discovery sink.[br]
## [member test_case] The test case to be processed by the discovery sink.
func discover(test_case: GdUnitTestCase) -> void:
	on_test_case_discovered(test_case)


## Called when a new test case is discovered during the discovery process.
## Custom implementations should process or store the discovered test case as needed.[br]
## [member test_case] The discovered test case instance to be processed.
@warning_ignore("unused_parameter")
func on_test_case_discovered(test_case: GdUnitTestCase) -> void:
	push_error("This function must be implemented by the discovery receiver")
