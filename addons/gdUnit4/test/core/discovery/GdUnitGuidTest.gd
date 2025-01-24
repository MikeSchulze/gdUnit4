# GdUnit generated TestSuite
class_name GdUnitGuidTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/discovery/GdUnitGUID.gd'


func test_equals() -> void:
	var guid_a := GdUnitGUID.new()
	var guid_b := GdUnitGUID.new()

	assert_that(guid_a).is_equal(guid_a)
	assert_that(guid_b).is_equal(guid_b)
	assert_that(guid_a).is_not_equal(guid_b)

	assert_bool(guid_a.equals(guid_a)).is_true()
	assert_bool(guid_a.equals(guid_b)).is_false()
	assert_bool(guid_b.equals(guid_a)).is_false()
