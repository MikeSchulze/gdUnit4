class_name ClassWithEnumConstructor
extends RefCounted

enum  EnumValue {
	ONE = 10,
	TWO = 20
}

var _value :EnumValue

# using an enum in the constructor
func _init(value: EnumValue, second_parameter: PackedStringArray) -> void:
	_value = value


# using an enum as function argument
func set_value(value: EnumValue):
	_value = value
