class_name ArtefactMenu extends Control

@onready var main_menu: MainMenu = $"../.."

@onready var equipped_slot: ArtefactSlot = $MarginContainer/VBoxContainer/EquippedPanel/EquippedSlot
@onready var inventory_slots: GridContainer = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots
@onready var artefact_0: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact0
@onready var artefact_1: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact1
@onready var artefact_2: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact2
@onready var artefact_3: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact3
@onready var artefact_4: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact4
@onready var artefact_5: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact5
@onready var artefact_6: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact6
@onready var artefact_7: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact7
@onready var artefact_8: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact8
@onready var artefact_9: ArtefactSlot = $MarginContainer/VBoxContainer/InventoryPanel/InventorySlots/Artefact9
@onready var tooltip: TooltipArtefact = $Tooltip/Control

var artefact_shown: Item


func _ready():
	var __ = InputManager.tap.connect(_on_tap_artefact)
	__ = InventoryManager.inventory_artefact_updated.connect(refresh_inventory)
	__ = InventoryManager.equipment_artefact_updated.connect(refresh_equipped_slot)
	__ = tooltip.button_pressed.connect(_on_tooltip_button_pressed)
	
	refresh_inventory()
	refresh_equipped_slot()
	
	tooltip.visible = false


func refresh_inventory():
	for i in GameManager.inventory_artefacts.size():
		var inventory_slot = inventory_slots.get_child(i)
		var item_hash = GameManager.inventory_artefacts[i]
		var item = null
		
		if not item_hash.is_empty():
			item = ItemFactory.item_from_hash(item_hash)
		
		inventory_slot.set_item(item)


func refresh_equipped_slot():
	var item_hash = GameManager.equipped_artefact

	if item_hash == "":
		equipped_slot.set_item(null)
		return

	equipped_slot.set_item(ItemFactory.item_from_hash(item_hash))


func _on_tap_artefact(pos: Vector2):
	if tooltip.visible:
		return
	
	var slot = _get_slot_under_position(pos)
	
	if slot == null:
		return
	
	if not slot.is_unlocked():
		slot.focus_mode = Control.FOCUS_NONE
		slot.toggle_mode = false
		return
	
	artefact_shown = slot.get_item()
	
	if artefact_shown == null:
		return
	
	tooltip.show_item(artefact_shown)


func _get_slot_under_position(pos: Vector2):
	for slot in inventory_slots.get_children():
		var rect_slot = Rect2(slot.global_position, slot.size)
		
		if rect_slot.has_point(pos):
			return slot
	
	var rect_equipped = Rect2(equipped_slot.global_position, equipped_slot.size)
	
	if rect_equipped.has_point(pos):
		
		return equipped_slot

	return null


func _equip_artefact(artefact: Item):
	if GameManager.equipped_artefact != "":
		var unequipped_artefact_hash = GameManager.equipped_artefact
		var unequipped_artefact = ItemFactory.item_from_hash(unequipped_artefact_hash)
		
		GameManager.equipped_artefact = ""
		
		InventoryManager.artefact_unequipped.emit(unequipped_artefact)
	
	GameManager.equipped_artefact = artefact.hash
	
	equipped_slot.set_item(artefact)
	
	refresh_equipped_slot()
	
	InventoryManager.artefact_equipped.emit(artefact_shown)
	GameManager.update_stats.emit()
	SaveManager.save_game(SaveManager.get_save_data())

func _unequip_artefact():
	GameManager.equipped_artefact = ""
	
	equipped_slot.set_item(null)
	
	refresh_equipped_slot()
	
	InventoryManager.artefact_unequipped.emit(artefact_shown)
	GameManager.update_stats.emit()
	SaveManager.save_game(SaveManager.get_save_data())


func _on_tooltip_button_pressed() -> void:
	var tooltip_button = $Tooltip/Control/Panel/VBoxContainer/Footer/Button
	
	if equipped_slot.artefact == null:
		_equip_artefact(artefact_shown)
		refresh_equipped_slot()
		
		tooltip_button.text = tr("TOOLTIP_INVENTORY_BUTTON_UNEQUIP")
	else:
		if artefact_shown.hash != GameManager.equipped_artefact:
			_equip_artefact(artefact_shown)
			tooltip_button.text = tr("TOOLTIP_INVENTORY_BUTTON_UNEQUIP")
		else:
			_unequip_artefact()
			tooltip_button.text = tr("TOOLTIP_INVENTORY_BUTTON_EQUIP")
		
		refresh_equipped_slot()


func _on_exit_button_pressed() -> void:
	SaveManager.save_game(SaveManager.get_save_data())
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_inventory_menu_button_pressed() -> void:
	SaveManager.save_game(SaveManager.get_save_data())
	main_menu.inventory_menu_clicked.emit()
