@tool
extends Window

signal request_completed(response)

const GdMarkDownReader = preload("res://addons/gdUnit4/src/update/GdMarkDownReader.gd")
const GdUnitUpdateClient = preload("res://addons/gdUnit4/src/update/GdUnitUpdateClient.gd")
const spinner_icon := "res://addons/gdUnit4/src/ui/assets/spinner.tres"

@onready var _md_reader :GdMarkDownReader = GdMarkDownReader.new()
@onready var _update_client :GdUnitUpdateClient = $GdUnitUpdateClient
@onready var _header :Label = $Panel/GridContainer/PanelContainer/header
@onready var _update_button :Button = $Panel/GridContainer/Panel/HBoxContainer/update
@onready var _content :RichTextLabel = $Panel/GridContainer/PanelContainer2/ScrollContainer/MarginContainer/content
@onready var _progress_panel :Control = $Panel/UpdateProgress
@onready var _progress_content :Label = $Panel/UpdateProgress/Progress/label
@onready var _progress_bar :ProgressBar = $Panel/UpdateProgress/Progress/bar

var _debug_mode := false

var _patcher :GdUnitPatcher = GdUnitPatcher.new()
var _current_version := GdUnit4Version.current()
var _available_versions :Array
var _show_update :bool = false
var _download_zip_url :String
var _update_in_progress :bool = false


func _ready():
	#set_theme(ThemeDB.get_default_theme().duplicate())
	#prints("get_default_theme", ThemeDB.get_default_theme())
	#prints("get_project_theme", ThemeDB.get_project_theme())
	#theme_changed.emit(theme)
	_update_button.disabled = true
	_md_reader.set_http_client(_update_client)
	GdUnitFonts.init_fonts(_content)
	request_releases()
	if _debug_mode:
		size = Vector2(1024, 800)


func request_releases() -> void:
	if _debug_mode:
		_header.text = "Debug mode"
		_show_update = true
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
		_show_update = true


func _colored(message :String, color :Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(), message]


func _h4_message(message :String, color :Color) -> String:
	return "[font_size=16]%s[/font_size]" % _colored(message, color)


func _process(_delta):
	if _show_update:
		_content.clear()
		_content.append_text(_h4_message("\n\n\nRequest release infos ... [img=24x24]%s[/img]" % spinner_icon, Color.SNOW))
		popup_centered_ratio(.5)
		_show_update = false
		_content.clear()
		if _debug_mode:
			popup_centered_ratio(.5)
			var content :String = FileAccess.open("res://addons/gdUnit4/test/update/resources/markdown.txt", FileAccess.READ).get_as_text()
			var bbcode = await _md_reader.to_bbcode(content)
			_content.append_text(bbcode)
			_update_button.set_disabled(false)
			return
		var response :GdUnitUpdateClient.HttpResponse = await _update_client.request_releases()
		if response.code() == 200:
			var content :String = await extract_releases(response, _current_version)
			# finally force rescan to import images as textures
			if Engine.is_editor_hint():
				await rescan()
			_content.append_text(content)
			_update_button.set_disabled(false)
		else:
			_content.append_text(_h4_message("\n\n\nError checked request available releases!", Color.RED))


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


func is_update_in_progress() -> bool:
	return _update_in_progress


func init_progress(max_value : int) -> void:
	_progress_panel.show()
	_progress_bar.max_value = max_value
	_progress_bar.value = 0


func stop_progress() -> void:
	_progress_panel.hide()


func update_progress(message :String) -> void:
	_progress_content.text = message
	_progress_bar.value += 1
	await get_tree().process_frame
	prints("Update ..", message)


func _prepare_update() -> Dictionary:
	_update_in_progress = true
	init_progress(9)
	update_progress("Downloading update ..")
	var tmp_path := GdUnitTools.create_temp_dir("update")
	var zip_file := tmp_path + "/update.zip"
	# cleanup old download data
	GdUnitTools.delete_directory(tmp_path, true)
	return {
		"tmp_path" : tmp_path,
		"zip_file" : zip_file
	}


func _on_update_pressed():
	var paths := _prepare_update()
	var zip_file = paths.get("zip_file")
	var tmp_path = paths.get("tmp_path")
	
	_content.clear()
	_content.append_text(_h4_message("\nRun Update ... [img=24x24]%s[/img]" % spinner_icon, Color.SNOW))
	
	var response :GdUnitUpdateClient.HttpResponse
	if _debug_mode:
		response = GdUnitUpdateClient.HttpResponse.new(200, PackedByteArray())
		zip_file = "res://update.zip"
	else:
		response = await _update_client.request_zip_package(_download_zip_url, zip_file)
	if response.code() != 200:
		push_warning("Update information cannot be retrieved from GitHub! \n Error code: %d : %s" % [response.code(), response.response()])
		update_progress("Update failed! Try it later again.")
		await get_tree().create_timer(3).timeout
		stop_progress()
		return
	update_progress("disable GdUnit3 ..")
	
	# remove_at update content to prevent resource loading issues during update (deleted resources)
	# close gdUnit scripts before update
	if !_debug_mode:
		ScriptEditorControls.close_open_editor_scripts()
	disable_gdUnit()
	
	# extract zip to tmp
	update_progress("extracting zip '%s' to '%s'" % [zip_file, tmp_path])
	var result := GdUnitTools.extract_zip(zip_file, tmp_path)
	if result.is_error():
		update_progress("Update failed! %s" % result.error_message())
		await get_tree().create_timer(3).timeout
		stop_progress()
		enable_gdUnit()
		return
	
	# delete the old version at first
	update_progress("uninstall GdUnit4 ..")
	#GdUnitTools.delete_directory("res://addons/gdUnit4/")
	
	update_progress("install new GdUnit4 version ..")
	GdUnitTools.copy_directory(tmp_path, "res://addons_test", true)
	
	update_progress("refresh editor resources ..")
	await rescan(true)
	
	update_progress("executing patches ..")
	_patcher.execute()
	
	update_progress("enable GdUnit4 ..")
	await get_tree().create_timer(.5).timeout
	update_progress("New GdUnit successfully installed")
	stop_progress()
	_content.text = _colored("New GdUnit version successfully installed", Color.SNOW)
	await get_tree().create_timer(1).timeout
	hide()
	enable_gdUnit()
	queue_free()
	await get_tree().process_frame


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


func _on_show_next_toggled(enabled :bool):
	GdUnitSettings.set_update_notification(enabled)


func _on_cancel_pressed():
	hide()
	queue_free()


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
