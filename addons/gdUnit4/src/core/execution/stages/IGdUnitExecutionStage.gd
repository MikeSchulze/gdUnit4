## The interface for defining an execution stage.[br]
## An execution stage is defined as an encapsulated task that can execute 1-n substages covered by its own execution context.
## Execution stage are always called synchronously.
class_name IGdUnitExecutionStage
extends RefCounted


var _debug := false


## Executes the implemented stage synchronized in its own execution context.[br]
## example:[br]
## [codeblock]
##    # waits for 100ms
##    await MyExecutionStage.new().execute(<GdUnitExecutionContext>)
## [/codeblock][br]
func execute(context :GdUnitExecutionContext) -> void:
	pass


## Emit the event to registered listeners
func fire_event(event :GdUnitEvent) -> void:
	#print_verbose("GdUnitEvent", event)
	if _debug:
		GdUnitSignals.instance().gdunit_event_debug.emit(event)
	else:
		GdUnitSignals.instance().gdunit_event.emit(event)
