class_name InventorySlot extends Button

@onready var slot_icon: TextureRect = $SlotIcon

@export var inventory_index: int

var item: Item


func _ready():
	add_to_group("inventory_item_slots")
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE


func set_item(new_item: Item):
	item = new_item
	
	if item == null:
		slot_icon.texture = null
		return
	
	slot_icon.texture = item.description.icon


func get_item() -> Item:
	return item
