# GdUnit generated TestSuite
class_name GdUnitTestSuiteTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/GdUnitTestSuite.gd'

func test_assert_that_types() -> void:
	assert_object(assert_that(true)).is_instanceof(GdUnitBoolAssert)
	assert_object(assert_that(1)).is_instanceof(GdUnitIntAssert)
	assert_object(assert_that(3.12)).is_instanceof(GdUnitFloatAssert)
	assert_object(assert_that("abc")).is_instanceof(GdUnitStringAssert)
	assert_object(assert_that(Vector2.ONE)).is_instanceof(GdUnitVector2Assert)
	assert_object(assert_that(Vector3.ONE)).is_instanceof(GdUnitVector3Assert)
	assert_object(assert_that([])).is_instanceof(GdUnitArrayAssert)
	assert_object(assert_that({})).is_instanceof(GdUnitDictionaryAssert)
	assert_object(assert_that(Result.new())).is_instanceof(GdUnitObjectAssert)
	# all not a built-in types mapped to default GdUnitAssert
	assert_object(assert_that(Color.RED)).is_instanceof(GdUnitAssertImpl)
	assert_object(assert_that(Plane.PLANE_XY)).is_instanceof(GdUnitAssertImpl)
