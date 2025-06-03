# GdUnit generated TestSuite
class_name GdUnitUpdateTest
extends GdUnitTestSuite

# TestSuite generated from
const GdUnitUpdate = preload('res://addons/gdUnit4/src/update/GdUnitUpdate.gd')


func after_test() -> void:
	clean_temp_dir()


func test_patch_uids() -> void:
	var update := scene_runner("res://addons/gdUnit4/src/update/GdUnitUpdate.tscn")
	update.set_property("_debug_mode", true)

	# Us log monitor to catch debug messages
	var log_monitor := GodotGdErrorMonitor.new()
	log_monitor.start()
	# start uid patching
	await update.invoke("patch_uids")
	log_monitor.stop()
	var logs := await log_monitor.collect_full_logs()

	# Verify all scenes are upgrade
	assert_array(logs).contains([
		"Upgrade uid for resource 'GdUnitServer.tscn'",
		"Upgrade uid for resource 'GdUnitConsole.tscn'",
		"Upgrade uid for resource 'GdUnitUpdate.tscn'",
		"Upgrade uid for resource 'GdUnitTestRunner.tscn'",
		"Upgrade uid for resource 'GdUnitInspector.tscn'",
		"Upgrade uid for resource 'GdUnitUpdateNotify.tscn'"])

	# Verify images are reimported
	assert_array(logs).contains([
		"Reimport resources 'res://addons/gdUnit4/src/core/assets/touch-button.png'",
		"Reimport resources 'res://addons/gdUnit4/src/reporters/html/template/css/logo.png'"])
