extends Node

signal inventory_item_updated
signal equipment_item_updated
signal inventory_artefact_updated
signal equipment_artefact_updated
signal item_equipped(item)
signal item_unequipped(item)
signal item_deleted
signal artefact_equipped(item)
signal artefact_unequipped(item)
signal inventory_item_resized
signal inventory_item_changed
signal stat_changed

var INVENTORY_SIZE: int


func initialize() -> void:
	INVENTORY_SIZE = GameManager.stats[Enums.STAT.INVENTORY_SLOTS]


func resize_inventory_items(new_size: int):
	if new_size == GameManager.inventory_items.size():
		return

	GameManager.inventory_items.resize(new_size)

	inventory_item_resized.emit()


func _on_item_crafted() -> void:
	inventory_item_updated.emit()
