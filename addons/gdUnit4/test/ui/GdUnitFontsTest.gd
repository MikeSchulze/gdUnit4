# GdUnit generated TestSuite
class_name GdUnitFontsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/ui/GdUnitFonts.gd'


func test_load_and_resize_font() -> void:
	var font8 = GdUnitFonts.load_and_resize_font(GdUnitFonts.FONT_MONO, 8)
	var font16 = GdUnitFonts.load_and_resize_font(GdUnitFonts.FONT_MONO, 16)

	assert_object(font8).is_not_null().is_not_same(font16)
	assert_that(font8.fixed_size).is_equal(8)
	assert_that(font16.fixed_size).is_equal(16)
