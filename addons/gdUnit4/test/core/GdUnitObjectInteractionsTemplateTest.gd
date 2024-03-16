# GdUnit generated TestSuite
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/core/GdUnitObjectInteractionsTemplate.gd'


func test___filter_vargs():
	var template = load(__source).new()

	var varags :Array = [
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE]
	assert_array(template.__filter_vargs(varags)).is_empty()

	var object := RefCounted.new()
	varags = [
		"foo",
		"bar",
		null,
		true,
		1,
		object,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE,
		GdObjects.TYPE_VARARG_PLACEHOLDER_VALUE]
	assert_array(template.__filter_vargs(varags)).contains_exactly([
		"foo",
		"bar",
		null,
		true,
		1,
		object])
