extends Button


@onready var ore_icon: TextureRect = $OreIcon
@onready var ore_cost: Label = $OreCost


func setup(ore: Enums.ORE, price: int) -> void:
	ore_icon.texture = Utils.get_ore_icon(ore)
	ore_cost.text = str(price)
