class_name GdUnitMemoryObserver
extends RefCounted

const GdUnitTools = preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")

var _store :Array[Variant] = []
var _orphan_detection_enabled :bool = true


func _init():
	configure(GdUnitSettings.is_verbose_orphans())


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		while not _store.is_empty():
			var value :Variant = _store.pop_front()
			GdUnitTools.free_instance(value)


func configure(orphan_detection :bool) -> void:
	_orphan_detection_enabled = orphan_detection
	if not _orphan_detection_enabled:
		prints("!!! Reporting orphan nodes is disabled. Please check GdUnit settings.")


# register an instance to be freed when a test suite is finished
func register_auto_free(obj) -> Variant:
	# do not register on GDScriptNativeClass
	if typeof(obj) == TYPE_OBJECT and (obj as Object).is_class("GDScriptNativeClass") :
		return obj
	if obj is GDScript or obj is ScriptExtension:
		return obj
	if obj is MainLoop:
		push_error("avoid to add mainloop to auto_free queue  %s" % obj)
		return
	print_verbose("register auto_free(%s)" % obj, self)
	# only register pure objects
	if obj is GdUnitSceneRunner:
		_store.push_front(obj)
	else:
		_store.append(obj)
	return obj


# runs over all registered objects and frees it
func gc() -> void:
	print_verbose("runing:gc()", self, "freeing %d objects" % _store.size())
	while not _store.is_empty():
		var value :Variant = _store.pop_front()
		GdUnitTools.free_instance(value)


# tests if given object is registered for auto freeing
func is_auto_free_registered(obj) -> bool:
	# only register real object values
	if not is_instance_valid(obj):
		return false
	return _store.has(obj)
