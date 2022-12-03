@tool
extends Popup

signal request_completed(response)

const GdMarkDownReader = preload("res://addons/gdUnit4/src/update/GdMarkDownReader.gd")
const GdUnitUpdateClient = preload("res://addons/gdUnit4/src/update/GdUnitUpdateClient.gd")
const spinner_icon := "res://addons/gdUnit4/src/ui/assets/spinner.tres"

@onready var _md_reader :GdMarkDownReader = GdMarkDownReader.new()
@onready var _update_client :GdUnitUpdateClient = $GdUnitUpdateClient
@onready var _header :Label = $Panel/GridContainer/PanelContainer/header
@onready var _update_button :Button = $Panel/GridContainer/Panel/HBoxContainer/update
@onready var _close_button :Button = $Panel/GridContainer/Panel/HBoxContainer/close
@onready var _content :RichTextLabel = $Panel/GridContainer/PanelContainer2/ScrollContainer/MarginContainer/content
@onready var _progress_panel :Control =$Panel/GridContainer/PanelContainer2/UpdateProgress
@onready var _progress_content :Label = $Panel/GridContainer/PanelContainer2/UpdateProgress/Progress/label
@onready var _progress_bar :ProgressBar = $Panel/GridContainer/PanelContainer2/UpdateProgress/Progress/bar

var _debug_mode := false

var _patcher :GdUnitPatcher = GdUnitPatcher.new()
var _current_version := GdUnit4Version.current()
var _available_versions :Array
var _download_zip_url :String
var _update_in_progress :bool = false


func _ready():
	_update_button.disabled = true
	_md_reader.set_http_client(_update_client)
	GdUnitFonts.init_fonts(_content)
	request_releases()


func request_releases() -> void:
	if _debug_mode:
		_header.text = "A new version 'v4.1.0_debug' is available"
		show_update()
		return
	var response :GdUnitUpdateClient.HttpResponse = await _update_client.request_latest_version()
	if response.code() != 200:
		push_warning("Update information cannot be retrieved from GitHub! \n %s" % response.response())
		return
	var latest_version := extract_latest_version(response)
	# if same version exit here no update need
	if latest_version.is_greater(_current_version):
		_patcher.scan(_current_version)
		_header.text = "A new version '%s' is available" % latest_version
		_download_zip_url = extract_zip_url(response)
		show_update()


func _colored(message :String, color :Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(), message]


func message_h4(message :String, color :Color, clear := true) -> void:
	if clear:
		_content.clear()
	_content.append_text("[font_size=16]%s[/font_size]" % _colored(message, color))


func message(message :String, color :Color) -> void:
	_content.clear()
	_content.append_text(_colored(message, color))


func _process(_delta):
	if _content != null and _content.is_visible_in_tree():
		_content.queue_redraw()


func show_update() -> void:
	message_h4("\n\n\nRequest release infos ... [img=24x24]%s[/img]" % spinner_icon, Color.SNOW)
	popup_centered_ratio(.5)
	if _debug_mode:
		var content :String = FileAccess.open("res://addons/gdUnit4/test/update/resources/markdown.txt", FileAccess.READ).get_as_text()
		var bbcode = await _md_reader.to_bbcode(content)
		message(bbcode, Color.DODGER_BLUE)
		_update_button.set_disabled(false)
		return
	var response :GdUnitUpdateClient.HttpResponse = await _update_client.request_releases()
	if response.code() == 200:
		var content :String = await extract_releases(response, _current_version)
		# finally force rescan to import images as textures
		if Engine.is_editor_hint():
			await rescan()
		message(content, Color.DODGER_BLUE)
		_update_button.set_disabled(false)
	else:
		message_h4("\n\n\nError checked request available releases!", Color.RED)


func step_request_release_info():
	message_h4("\n\n\nRequest release infos ... [img=24x24]%s[/img]" % spinner_icon, Color.SNOW)
	popup_centered_ratio(.5)
	if _debug_mode:
		var content :String = FileAccess.open("res://addons/gdUnit4/test/update/resources/markdown.txt", FileAccess.READ).get_as_text()
		var bbcode = await _md_reader.to_bbcode(content)
		message(bbcode, Color.DODGER_BLUE)
		_update_button.set_disabled(false)
		return
	var response :GdUnitUpdateClient.HttpResponse = await _update_client.request_releases()
	if response.code() == 200:
		var content :String = await extract_releases(response, _current_version)
		# finally force rescan to import images as textures
		if Engine.is_editor_hint():
			await rescan()
		message(content, Color.DODGER_BLUE)
		_update_button.set_disabled(false)
	else:
		message_h4("\n\n\nError checked request available releases!", Color.RED)


static func extract_latest_version(response :GdUnitUpdateClient.HttpResponse) -> GdUnit4Version:
	var body :Array = response.response()
	return GdUnit4Version.parse(body[0]["name"])


static func extract_zip_url(response :GdUnitUpdateClient.HttpResponse) -> String:
	var body :Array = response.response()
	return body[0]["zipball_url"]


func extract_releases(response :GdUnitUpdateClient.HttpResponse, current_version) -> String:
	await get_tree().process_frame
	var result :String = ""
	for release in response.response():
		if GdUnit4Version.parse(release["tag_name"]).equals(current_version):
			break
		var release_description :String = release["body"]
		var bbcode = await _md_reader.to_bbcode(release_description)
		result += bbcode
		result += "\n"
	return result


