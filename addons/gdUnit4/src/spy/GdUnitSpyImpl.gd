# warnings-disable
# warning-ignore:unused_argument
class_name GdUnitSpyImpl

const __INSTANCE_ID = "${instance_id}"

var __instance_delegator


static func __instance():
	return GdUnitStaticDictionary.get_value(__INSTANCE_ID)


func __instance_id() -> String:
	return __INSTANCE_ID


func __set_singleton(delegator):
	# store self need to mock static functions
	GdUnitStaticDictionary.add_value(__INSTANCE_ID, self)
	__instance_delegator = delegator
	#assert(__self[0] != null, "Invalid mock")


func __release_double():
	# we need to release the self reference manually to prevent orphan nodes
	GdUnitStaticDictionary.erase(__INSTANCE_ID)
	__instance_delegator = null


func __call_func(func_name :String, arguments :Array):
	return __instance_delegator.callv(func_name, arguments)
