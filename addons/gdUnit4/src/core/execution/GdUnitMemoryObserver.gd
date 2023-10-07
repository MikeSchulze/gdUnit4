class_name GdUnitMemoryObserver
extends RefCounted

const GdUnitTools = preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")

var _store :Array[Variant] = []
var _orphan_detection_enabled :bool = true


func _init():
	_orphan_detection_enabled = GdUnitSettings.is_verbose_orphans()


# register an instance to be freed when a test suite is finished
func register_auto_free(obj) -> Variant:
	# do not register on GDScriptNativeClass
	if typeof(obj) == TYPE_OBJECT and (obj as Object).is_class("GDScriptNativeClass") :
		return obj
	if obj is GDScript or obj is ScriptExtension:
		return obj
	if obj is MainLoop:
		push_error("GdUnit4: Avoid to add mainloop to auto_free queue  %s" % obj)
		return
	if OS.is_stdout_verbose():
		print_verbose("GdUnit4:gc():register auto_free(%s)" % obj)
	# only register pure objects
	if obj is GdUnitSceneRunner:
		_store.push_front(obj)
	else:
		_store.append(obj)
	return obj


# runs over all registered objects and releases them
func gc() -> void:
	if _store.is_empty():
		return
	# give engine time to free objects as set by queue_free()
	await Engine.get_main_loop().process_frame
	if OS.is_stdout_verbose():
		print_verbose("GdUnit4:gc():running", " freeing %d objects .." % _store.size())
	while not _store.is_empty():
		var value :Variant = _store.pop_front()
		GdUnitTools.free_instance(value)


# tests if given object is registered for auto freeing
func is_auto_free_registered(obj) -> bool:
	# only register real object values
	if not is_instance_valid(obj):
		return false
	return _store.has(obj)
