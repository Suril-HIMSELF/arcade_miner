class_name ArtefactSlot extends Button

@export var inventory_index: int
@export var artefact: Item


func set_item(new_item: Item):
	artefact = new_item
	
	if artefact == null:
		return
	
	if is_unlocked():
		icon = artefact.icon


func get_item() -> Item:
	return artefact


func is_unlocked() -> bool:
	return GameManager.artefact_states.get(inventory_index) == 1.0
