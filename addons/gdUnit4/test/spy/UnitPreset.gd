class_name UnitPreset
extends RefCounted

enum  Rarity {
	COMMON = 10,
	TWO = 20
}

var _rarity :Rarity

# using an enum in the constructor
func _init(rarity: Rarity, presets_to_filter_out: PackedStringArray) -> void:
	_rarity = rarity


# using an enum as function argument
func set_rarity(rarity: Rarity):
	_rarity = rarity
