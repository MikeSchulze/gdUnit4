class_name DoubledSpyClassSourceClassName
extends GdUnitDoublerInstanceRef


static func __get_verifier() -> GdUnitObjectInteractionsVerifier:
	return __get_doubler_state()._verifier_instance


static func __do_call_real_func(__func_name: String) -> bool:
	return not __get_doubler_state()._excluded_methods.has(__func_name)
