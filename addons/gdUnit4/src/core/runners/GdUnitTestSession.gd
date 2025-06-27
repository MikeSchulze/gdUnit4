## GdUnitTestSession
##
## Represents a test execution session in GdUnit4.
##
## A test session encapsulates a complete test execution cycle, managing the collection
## of test cases to be executed and providing communication channels for test events
## and messages. This class serves as the central coordination point for test execution
## and allows hooks and other components to interact with the running test session.
##
## ## Key Features
##
## - **Test Case Management**: Maintains a collection of test cases to be executed
## - **Event Broadcasting**: Forwards GdUnit events to session-specific listeners
## - **Message Communication**: Provides a channel for sending messages during test execution
## - **Hook Integration**: Passed to test session hooks for startup and shutdown operations
##
## ## Usage in Test Hooks
##
## ```gdscript
## func startup(session: GdUnitTestSession) -> GdUnitResult:
##     # Access test cases
##     print("Running %d test cases" % session.test_cases.size())
##
##     # Send status messages
##     session.send_message("Custom hook initialized")
##
##     # Listen for test events
##     session.test_event.connect(_on_test_event)
##
##     return GdUnitResult.success()
##
## func _on_test_event(event: GdUnitEvent) -> void:
##     print("Test event received: %s" % event.type)
## ```
##
## ## Event Flow
##
## 1. Session is created with a collection of test cases
## 2. Session connects to the global GdUnit event system
## 3. During test execution, events are automatically forwarded to session listeners
## 4. Hooks and other components can subscribe to session events
## 5. Messages can be sent through the session for logging and communication
##
## @since GdUnit4 5.1.0
class_name GdUnitTestSession
extends RefCounted


## Emitted when a test execution event occurs.
##
## This signal forwards events from the global GdUnit event system to session-specific
## listeners. It allows hooks and other session components to react to test events
## without directly connecting to the global event system.
##
## Common event types include:
## - Test suite start/end events
## - Test case start/end events
## - Test assertion events
## - Test failure/error events
##
## @param event The test event containing details about test execution, timing, and results
@warning_ignore("unused_signal")
signal test_event(event: GdUnitEvent)


## Collection of test cases to be executed in this session.
##
## This array contains all the test cases that will be run during the session.
## Test hooks can access this collection to:
## - Get the total number of tests to be executed
## - Access individual test case metadata
## - Perform setup/teardown based on test case requirements
## - Generate reports or statistics about the test suite
##
## The collection is typically populated before session startup and remains
## constant during test execution.
##
## @readonly Should not be modified directly during test execution
var test_cases : Array[GdUnitTestCase] = [] :
	get:
		return test_cases
	set(value):
		test_cases = value


## Initializes the test session and sets up event forwarding.
##
## This constructor automatically connects to the global GdUnit event system
## and forwards all events to the session's test_event signal. This allows
## session-specific components to listen for test events without managing
## global signal connections.
func _init() -> void:
	GdUnitSignals.instance().gdunit_event.connect(func(event: GdUnitEvent) -> void:
		test_event.emit(event)
	)


## Sends a message through the GdUnit messaging system.
##
## This method provides a convenient way for test hooks and other session
## components to send messages that will be handled by the GdUnit framework.
## Messages are typically used for:
## - Status updates during test execution
## - Progress reporting from test hooks
## - Debug information and logging
## - User notifications and alerts
##
## The message will be processed by the global GdUnit message system and
## may be displayed in the test runner UI, logged to files, or handled
## by other registered message handlers.
##
## ## Example Usage
##
## ```gdscript
## # In a test hook
## func startup(session: GdUnitTestSession) -> GdUnitResult:
##     session.send_message("Database connection established")
##     return GdUnitResult.success()
##
## func shutdown(session: GdUnitTestSession) -> GdUnitResult:
##     session.send_message("Generated test report: report.html")
##     return GdUnitResult.success()
## ```
##
## @param message The message text to send through the GdUnit messaging system
func send_message(message: String) -> void:
	GdUnitSignals.instance().gdunit_message.emit(message)
