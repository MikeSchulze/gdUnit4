# GdUnit generated TestSuite
class_name GdUnitTestSuiteTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/GdUnitTestSuite.gd'
const GdUnitAssertImpl = preload("res://addons/gdUnit4/src/asserts/GdUnitAssertImpl.gd")

var _events :Array[GdUnitEvent] = []


func collect_report(event :GdUnitEvent):
	_events.push_back(event)


func before():
	# register to receive test reports
	GdUnitSignals.instance().gdunit_event.connect(collect_report)


func after():
	# verify the test case `test_unknown_argument_in_test_case` was skipped
	assert_array(_events).extractv(extr("type"), extr("is_skipped"), extr("test_name"))\
		.contains([tuple(GdUnitEvent.TESTCASE_AFTER, true, "test_unknown_argument_in_test_case")])
	GdUnitSignals.instance().gdunit_event.disconnect(collect_report)


func test_assert_that_types() -> void:
	assert_object(assert_that(true)).is_instanceof(GdUnitBoolAssert)
	assert_object(assert_that(1)).is_instanceof(GdUnitIntAssert)
	assert_object(assert_that(3.12)).is_instanceof(GdUnitFloatAssert)
	assert_object(assert_that("abc")).is_instanceof(GdUnitStringAssert)
	assert_object(assert_that(Vector2.ONE)).is_instanceof(GdUnitVectorAssert)
	assert_object(assert_that(Vector2i.ONE)).is_instanceof(GdUnitVectorAssert)
	assert_object(assert_that(Vector3.ONE)).is_instanceof(GdUnitVectorAssert)
	assert_object(assert_that(Vector3i.ONE)).is_instanceof(GdUnitVectorAssert)
	assert_object(assert_that(Vector4.ONE)).is_instanceof(GdUnitVectorAssert)
	assert_object(assert_that(Vector4i.ONE)).is_instanceof(GdUnitVectorAssert)
	assert_object(assert_that([])).is_instanceof(GdUnitArrayAssert)
	assert_object(assert_that({})).is_instanceof(GdUnitDictionaryAssert)
	assert_object(assert_that(GdUnitResult.new())).is_instanceof(GdUnitObjectAssert)
	# all not a built-in types mapped to default GdUnitAssert
	assert_object(assert_that(Color.RED)).is_instanceof(GdUnitAssertImpl)
	assert_object(assert_that(Plane.PLANE_XY)).is_instanceof(GdUnitAssertImpl)


func test_unknown_argument_in_test_case(_invalid_arg) -> void:
	fail("This test case should be not executed, it must be skipped.")
