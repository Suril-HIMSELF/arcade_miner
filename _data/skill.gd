class_name Skill extends Resource

@export var id: Enums.SKILL
@export var name: String
@export_multiline var description: String
@export var primary_icon: Texture2D
@export var secondary_icon: Texture2D
@export var stat: StatDefinition
@export var bonus: float
@export var max_level: int

@export var cost: Array[OreQuantity]
