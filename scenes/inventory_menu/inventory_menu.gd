class_name InventoryMenu extends Control

@onready var main_menu: MainMenu = $"../.."

@onready var equipment_panel: Panel = $MarginContainer/VBoxContainer/EquipmentPanel
@onready var inventory_panel: Panel = $MarginContainer/VBoxContainer/InventoryPanel

@onready var inventory_slots: GridContainer = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots
@onready var equipment_slots: HBoxContainer = $MarginContainer/VBoxContainer/EquipmentPanel/EquipmentSlots
@onready var drag_preview: Control = $DragPreview
@onready var tooltip: TooltipInventory = $Tooltip/Control


var drag_active: bool = false
var dragged_data: Dictionary = {"type": "", "index": -1, "slot_type": -1, "item": null}
var item_shown: Item
var drag_position := Vector2.ZERO

const INVENTORY_SLOT_SCENE = preload("res://scenes/inventory_menu/inventory_slot/inventory_slot.tscn")


func _ready():
	_create_inventory_slots()
	
	tooltip.visible = false
	
	var __ = InputManager.tap.connect(_on_tap_inventory)
	__ = InputManager.hold.connect(_on_hold_inventory)
	__ = InventoryManager.inventory_item_updated.connect(refresh_inventory)
	__ = InventoryManager.equipment_item_updated.connect(refresh_equipment)
	__ = InventoryManager.inventory_item_resized.connect(_on_inventory_resized)
	__ = InventoryManager.item_deleted.connect(_on_item_deleted)
	__ = InputManager.release.connect(_on_release)
	__ = tooltip.delete_item.connect(_on_delete_button_pressed)
	__ = SkillTreeManager.skill_inventory_bought.connect(_on_skill_inventory_bought)
	__ = ItemFactory.item_crafted.connect(_on_item_crafted)
	__ = InputManager.drag.connect(_on_drag)
	__ = tooltip.equip_item.connect(_on_equip_button_pressed)
	
	refresh_inventory()
	refresh_equipment()
	
	drag_preview.visible = false


func _on_drag(pos: Vector2):
	if !drag_active:
		return

	drag_position = pos
	drag_preview.global_position = pos - drag_preview.size * 0.5


func _create_inventory_slots():
	# CLEANUP SI REBUILD
	for child in inventory_slots.get_children():
		child.queue_free()

	# CREATE
	for i in range(GameManager.stats[Enums.STAT.INVENTORY_SLOTS]):
		var slot: InventorySlot = INVENTORY_SLOT_SCENE.instantiate()

		slot.inventory_index = i

		inventory_slots.add_child(slot)


func refresh_inventory():
	for i in GameManager.inventory_items.size():
		var inventory_slot = inventory_slots.get_child(i)
		var item_hash = GameManager.inventory_items[i]
		var item = null
		
		if not item_hash == "":
			item = ItemFactory.item_from_hash(item_hash)
		
		inventory_slot.set_item(item)


func refresh_equipment():
	for i in GameManager.equipment_items.size():
		var equipment_slot = equipment_slots.get_child(i)
		var item_hash = GameManager.equipment_items[i]
		var item = null
		
		if not item_hash.is_empty():
			item = ItemFactory.item_from_hash(item_hash)
		
		equipment_slot.set_item(item)


func refresh_inventory_slot(index: int):
	var inventory_slot = inventory_slots.get_child(index)
	var item_hash = GameManager.inventory_items[index]
	var item = null
		
	if not item_hash.is_empty():
		item = ItemFactory.item_from_hash(item_hash)
	
	inventory_slot.set_item(item)


func refresh_equipment_slot(item_type: int):
	var equipment_slot = equipment_slots.get_child(item_type)
	var item_hash = GameManager.equipment_items[item_type]
	var item = null
		
	if not item_hash.is_empty():
		item = ItemFactory.item_from_hash(item_hash)
	
	equipment_slot.set_item(item)


