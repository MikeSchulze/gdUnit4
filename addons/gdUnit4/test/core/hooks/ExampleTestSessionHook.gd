class_name ExampleTestSessionHook
extends GdUnitTestSessionHook


var _state: PackedStringArray = []

func startup(_session: GdUnitTestSession) -> GdUnitResult:
	_state.push_back("startup")
	return GdUnitResult.success()


func shutdown(_session: GdUnitTestSession) -> GdUnitResult:
	_state.push_back("shutdown")
	return GdUnitResult.success()
