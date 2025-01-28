class_name RPCGdUnitEvent
extends RPC


static func of(p_event :GdUnitEvent) -> RPCGdUnitEvent:
	var rpc := RPCGdUnitEvent.new()
	rpc._data = p_event.serialize()
	return rpc


func event() -> GdUnitEvent:
	return GdUnitEvent.new().deserialize(_data)


func _to_string() -> String:
	return "RPCGdUnitEvent: " + str(_data)
