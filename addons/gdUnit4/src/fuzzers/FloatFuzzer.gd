class_name FloatFuzzer
extends Fuzzer

var _from: int = 0
var _to: int = 0

func _init(from: int, to: int):
	assert(from <= to, "Invalid range!")
	_from = from
	_to = to

func next_value() -> Variant:
	var value := randf_range(_from, _to)
	return value
