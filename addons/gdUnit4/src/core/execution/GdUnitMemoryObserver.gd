## The memory watcher for objects that have been registered and are released when 'gc' is called.
class_name GdUnitMemoryObserver
extends RefCounted

const TAG_AUTO_FREE = "GdUnit4_marked_auto_free"
const GdUnitTools = preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")


var _store :Array[Variant] = []
var _orphan_detection_enabled :bool = true
# enable for debugging purposes
var _is_stdout_verbose := false


func _init():
	_orphan_detection_enabled = GdUnitSettings.is_verbose_orphans()


## Registration of an instance to be released when an execution phase is completed
func register_auto_free(obj) -> Variant:
	if not is_instance_valid(obj):
		return obj
	# do not register on GDScriptNativeClass
	if typeof(obj) == TYPE_OBJECT and (obj as Object).is_class("GDScriptNativeClass") :
		return obj
	#if obj is GDScript or obj is ScriptExtension:
	#	return obj
	if obj is MainLoop:
		push_error("GdUnit4: Avoid to add mainloop to auto_free queue  %s" % obj)
		return
	if _is_stdout_verbose:
		print_verbose("GdUnit4:gc():register auto_free(%s)" % obj)
	# only register pure objects
	if obj is GdUnitSceneRunner:
		_store.push_back(obj)
	else:
		_store.append(obj)
	_tag_object(obj)
	return obj


# store the object into global store aswell to be verified by 'is_marked_auto_free'
func _tag_object(obj :Variant) -> void:
	var tagged_object := Engine.get_meta(TAG_AUTO_FREE, []) as Array
	tagged_object.append(obj)
	Engine.set_meta(TAG_AUTO_FREE, tagged_object)


## Runs over all registered objects and releases them
func gc() -> void:
	if _store.is_empty():
		return
	# give engine time to free objects to process objects marked by queue_free()
	await Engine.get_main_loop().process_frame
	if _is_stdout_verbose:
		print_verbose("GdUnit4:gc():running", " freeing %d objects .." % _store.size())
	var tagged_objects := Engine.get_meta(TAG_AUTO_FREE, []) as Array
	while not _store.is_empty():
		var value :Variant = _store.pop_front()
		tagged_objects.erase(value)
		await GdUnitTools.free_instance(value, _is_stdout_verbose)


## Checks whether the specified object is registered for automatic release
static func is_marked_auto_free(obj) -> bool:
	return Engine.get_meta(TAG_AUTO_FREE, []).has(obj)
