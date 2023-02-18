################################################################################
# Provides access to a global accessible singleton 
# 
# This is a workarount to the existing auto load singleton because of some bugs 
# around plugin handling 
################################################################################
class_name GdUnitSingleton
extends RefCounted


const MEATA_KEY := "GdUnitSingletons"


static func instance(name :String, clazz :Callable) -> Variant:
	if Engine.has_meta(name):
		return Engine.get_meta(name)
	var singleton := clazz.call()
	Engine.set_meta(name, singleton)
	GdUnitTools.prints_verbose("Register singleton '%s:%s'" % [name, singleton])
	var singletons := Engine.get_meta(MEATA_KEY, PackedStringArray())
	singletons.append(name)
	Engine.set_meta(MEATA_KEY, singletons)
	return singleton


static func unregister(singleton :String) -> void:
	var singletons :PackedStringArray = Engine.get_meta(MEATA_KEY, PackedStringArray())
	if singletons.has(singleton):
		var index := singletons.find(singleton)
		singletons.remove_at(index)
		var instance := Engine.get_meta(singleton)
		GdUnitTools.prints_verbose("Free singeleton '%s:%s'" % [singleton, instance])
		GdUnitTools.free_instance(instance)
		Engine.remove_meta(singleton)
	Engine.set_meta(MEATA_KEY, singletons)


static func dispose() -> void:
	GdUnitTools.prints_verbose("Cleanup singletons ..")
	var singletons := Engine.get_meta(MEATA_KEY, PackedStringArray())
	for singleton in singletons:
		unregister(singleton)
	Engine.remove_meta(MEATA_KEY)
