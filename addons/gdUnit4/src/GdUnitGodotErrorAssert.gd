## An assertion tool to verify for Godot runtime errors like assert() and push notifications like push_error().
class_name GdUnitGodotErrorAssert
extends GdUnitAssert


## Verifies if the executed code runs without any runtime errors
func is_success() -> GdUnitGodotErrorAssert:
	return self


## Verifies if the executed code runs into a runtime error
func is_runtime_error(expected_error :String) -> GdUnitGodotErrorAssert:
	return self


## Verifies if the executed code has a push_warning() used
func is_push_warning(expected_warning :String) -> GdUnitGodotErrorAssert:
	return self


## Verifies if the executed code has a push_error() used
func is_push_error(expected_error :String) -> GdUnitGodotErrorAssert:
	return self
