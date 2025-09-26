class_name DoubledSpyClassSourceClassName


static var __excluded_methods__ := PackedStringArray()
static var __verifier_instance__ := GdUnitObjectInteractionsVerifier.new()


func __init(__excluded_methods := PackedStringArray()) -> void:
	__excluded_methods__ = __excluded_methods


static func __get_verifier() -> GdUnitObjectInteractionsVerifier:
	return __verifier_instance__


static func __do_call_real_func(__func_name: String) -> bool:
	return not __excluded_methods__.has(__func_name)
