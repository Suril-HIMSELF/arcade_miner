class_name OreQuantity extends Resource

@export var ore: Enums.ORE
@export var quantity: int = 0


func _init(_ore: Enums.ORE = Enums.ORE.STONE, _quantity: int = 0):
	ore = _ore
	quantity = _quantity
