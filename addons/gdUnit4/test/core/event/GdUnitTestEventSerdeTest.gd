# this test test for serialization and deserialization succcess
# of GdUnitEvent class
extends GdUnitTestSuite
	
func test_serde_suite_before():
	var event := GdUnitEvent.new().suite_before("path", "test_suite_a", 22)
	var serialized := event.serialize()
	var deserialized := GdUnitEvent.new().deserialize(serialized)
	assert_that(deserialized).is_instanceof(GdUnitEvent)
	assert_that(deserialized).is_equal(event)
	
func test_serde_suite_after():
	var event := GdUnitEvent.new().suite_after("path","test_suite_a")
	var serialized := event.serialize()
	var deserialized := GdUnitEvent.new().deserialize(serialized)
	assert_that(deserialized).is_equal(event)

func test_serde_test_before():
	var event := GdUnitEvent.new().test_before("path", "test_suite_a", "test_foo")
	var serialized := event.serialize()
	var deserialized := GdUnitEvent.new().deserialize(serialized)
	assert_that(deserialized).is_equal(event)

func test_serde_test_after_no_report():
	var event := GdUnitEvent.new().test_after("path", "test_suite_a", "test_foo")
	var serialized := event.serialize()
	var deserialized := GdUnitEvent.new().deserialize(serialized)
	assert_that(deserialized).is_equal(event)
	
func test_serde_test_after_with_report():
	var reports := [\
	GdUnitReport.new().create(GdUnitReport.FAILURE, 24, "this is a error a"), \
	GdUnitReport.new().create(GdUnitReport.FAILURE, 26, "this is a error b")]
	var event := GdUnitEvent.new().test_after("path", "test_suite_a", "test_foo", {}, reports)

	var serialized := event.serialize()
	var deserialized := GdUnitEvent.new().deserialize(serialized)
	assert_that(deserialized).is_equal(event)
	assert_array(deserialized.reports()).contains_exactly(reports)

func test_serde_TestReport():
	var report := GdUnitReport.new().create(GdUnitReport.FAILURE, 24, "this is a error")
	var serialized := report.serialize()
	var deserialized := GdUnitReport.new().deserialize(serialized)
	assert_that(deserialized).is_equal(report)
