extends RefCounted

const MIN_VALUE := -10
const MAX_VALUE := 22

class NestedFuzzer extends Fuzzer:
	
	func _init():
		pass
	
	func next_value() -> Variant:
		return {}
	
	static func _s_max_value() -> int:
		return MAX_VALUE


func min_value() -> int:
	return MIN_VALUE


func get_fuzzer() -> Fuzzer:
	return Fuzzers.rangei(min_value(), NestedFuzzer._s_max_value())


func non_fuzzer() -> Resource:
	return Image.new()