func rescan(update_scripts :bool = false) -> void:
	await get_tree().process_frame
	if Engine.is_editor_hint():
		var plugin := EditorPlugin.new()
		var fs := plugin.get_editor_interface().get_resource_filesystem()
		fs.scan_sources()
		while fs.is_scanning():
			await get_tree().create_timer(1).timeout
		if update_scripts:
			plugin.get_editor_interface().get_resource_filesystem().update_script_classes()
		plugin.free()


func run_update() -> void:
	_update_button.disabled = true
	_close_button.disabled = true
	var paths := _prepare_update()
	var zip_file = paths.get("zip_file")
	var tmp_path = paths.get("tmp_path")
	
	message_h4("\nRun Update ... [img=24x24]%s[/img]" % spinner_icon, Color.SNOW)
	
	await update_progress("Downloading update ..")
	var response :GdUnitUpdateClient.HttpResponse
	if _debug_mode:
		response = GdUnitUpdateClient.HttpResponse.new(200, PackedByteArray())
		zip_file = "res://update.zip"
	else:
		response = await _update_client.request_zip_package(_download_zip_url, zip_file)
	if response.code() != 200:
		push_warning("Update information cannot be retrieved from GitHub! \n Error code: %d : %s" % [response.code(), response.response()])
		await update_progress("Update failed! Try it later again.")
		await get_tree().create_timer(3).timeout
		stop_progress()
		return
	
	# extract zip to tmp
	await update_progress("Extracting zip '%s' to '%s'" % [zip_file, tmp_path])
	var result := GdUnitTools.extract_zip(zip_file, tmp_path)
	if result.is_error():
		await update_progress("Update failed! %s" % result.error_message())
		await get_tree().create_timer(3).timeout
		stop_progress()
		enable_gdUnit()
		return
	
	await update_progress("Disable GdUnit4 ..")
	# remove_at update content to prevent resource loading issues during update (deleted resources)
	# close gdUnit scripts before update
	if not _debug_mode:
		ScriptEditorControls.close_open_editor_scripts()
	disable_gdUnit()
	
	# delete the old version at first
	await update_progress("Uninstall GdUnit4 ..")
	if not _debug_mode:
		GdUnitTools.delete_directory("res://addons/gdUnit4/")
	
	await update_progress("Install new GdUnit4 version ..")
	if _debug_mode:
		GdUnitTools.copy_directory(tmp_path, "res://debug", true)
	else:
		GdUnitTools.copy_directory(tmp_path, "res://", true)
	
	await update_progress("Executing patches ..")
	_patcher.execute()
	stop_progress()
	
	message("New GdUnit version successfully installed", Color.DODGER_BLUE)
	message_h4("\nRestarting Godot ... [img=24x24]%s[/img]" % spinner_icon, Color.SNOW, false)
	await get_tree().create_timer(4).timeout
	enable_gdUnit()
	ProjectSettings.save()
	await get_tree().process_frame
	restart_godot()


func is_update_in_progress() -> bool:
	return _update_in_progress


func init_progress(max_value : int) -> void:
	_progress_panel.show()
	_progress_panel.move_to_front()
	_progress_bar.max_value = max_value
	_progress_bar.value = 0


func stop_progress() -> void:
	_progress_panel.hide()


func update_progress(message :String) -> void:
	_progress_content.text = message
	_progress_bar.value += 1
	if _debug_mode:
		await get_tree().create_timer(3).timeout
	else:
		await get_tree().process_frame
	prints("..", message)


func _prepare_update() -> Dictionary:
	init_progress(7)
	var tmp_path := GdUnitTools.create_temp_dir("update")
	var zip_file := tmp_path + "/update.zip"
	# cleanup old download data
	GdUnitTools.delete_directory(tmp_path, true)
	return {
		"tmp_path" : tmp_path,
		"zip_file" : zip_file
	}


func _on_update_pressed():
	_update_in_progress = true
	await run_update()


static func enable_gdUnit() -> void:
	if Engine.is_editor_hint():
		var plugin := EditorPlugin.new()
		plugin.get_editor_interface().set_plugin_enabled("gdUnit4", true)
		plugin.free()


static func disable_gdUnit() -> void:
	if Engine.is_editor_hint():
		var plugin := EditorPlugin.new()
		plugin.get_editor_interface().set_plugin_enabled("gdUnit4", false)
		plugin.free()


static func restart_godot() -> void:
	if Engine.is_editor_hint():
		var plugin := EditorPlugin.new()
		plugin.get_editor_interface().restart_editor(true)
		plugin.free()


func _on_show_next_toggled(enabled :bool):
	GdUnitSettings.set_update_notification(enabled)


func _on_cancel_pressed():
	hide()


func _on_content_meta_clicked(meta :String):
	var properties = str_to_var(meta)
	if properties.has("url"):
		OS.shell_open(properties.get("url"))


func _on_content_meta_hover_started(meta :String):
	var properties = str_to_var(meta)
	if properties.has("tool_tip"):
		_content.set_tooltip_text(properties.get("tool_tip"))


func _on_content_meta_hover_ended(meta):
	_content.set_tooltip_text("")
