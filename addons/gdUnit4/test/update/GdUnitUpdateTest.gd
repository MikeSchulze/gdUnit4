# GdUnit generated TestSuite
class_name GdUnitUpdateTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/update/GdUnitUpdate.gd'

func after_test():
	clean_temp_dir()


func test__prepare_update_deletes_old_content() -> void:
	var update :GdUnitUpdate = auto_free(GdUnitUpdate.new())
	update._info_progress = mock(ProgressBar)
	update._info_popup = mock(Popup)
	update._info_content = mock(Label)
	
	# precheck the update temp is empty
	clean_temp_dir()
	assert_array(GdUnitTools.scan_dir("user://tmp/update")).is_empty()
	
	# checked empty tmp update directory
	assert_dict(update._prepare_update())\
		.contains_key_value("tmp_path", "user://tmp/update")\
		.contains_key_value("zip_file", "user://tmp/update/update.zip")
	
	# put some artifacts checked tmp update directory
	create_temp_dir("update/data1")
	create_temp_dir("update/data2")
	create_temp_file("update", "update.zip")
	assert_array(GdUnitTools.scan_dir("user://tmp/update")).contains_exactly_in_any_order([
		"data1",
		"data2",
		"update.zip",
	])
	# call prepare update at twice where should cleanup old artifacts
	update._prepare_update()
	assert_array(GdUnitTools.scan_dir("user://tmp/update")).is_empty()
