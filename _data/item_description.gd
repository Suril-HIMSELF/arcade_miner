class_name ItemDescription extends Resource

@export var id: int
@export var name_key: StringName
@export var type: Enums.ITEM_TYPE
@export var rarity: Enums.RARITY
@export var description_key: StringName
@export var icon: Texture2D


func _init(_name_key: StringName = "", _description_key: StringName = ""):
	id = 0
	name_key = _name_key
	description_key = _description_key
