class_name TooltipSettings extends Control


@onready var panel: Panel = $Panel

var is_visible: bool = false



func _ready():
	var __ = InputManager.tap.connect(_on_tap_input)
	
	mouse_filter = Control.MOUSE_FILTER_STOP


func show_content() -> void:
	visible = true
	is_visible = true


func is_black_veil(pos: Vector2) -> bool:
	var panel_rect = panel.get_global_rect()
	
	if panel_rect.has_point(pos):
		return false
	
	return true


func close_tooltip() -> void:
	is_visible = false
	visible = false


func _on_tap_input(pos):
	if not visible:
		return
	
	if is_black_veil(pos):
		close_tooltip()
