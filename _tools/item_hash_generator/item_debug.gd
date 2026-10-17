@tool
extends Node

@export var item_type: Enums.ITEM_TYPE
@export var item_rarity: Enums.RARITY
@export var item_stats: Array[StatValue]
@export var item_description: ItemDescription
@export var generate_item_hash := false:
	set(value):
		generate_item_hash = false

		if value:
			_generate_hash()



func _generate_hash():
	var item := Item.new()
	
	item.description = item_description
	item.type = item_type
	item.rarity = item_rarity

	for i in item_stats.size():
		item.stats.append(item_stats[i])

	item.hash = ItemFactory.build_hash(item)

	print("-----------------------------")
	print("ITEM HASH GENERATED")
	print(item.hash)
	print("-----------------------------")

	print(
		"VALID : ",
		ItemFactory.validate_hash(item.hash)
	)
