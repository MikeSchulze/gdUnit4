class_name GdUnitDoublerInstanceRef


const __INSTANCE_ID = "${instance_id}"


class GdUnitDoublerState:

	var _excluded_methods: PackedStringArray
	var _verifier_instance: GdUnitObjectInteractionsVerifier

	func _init(excluded_methods : PackedStringArray) -> void:
		_excluded_methods = excluded_methods
		_verifier_instance = GdUnitObjectInteractionsVerifier.new()


func __init(__excluded_methods := PackedStringArray()) -> void:
	Engine.set_meta(__INSTANCE_ID, GdUnitDoublerState.new(__excluded_methods))


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if Engine.has_meta(__INSTANCE_ID):
			Engine.remove_meta(__INSTANCE_ID)


static func __get_doubler_state() -> GdUnitDoublerState:
	return Engine.get_meta(__INSTANCE_ID)