func _on_inventory_resized():
	_create_inventory_slots()
	refresh_inventory()


func _on_release(pos: Vector2):
	if !drag_active:
		return

	_finish_drag(pos)


func _on_tap_inventory(pos: Vector2):
	if not visible:
		return
	
	var slot = _get_slot_under_position(pos)
	
	if slot == null:
		return
	
	var item = slot.get_item()
	
	if item == null:
		return
	
	if slot is EquipmentSlot:
		item_shown = item
		tooltip.show_item(
			item,
			-1,
			slot.slot_type,
			_get_free_inventory_slot() != -1
		)
		
	elif slot is InventorySlot:
		item_shown = item
		tooltip.show_item(item, slot.inventory_index)


func _on_hold_inventory(pos: Vector2, _duration: float):
	var slot = _get_slot_under_position(pos)

	if slot == null:
		return

	var item = slot.get_item()

	if item == null:
		return

	if slot is EquipmentSlot:
		dragged_data.type = "equipment"
		dragged_data.slot_type = slot.slot_type

	elif slot is InventorySlot:
		dragged_data.type = "inventory"
		dragged_data.index = slot.inventory_index

	dragged_data.item = item

	drag_position = pos
	start_drag(item)


func start_drag(item: Item):
	drag_active = true
	tooltip.visible = false

	drag_preview.texture = item.description.icon
	drag_preview.visible = true

	drag_preview.global_position = drag_position - drag_preview.size * 0.5


func _finish_drag(pos: Vector2):
	drag_active = false
	drag_preview.visible = false

	var target = _get_slot_under_position(pos)

	if target != null and !tooltip.visible:
		try_move_item(target)

	_reset_drag_data()


func _reset_drag_data():
	dragged_data = {"type": "", "index": -1, "slot_type": -1, "item": null}


func _get_slot_under_position(pos: Vector2):
	for slot in get_tree().get_nodes_in_group("inventory_item_slots"):
		if slot.is_visible_in_tree() and _is_point_in_slot(slot, pos):
			return slot

	for slot in get_tree().get_nodes_in_group("inventory_equipment_slots"):
		if slot.is_visible_in_tree() and _is_point_in_slot(slot, pos):
			return slot

	return null


func _is_point_in_slot(slot: Control, pos: Vector2) -> bool:
	var rect = Rect2(slot.global_position, slot.size)
	return rect.has_point(pos)


func try_move_item(target_slot):
	if dragged_data.item == null:
		return
	
	# INVENTORY -> EQUIPMENT
	if dragged_data.type == "inventory" and target_slot is EquipmentSlot:
		
		if dragged_data.item.type == target_slot.slot_type:
			_inventory_to_equipment(dragged_data.index, target_slot)
		
		return
	
	# EQUIPMENT -> EQUIPMENT
	if dragged_data.type == "equipment" and target_slot is EquipmentSlot:
		return
	
	# EQUIPMENT -> INVENTORY
	if dragged_data.type == "equipment" and target_slot is InventorySlot:
		_equipment_to_inventory(dragged_data.slot_type, target_slot.inventory_index)
		
		return
	
	# INVENTORY -> INVENTORY
	if dragged_data.type == "inventory" and target_slot is InventorySlot:
		_inventory_to_inventory(dragged_data.index, target_slot.inventory_index)
		
		return


func _inventory_to_inventory(from_index: int, to_index: int):
	var item_hash_from_index = GameManager.inventory_items[from_index]
	var item_hash_to_index = GameManager.inventory_items[to_index]
	
	GameManager.inventory_items[from_index] = item_hash_to_index
	GameManager.inventory_items[to_index] = item_hash_from_index
	
	refresh_inventory_slot(from_index)
	refresh_inventory_slot(to_index)


