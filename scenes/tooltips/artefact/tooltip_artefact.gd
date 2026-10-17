class_name TooltipArtefact extends Control


@onready var panel: Panel = $Panel

@onready var title: Label = $Panel/VBoxContainer/Header/TitleContainer/Title
@onready var icon: Button = $Panel/VBoxContainer/Header/Icon
@onready var description: Label = $Panel/VBoxContainer/DescriptionPanel/Description

@onready var content: VBoxContainer = $Panel/VBoxContainer/ContentPanel/Content

@onready var footer: VBoxContainer = $Panel/VBoxContainer/Footer
@onready var button: Button = $Panel/VBoxContainer/Footer/Button

var artefact: Item
var artefact_id: int
var is_visible: bool = false

signal button_pressed
signal tooltip_closed


func _ready():
	var __ = InputManager.tap.connect(_on_tap_input)
	
	artefact = null
	mouse_filter = Control.MOUSE_FILTER_STOP


func show_item(item: Item) -> void:
	visible = true
	is_visible = true
	
	artefact = item
	
	title.text = tr(item.description.name_key)
	icon.icon = item.icon
	description.text = tr(item.description.description_key)
	
	for label in content.get_children():
		label.queue_free()
	
	for stat in item.stats:
		var container = HBoxContainer.new()
		
		container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var stat_label = Label.new()
		stat_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		stat_label.custom_minimum_size.y = 50
		stat_label.horizontal_alignment= HORIZONTAL_ALIGNMENT_LEFT
		stat_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		stat_label.add_theme_font_size_override("font_size", 26)
		stat_label.text = tr(Utils.get_stat_name(stat.stat)) + " : "
		stat_label.tooltip_text = tr(Utils.get_stat_description(stat.stat))
		
		var value_label = Label.new()
		value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		value_label.custom_minimum_size.y = 50
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		value_label.add_theme_font_size_override("font_size", 26)
		value_label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0, 1.0))
		var value_text = Utils.display_stat_value(stat.value, stat.mode)
		
		value_label.text = value_text
		
		container.add_child(stat_label)
		container.add_child(value_label)
		
		content.add_child(container)
	
	if artefact == null or artefact.hash != GameManager.equipped_artefact:
		button.text = tr("TOOLTIP_INVENTORY_BUTTON_EQUIP")
	else:
		button.text = tr("TOOLTIP_INVENTORY_BUTTON_UNEQUIP")


func is_black_veil(pos: Vector2) -> bool:
	var panel_rect = panel.get_global_rect()
	
	if panel_rect.has_point(pos):
		return false
	
	return true


func close_tooltip() -> void:
	is_visible = false
	visible = false
	artefact = null


func _on_tap_input(pos):
	if is_black_veil(pos):
		close_tooltip()


func _on_button_pressed() -> void:
	button_pressed.emit()
