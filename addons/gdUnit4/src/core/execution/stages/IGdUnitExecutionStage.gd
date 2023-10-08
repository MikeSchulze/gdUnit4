## The interface for defining an execution stage.[br]
## An execution stage is defined as an encapsulated task that can execute 1-n substages covered by its own execution context.
## Execution stage are always called synchronously.
class_name IGdUnitExecutionStage
extends RefCounted

var _debug_mode := false


## Executes synchronized the implemented stage in its own execution context.[br]
## example:[br]
## [codeblock]
##    # waits for 100ms
##    await MyExecutionStage.new().execute(<GdUnitExecutionContext>)
## [/codeblock][br]
func execute(context :GdUnitExecutionContext) -> void:
	context.set_active()
	await _execute(context)


## Emit the event to registered listeners
func fire_event(event :GdUnitEvent) -> void:
	if _debug_mode:
		GdUnitSignals.instance().gdunit_event_debug.emit(event)
	else:
		GdUnitSignals.instance().gdunit_event.emit(event)


## Internal testing stuff
## Sets the executor into debug mode to emit `GdUnitEvent` via signal `gdunit_event_debug`
func set_debug_mode(debug_mode :bool) -> void:
	_debug_mode = debug_mode


## The execution phase to be implemented
func _execute(_context :GdUnitExecutionContext) -> void:
	@warning_ignore("assert_always_false")
	assert(false, "The execution stage is not implemented")
	await Engine.get_main_loop().process_frame
