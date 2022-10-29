@tool
extends MarginContainer

@onready var _template_editor :TextEdit = $ScrollContainer/VBoxContainer/Editor
@onready var _tags_editor :TextEdit = $Tags/MarginContainer/TextEdit
@onready var _title_bar :Panel = $ScrollContainer/VBoxContainer/sub_category
@onready var _save_button :Button = $ScrollContainer/VBoxContainer/Panel/HBoxContainer/Save
@onready var _tag_container :Container = $ScrollContainer/VBoxContainer/Editor/MarginContainer
@onready var _selected_type :OptionButton = $ScrollContainer/VBoxContainer/Editor/MarginContainer/HBoxContainer/SelectType
@onready var _show_tags :Popup = $Tags

var gd_key_words := ["extends", "class_name", "const", "var", "onready", "func", "void", "pass"]
var gdunit_key_words := ["GdUnitTestSuite", "before", "after", "before_test", "after_test"]
var _selected_template :int

func _ready():
	setup_editor_colors()
	setup_fonts()
	setup_supported_types()
	load_template(GdUnitTestSuiteTemplate.TEMPLATE_ID_GD)
	setup_tags_help()

func _notification(what):
	if what == EditorSettings.NOTIFICATION_EDITOR_SETTINGS_CHANGED:
		setup_fonts()

func setup_editor_colors() -> void:
	if not Engine.is_editor_hint():
		return
	var plugin := EditorPlugin.new()
	var settings := plugin.get_editor_interface().get_editor_settings()
	var background_color :Color = settings.get_setting("text_editor/highlighting/background_color")
	var text_color :Color = settings.get_setting("text_editor/highlighting/text_color")
	var selection_color :Color = settings.get_setting("text_editor/highlighting/selection_color")
	var comment_color :Color = settings.get_setting("text_editor/highlighting/comment_color")
	var keyword_color :Color = settings.get_setting("text_editor/highlighting/keyword_color")
	var base_type_color :Color = settings.get_setting("text_editor/highlighting/base_type_color")
	plugin.free()
	
	for e in [_template_editor, _tags_editor]:
		var editor :TextEdit = e
		editor.add_theme_color_override("background_color", background_color)
		editor.add_theme_color_override("font_color", text_color)
		editor.add_theme_color_override("font_color_readonly", text_color)
		editor.add_theme_color_override("font_color_selected", selection_color)
		editor.add_color_region("#", "", comment_color, true)
		editor.add_color_region("${", "}", Color.YELLOW)
		
		for word in gd_key_words:
			editor.add_keyword_color(word, keyword_color)
		for word in gdunit_key_words:
			editor.add_keyword_color(word, base_type_color)

func setup_fonts() -> void:
	if _template_editor:
		GdUnitFonts.init_fonts(_template_editor)
		var font_size = GdUnitFonts.init_fonts(_tags_editor)
		_title_bar.size.y = font_size + 16
		_title_bar.custom_minimum_size.y = font_size + 16
		_tag_container.position.y = 400-font_size*2

func setup_supported_types() -> void:
	_selected_type.clear()
	_selected_type.add_item("GD - GDScript", GdUnitTestSuiteTemplate.TEMPLATE_ID_GD)
	_selected_type.add_item("C# - CSharpScript", GdUnitTestSuiteTemplate.TEMPLATE_ID_CS)

func setup_tags_help() -> void:
	_tags_editor.set_text(GdUnitTestSuiteTemplate.load_tags(_selected_template))

func load_template(template_id :int) -> void:
	_selected_template = template_id
	_template_editor.set_text(GdUnitTestSuiteTemplate.load_template(template_id))

func _on_Restore_pressed():
	_template_editor.set_text(GdUnitTestSuiteTemplate.default_template(_selected_template))
	GdUnitTestSuiteTemplate.reset_to_default(_selected_template)
	_save_button.disabled = true

func _on_Save_pressed():
	GdUnitTestSuiteTemplate.save_template(_selected_template, _template_editor.get_text())
	_save_button.disabled = true

func _on_Tags_pressed():
	_show_tags.popup_centered_ratio(.5)

func _on_Editor_text_changed():
	_save_button.disabled = false

func _on_SelectType_item_selected(index):
	load_template(_selected_type.get_item_id(index))
	setup_tags_help()