func _inventory_to_equipment(inventory_index: int, slot: EquipmentSlot):
	var equipped_item_hash = GameManager.equipment_items[slot.slot_type]
	var inventory_item_hash = GameManager.inventory_items[inventory_index]
	
	GameManager.equipment_items[slot.slot_type] = inventory_item_hash
	GameManager.inventory_items[inventory_index] = equipped_item_hash
	
	refresh_inventory_slot(inventory_index)
	refresh_equipment_slot(slot.slot_type)
	
	if equipped_item_hash != "":
		InventoryManager.item_unequipped.emit(equipped_item_hash)
	
	InventoryManager.item_equipped.emit(inventory_item_hash)
	InventoryManager.stat_changed.emit()


func _equipment_to_inventory(equipment_type: int, inventory_index: int):
	var equipped_item_hash = GameManager.equipment_items[equipment_type]
	
	var inventory_item_hash = GameManager.inventory_items[inventory_index]
	var inventory_item = ItemFactory.item_from_hash(inventory_item_hash)
	
	# SLOT VIDE
	if inventory_item == null:
		GameManager.inventory_items[inventory_index] = equipped_item_hash
		GameManager.equipment_items[equipment_type] = ""
		
		InventoryManager.item_unequipped.emit(equipped_item_hash)
	
	# SWAP
	else:
		# ITEM INCOMPATIBLE
		if inventory_item.type != equipment_type:
			return
	
		GameManager.inventory_items[inventory_index] = equipped_item_hash
		GameManager.equipment_items[equipment_type] = inventory_item_hash
		
		InventoryManager.item_unequipped.emit(equipped_item_hash)
		InventoryManager.item_equipped.emit(inventory_item_hash)
	
	refresh_inventory_slot(inventory_index)
	refresh_equipment_slot(equipment_type)
	
	InventoryManager.stat_changed.emit()


func _on_skill_inventory_bought() -> void:
	var target_size = GameManager.stats[Enums.STAT.INVENTORY_SLOTS]
	
	while GameManager.inventory_items.size() < target_size:
		GameManager.inventory_items.append("")
	
	_create_inventory_slots()
	await get_tree().process_frame
	refresh_inventory()



func _on_delete_button_pressed(item: Item) -> void:
	GameManager.remove_item(item.hash)
	SaveManager.save_game(SaveManager.get_save_data())
	
	refresh_inventory()
	
	item_shown = null


func _on_item_deleted() -> void:
	refresh_inventory()


func _on_exit_button_pressed() -> void:
	SaveManager.save_game(SaveManager.get_save_data())
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_artefact_menu_button_pressed() -> void:
	SaveManager.save_game(SaveManager.get_save_data())
	main_menu.artefact_menu_clicked.emit()


func _on_item_crafted() -> void:
	refresh_inventory()


func _on_inventory_size_changed() -> void:
	refresh_inventory()


func _on_equip_button_pressed(item: Item) -> void:
	if item == null:
		return
	
	if tooltip.is_equipped:
		_unequip_item()
	else:
		_equip_item(item)


func _equip_item(item: Item) -> void:
	var inventory_index = tooltip.inventory_index
	
	if inventory_index < 0:
		return
	
	var equipment_slot = _get_equipment_slot_for_item(item)
	
	if equipment_slot == null:
		return
	
	_inventory_to_equipment(inventory_index, equipment_slot)
	
	tooltip.close_tooltip()
	item_shown = null


func _unequip_item() -> void:
	var equipment_type = tooltip.equipment_type
	
	if equipment_type < 0:
		return
	
	var inventory_index = _get_free_inventory_slot()
	
	if inventory_index < 0:
		return
	
	_equipment_to_inventory(equipment_type, inventory_index)
	
	tooltip.close_tooltip()
	item_shown = null


func _get_equipment_slot_for_item(item: Item) -> EquipmentSlot:
	for slot in equipment_slots.get_children():
		if slot is EquipmentSlot and slot.slot_type == item.type:
			return slot
	
	return null


func _get_free_inventory_slot() -> int:
	for i in GameManager.inventory_items.size():
		if GameManager.inventory_items[i] == "":
			return i
	
	return -1
