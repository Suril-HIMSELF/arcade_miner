extends Control

@onready var sequence_panel: Panel = $SequencePanel
@onready var stone_sprite: Node2D = $StoneSprite
@onready var ore_life: Panel = $OreLife


const SPRITE_Y_RATIO = 1200.0 / 1920.0

func _ready() -> void:
	update_sprite_position()
	sequence_panel.position.y = stone_sprite.position.y - 350 - sequence_panel.size.y


func update_sprite_position():
	var screen = get_viewport_rect().size

	stone_sprite.position.x = screen.x / 2
	stone_sprite.position.y = screen.y * SPRITE_Y_RATIO
	
	ore_life.position.y = stone_sprite.position.y + 150
	
	
