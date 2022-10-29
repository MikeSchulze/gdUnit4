@tool
class_name GdUnitUpdate
extends Window

signal request_completed(response)

@onready var _md_reader :GdMarkDownReader = $GdMarkDownReader
@onready var _update_client :GdUnitUpdateClient = $GdUnitUpdateClient
@onready var _header :Label = $GridContainer/PanelContainer/header
@onready var _content :RichTextLabel = $GridContainer/PanelContainer2/ScrollContainer/content
@onready var _info_popup :Popup = $UpdateProgress
@onready var _info_content :Label = $UpdateProgress/Progress/label
@onready var _info_progress :ProgressBar = $UpdateProgress/Progress/bar
@onready var _update_button :Button = $GridContainer/Panel/HBoxContainer/update

const MENU_ACTION_FILE_CLOSE_ALL = 13

var _patcher :GdUnitPatcher = GdUnitPatcher.new()
var _current_version := GdUnit4Version.current()
var _available_versions :Array
var _show_update :bool = false
var _download_zip_url :String
var _update_in_progress :bool = false

func _ready():
	_update_button.disabled = true
	_md_reader.set_http_client(_update_client)
	request_releases()

func request_releases():
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
	return "[font=res://addons/gdUnit4/src/update/assets/fonts/RobotoMono-h4.tres]%s[/font]" % _colored(message, color)

func _process(_delta):
	if _show_update:
		var spinner := "res://addons/gdUnit4/src/ui/assets/spinner.tres"
		_content.text = _h4_message("\n\n\nRequest release infos ... [img=24x24]%s[/img]" % spinner, Color.SNOW)
		popup_centered_ratio(.5)
		_show_update = false
		var response :GdUnitUpdateClient.HttpResponse = await _update_client.request_releases()
		if response.code() == 200:
			var content :String = await extract_releases(response, _current_version)
			# finally force rescan to import images as textures
			if Engine.is_editor_hint():
				await rescan()
			_content.text = content
			_update_button.set_disabled(false)
		else:
			_content.text = _h4_message("\n\n\nError checked request available releases!", Color.RED)

static func extract_latest_version(response :GdUnitUpdateClient.HttpResponse) -> GdUnit4Version:
	var body :Array = response.response()
	return GdUnit4Version.parse(body[0]["name"])

static func extract_zip_url(response :GdUnitUpdateClient.HttpResponse) -> String:
	var body :Array = response.response()
	return body[0]["zipball_url"]

func extract_releases(response :GdUnitUpdateClient.HttpResponse, current_version :) -> String:
	await get_tree().idle_frame
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
	await get_tree().idle_frame
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
	_info_popup.popup_centered_clamped()
	_info_progress.max_value = max_value
	_info_progress.value = 0

func stop_progress() -> void:
	_info_popup.hide()

func update_progress(message :String) -> void:
	_info_content.text = message
	_info_progress.value += 1
	prints("Update ..", message)

static func close_open_editor_scripts() -> void:
	var plugin := EditorPlugin.new()
	var script_editor := plugin.get_editor_interface().get_script_editor()
	prints("Closing all currently opened scripts ..")
	script_editor._menu_option(MENU_ACTION_FILE_CLOSE_ALL)
	plugin.free()

func delete_obsolete_files() -> void:
	
	for file_to_delete in ["res://gdUnit4.csproj", "res://gdUnit4.sln"]:
		if FileAccess.file_exists(file_to_delete):
			DirAccess.remove_absolute(file_to_delete)

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
	
	var response :GdUnitUpdateClient.HttpResponse = await _update_client.request_zip_package(_download_zip_url, zip_file)
	if response.code() != 200:
		push_warning("Update information cannot be retrieved from GitHub! \n Error code: %d : %s" % [response.code(), response.response()])
		update_progress("Update failed! Try it later again.")
		await get_tree().create_timer(3).timeout
		stop_progress()
		return
	update_progress("disable GdUnit3 ..")
	
	# remove_at update content to prevent resource loading issues during update (deleted resources)
	_content.text = ""
	_content.text = _colored("### Updating ...", Color.SNOW)
	# close gdUnit scripts before update
	close_open_editor_scripts()
	disable_gdUnit()
	
	# extract zip to tmp
	var source := ProjectSettings.globalize_path(zip_file)
	var dest := ProjectSettings.globalize_path(tmp_path)
	
	update_progress("extracting zip '%s' to '%s'" % [source, dest])
	var result := GdUnitTools.extract_package(source, dest)
	if result.is_error():
		update_progress("Update failed! %s" % result.error_message())
		await get_tree().create_timer(3).timeout
		stop_progress()
		enable_gdUnit()
		return
	
	# find extracted directory name
	var dir := DirAccess.open(tmp_path)
	dir.list_dir_begin() # TODO GODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() and file_name.begins_with("MikeSchulze-gdUnit4"):
			break
		file_name = dir.get_next()
	var source_dir = tmp_path + "/" + file_name
	
	# delete the old version at first
	update_progress("uninstall GdUnit3 ..")
	GdUnitTools.delete_directory("res://addons/gdUnit4/")
	GdUnitTools.delete_directory("res://addons/GdCommons/")
	
	update_progress("install new GdUnit3 version ..")
	GdUnitTools.copy_directory(source_dir, "res://", true)
	delete_obsolete_files()
	
	update_progress("refresh editor resources ..")
	await rescan(true)
	
	update_progress("executing patches ..")
	_patcher.execute()
	
	update_progress("enable GdUnit3 ..")
	await get_tree().create_timer(.5).timeout
	update_progress("New GdUnit successfully installed")
	await get_tree().create_timer(1).timeout
	hide()
	enable_gdUnit()
	queue_free()

static func enable_gdUnit() -> void:
	var plugin := EditorPlugin.new()
	plugin.get_editor_interface().set_plugin_enabled("gdUnit4", true)
	plugin.free()

static func disable_gdUnit() -> void:
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
		_content.set_tooltip(properties.get("tool_tip"))

func _on_content_meta_hover_ended(meta):
	_content.set_tooltip("")
