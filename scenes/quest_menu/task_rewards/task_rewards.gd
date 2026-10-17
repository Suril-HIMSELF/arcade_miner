class_name Reward extends Control


@onready var reward_icon: TextureRect = $RewardIcon
@onready var reward_label: Label = $RewardLabel


func setup(reward_data: OreQuantity) -> void:
	reward_icon.texture = Utils.get_ore_icon(reward_data.ore)
	reward_label.text = str(reward_data.quantity)
