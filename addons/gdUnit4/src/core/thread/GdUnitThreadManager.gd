class_name GdUnitThreadManager
extends RefCounted

## { id:<int> = GdUnitThreadContext }
var _threads_by_id := {}

var _current_thread_caller_id :int = -1

func _init():
	_current_thread_caller_id = OS.get_thread_caller_id()
	_threads_by_id[OS.get_main_thread_id()] = GdUnitThreadContext.new()


func _notification(_what):
	# prints("_notification", what)
	pass


static func instance() -> GdUnitThreadManager:
	return GdUnitSingleton.instance("GdUnitThreadManager", func(): return GdUnitThreadManager.new())


## Runs a new thread by given name and Callable
## We need this custom implementation while this bug is not solved
## Godot issue https://github.com/godotengine/godot/issues/79637
static func run(name :String, cb :Callable) -> Variant:
	return await instance()._run(name, cb)


func _run(name :String, cb :Callable):
	# we do this hack because of `OS.get_thread_caller_id()` not returns the current id
	# when await process_frame is called inside the fread
	var save_current_thread_id = _current_thread_caller_id
	var thread := Thread.new()
	thread.set_meta("name", name)
	thread.start(cb)
	var tc := GdUnitThreadContext.new(thread)
	_register_thread_context(tc)
	_current_thread_caller_id = thread.get_id() as int
	var result :Variant = await thread.wait_to_finish()
	_unregister_thread_context(tc)
	# restore original thread id
	_current_thread_caller_id = save_current_thread_id
	return result


func _register_thread_context(context :GdUnitThreadContext) -> void:
	_threads_by_id[context.thread_id()] = context


func _unregister_thread_context(context :GdUnitThreadContext) -> void:
	_threads_by_id.erase(context)


func _get_current_context() -> GdUnitThreadContext:
	return _threads_by_id.get(_current_thread_caller_id)


static func get_current_context() -> GdUnitThreadContext:
	return instance()._get_current_context()
