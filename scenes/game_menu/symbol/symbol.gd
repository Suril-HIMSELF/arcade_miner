class_name Symbol extends Control

@onready var icon: TextureRect = $Icon


@export var ore: Enums.ORE = Enums.ORE.STONE
@export var shape: Enums.SHAPE = Enums.SHAPE.RIGHT


func _ready() -> void:
	icon.texture = Utils.get_symbol_icon(ore, shape)
