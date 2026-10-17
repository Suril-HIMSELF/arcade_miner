class_name EquipmentSlot extends InventorySlot

@export var slot_type: Enums.ITEM_TYPE


func _ready():
	add_to_group("inventory_equipment_slots")
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE


func set_item(new_item: Item):
	item = new_item
	
	if item == null:
		match slot_type:
			Enums.ITEM_TYPE.PICKAXE: slot_icon.texture = load("res://assets/icons/pickaxe_empty.png")
			Enums.ITEM_TYPE.HELMET: slot_icon.texture = load("res://assets/icons/helmet_empty.png")
			Enums.ITEM_TYPE.LANTERN: slot_icon.texture = load("res://assets/icons/lantern_empty.png")
			Enums.ITEM_TYPE.JEWEL: slot_icon.texture = load("res://assets/icons/jewel_empty.png")
		return
	
	if item.type != Enums.ITEM_TYPE.ARTEFACT:
		var icon = Utils.get_item_icon(item.type, item.description.id, item.rarity)
		
		slot_icon.texture = icon
	else:
		slot_icon.texture = item.icon
