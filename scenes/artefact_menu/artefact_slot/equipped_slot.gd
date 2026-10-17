class_name EquippedSlot extends ArtefactSlot


func set_item(new_item: Item):
	artefact = new_item
	
	if artefact == null:
		icon = null
		return
		
	icon = artefact.icon
