## GdUnitTestSessionHook
##
## Base class for creating custom test session hooks in GdUnit4.
##
## Test session hooks allow users to extend the GdUnit4 test framework by providing
## custom functionality that runs at specific points during the test execution lifecycle.
## This base class defines the interface that all test session hooks must implement.
##
## ## Usage
##
## To create a custom test session hook:
## 1. Create a new class that extends GdUnitTestSessionHook
## 2. Override the required methods (startup, shutdown)
## 3. Optionally set the priority property to control execution order
## 4. Register your hook with the test engine (using the GdUnit4 settings dialog)
##
## ## Example
##
## ```gdscript
## class_name MyCustomTestHook
## extends GdUnitTestSessionHook
##
## func _init():
##     priority = 10  # Higher priority than default
##
## func startup(session: GdUnitTestSession) -> GdUnitResult:
##     session.send_message("Custom hook initialized")
##     # Initialize resources, setup test environment, etc.
##     return GdUnitResult.success()
##
## func shutdown(session: GdUnitTestSession) -> GdUnitResult:
##     session.send_message("Custom hook cleanup completed")
##     # Cleanup resources, generate reports, etc.
##     return GdUnitResult.success()
## ```
##
## ## Hook Lifecycle
##
## 1. **Registration**: Hooks are registered with the test engine via settings dialog
## 2. **Priority Sorting**: Hooks are sorted by priority (lower numbers = higher priority)
## 3. **Startup**: startup() is called before test execution begins, if it returns an error is shown in the console
## 4. **Test Execution**: Tests run normally (only if all hooks started successfully)
## 5. **Shutdown**: shutdown() is called after all tests complete, regardless of startup success
##
## ## Priority System
##
## The priority system allows controlling the execution order of multiple hooks:
## - Lower numbers indicate higher priority (executed first during startup, last during shutdown)
## - Default priority is 100
## - Negative priorities are reserved for system-level hooks
## - Positive priorities are recommended for user hooks
##
## ## Session Access
##
## Both startup() and shutdown() methods receive a GdUnitTestSession parameter that provides:
## - Access to test cases being executed
## - Event emission capabilities for test progress tracking
## - Message sending functionality for logging and communication
##
## @since GdUnit4 5.1.0
class_name GdUnitTestSessionHook
extends RefCounted


## Execution priority of this hook.
##
## Hooks with lower priority values are executed first during startup
## and last during shutdown. This allows for proper dependency management
## between different hooks.
##
## ! Negative priorities are reserved for system-level hooks
##
## Can be set during initialization to change execution order.
## Default value is 100.
##
## @default 100
var priority: int = 100:
	get:
		return priority
	set(value):
		priority = value


## Called when the test session starts up, before any tests are executed.
##
## This method should be overridden to implement custom initialization logic
## such as:
## - Setting up test databases or external services
## - Initializing mock objects or test fixtures
## - Configuring logging or reporting systems
## - Preparing the test environment
## - Subscribing to test events via the session
##
## @param session The test session instance providing access to test data and communication
## @return GdUnitResult.success() if initialization succeeds, or GdUnitResult.error() with
##         an error message if initialization fails. Test execution is aborted if
##         this method returns an error.
##
## @abstract This method must be implemented by subclasses
func startup(_session: GdUnitTestSession) -> GdUnitResult:
	return GdUnitResult.error("%s:startup is not implemented" % get_script().resource_path)


## Called when the test session shuts down, after all tests have completed.
##
## This method should be overridden to implement custom cleanup logic
## such as:
## - Cleaning up test databases or external services
## - Generating test reports or artifacts
## - Releasing resources allocated during startup
## - Performing final validation or assertions
## - Processing collected test events and data
##
## This method should handle cleanup gracefully even if startup() failed
## or if the test execution was interrupted.
##
## @param session The test session instance providing access to test results and communication
## @return GdUnitResult.success() if cleanup succeeds, or GdUnitResult.error() with
##         an error message if cleanup fails. Cleanup errors are typically logged
##         but don't prevent the test engine from shutting down.
##
## @abstract This method must be implemented by subclasses
func shutdown(_session: GdUnitTestSession) -> GdUnitResult:
	return GdUnitResult.error("%s:shutdown is not implemented" % get_script().resource_path)
