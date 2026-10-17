extends Node2D

@onready var sprite_100: Sprite2D = $Sprite100
@onready var sprite_75: Sprite2D = $Sprite75
@onready var sprite_50: Sprite2D = $Sprite50
@onready var sprite_25: Sprite2D = $Sprite25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_100.visible = true
	sprite_75.visible = false
	sprite_50.visible = false
	sprite_25.visible = false
