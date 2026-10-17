class_name TooltipForge extends Control


@onready var panel: PanelContainer = $Panel

@onready var title: Label = $Panel/VBoxContainer/Header/TitleContainer/Title
@onready var rarity: Label = $Panel/VBoxContainer/Header/TitleContainer/Rarity
@onready var icon: TextureRect = $Panel/VBoxContainer/Header/Button/Icon
@onready var description: Label = $Panel/VBoxContainer/DescriptionPanel/Description

@onready var content: VBoxContainer = $Panel/VBoxContainer/ContentPanel/Content


var current_id
var anchor_node = null
var is_visible: bool = false
var item : Item

signal delete_item(item)


func _ready():
	var __ = InputManager.tap.connect(_on_tap_input)
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	visible = false


func show_item(_item: Item) -> void:
	visible = true
	is_visible = true
	item = _item
	
	title.text = tr(_item.description.name_key).to_upper()
	rarity.text = tr(Constants.RARITY_NAME[item.rarity]) 
	rarity.add_theme_color_override("font_color", Utils.get_rarity_color(item.rarity))
	
	icon.texture = _item.icon
	description.text = tr(_item.description.description_key)
	
	for label in content.get_children():
		label.queue_free()
	
	for stat in _item.stats:
		var container = HBoxContainer.new()
		
		container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var stat_label = Label.new()
		stat_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		stat_label.custom_minimum_size.y = 50
		stat_label.horizontal_alignment= HORIZONTAL_ALIGNMENT_LEFT
		stat_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		stat_label.add_theme_font_size_override("font_size", 30)
		stat_label.text = tr(Utils.get_stat_name(stat.stat)) + " : "
		stat_label.tooltip_text = tr(Utils.get_stat_description(stat.stat))
		
		var value_label = Label.new()
		value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		value_label.custom_minimum_size.y = 50
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		value_label.add_theme_font_size_override("font_size", 30)
		value_label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0, 1.0))
		var value_text = Utils.display_stat_value(stat.value, stat.mode)
		
		value_label.text = value_text
		
		container.add_child(stat_label)
		container.add_child(value_label)
		
		content.add_child(container)
		
	panel.call_deferred("reset_size")
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)


func is_black_veil(pos: Vector2) -> bool:
	var panel_rect = panel.get_global_rect()
	
	if panel_rect.has_point(pos):
		return false
	
	return true


func close_tooltip() -> void:
	is_visible = false
	visible = false
	item = null


func _on_tap_input(pos):
	if not visible:
		return
	
	if is_black_veil(pos):
		close_tooltip()


func _on_delete_button_pressed() -> void:
	delete_item.emit(item)
	
	close_tooltip()


func _on_keep_button_pressed() -> void:
	close_tooltip()
