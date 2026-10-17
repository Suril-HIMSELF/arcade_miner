class_name StatDefinition extends Resource


@export var id: Enums.STAT
@export var name: String
@export var description: String
@export var rarity: Enums.RARITY # Rareté de la stat
@export var tags: Array[Enums.STAT_TAG]
@export var mode: Enums.STAT_MODE
@export var bonus_min: float
@export var bonus_max: float
@export var item_affinity: Array[Enums.ITEM_TYPE] # Affinité avec item
@export var ore_affinity: Array[Enums.ORE] # Affinité avec minerai
