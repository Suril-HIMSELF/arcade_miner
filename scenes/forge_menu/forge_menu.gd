class_name ForgeMenu extends Control

@onready var wood_cost_node: HBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/WoodCost
@onready var metal_cost_node: HBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/MetalCost
@onready var gold_cost_node: HBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/GoldCost

@onready var item_panel: Panel = $ScrollContainer/MarginContainer/VBoxContainer/ItemPanel
@onready var ore_panel: Panel = $ScrollContainer/MarginContainer/VBoxContainer/OrePanel
@onready var cost_panel: Panel = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel
@onready var slot_count: Label = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/SlotCount

@onready var wood_cost_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/WoodCost/OreCost
@onready var metal_cost_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/MetalCost/OreCost
@onready var gold_cost_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/GoldCost/OreCost
@onready var ore_icon: TextureRect = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/OreCost/OreIcon
@onready var ore_cost_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/CostPanel/VBoxContainer/CostContainer/OreCost/OreCost

@onready var equipment_button: Button = $ScrollContainer/MarginContainer/VBoxContainer/Control/VBoxContainer/ContentContainer/Equipment
@onready var equipment_icon: TextureRect = $ScrollContainer/MarginContainer/VBoxContainer/Control/VBoxContainer/ContentContainer/Equipment/Icon


@onready var item_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/Control/VBoxContainer/ItemLabel
@onready var ore_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/Control/VBoxContainer/OreLabel
@onready var affinity_stat_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/Control/VBoxContainer/ContentContainer/OreAffinityContainer/AffinityStatLabel
@onready var affinity_value_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/Control/VBoxContainer/ContentContainer/OreAffinityContainer/AffinityValueLabel

@onready var tooltip: Control = $TooltipForge/Control


var crafted_item = null
var item_type = -1
var ore: int = -1
var wood_cost = null
var metal_cost = null
var gold_cost = null
var ore_cost = null


func _ready() -> void:
	tooltip.visible = false
	
	var __ = tooltip.delete_item.connect(_on_delete_button_pressed)
	__ = InventoryManager.inventory_item_changed.connect(_on_inventory_item_changed)
	
	equipment_button.disabled = true
	equipment_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	wood_cost_node.visible = false
	metal_cost_node.visible = false
	gold_cost_node.visible = false
	
	update_inventory_slot()


func update_inventory_slot() -> void:
	var max_slot_count = int(GameManager.stats[Enums.STAT.INVENTORY_SLOTS])
	var current_slot_count = int(max_slot_count - GameManager.get_remaining_inventory_slot())
	
	slot_count.text = str(current_slot_count) + " / " + str(max_slot_count)

func update_wood_cost() -> void:
	wood_cost_label.text = str(wood_cost.quantity)


func update_metal_cost() -> void:
	metal_cost_label.text = str(metal_cost.quantity)


func update_gold_cost() -> void:
	gold_cost_label.text = str(gold_cost.quantity)


func update_ore_cost() -> void:
	ore_icon.texture = Utils.get_ore_icon(ore)
	ore_cost_label.text = str(ore_cost.quantity)


func update_price_from_item_type() -> void:
	compute_wood_cost()
	update_wood_cost()
	
	compute_metal_cost()
	update_metal_cost()
	
	compute_gold_cost()
	update_gold_cost()


func update_price_from_ore() -> void:
	compute_ore_cost()
	update_ore_cost()


func update_equipment_sprite(item_type: Enums.ITEM_TYPE) -> void:
	var item_icon = Utils.get_forge_item_icon(item_type)
	
	equipment_icon.texture = item_icon


func update_ore_affinity_container() -> void:
	ore_label.text = Constants.ORE_NAME[ore]
	ore_label.add_theme_color_override("font_color", Utils.get_ore_color(ore))
	
	match ore:
		Enums.ORE.SAPPHIRE:
			affinity_stat_label.text = "UI_FORGE_MENU_AFFINITY_SAPPHIRE"
			affinity_value_label.text = "1 - 10\n1 - 10\n1 - 10\n1 - 10\n1 - 10\n1 - 10"
		Enums.ORE.RUBY:
			affinity_stat_label.text = "UI_FORGE_MENU_AFFINITY_RUBY"
			affinity_value_label.text = "1 - 25%\n1 - 25%\n1 - 25%\n10 - 100\n1 - 5%\n1 - 5%"
		Enums.ORE.EMERALD:
			affinity_stat_label.text = "UI_FORGE_MENU_AFFINITY_EMERALD"
			affinity_value_label.text = "1 - 5%\n1 - 5%\n1 - 5%\n1 - 5%\n1 - 5%"
		Enums.ORE.DIAMOND:
			affinity_stat_label.text = "UI_FORGE_MENU_AFFINITY_DIAMOND"
			affinity_value_label.text = "1 - 3\n1 - 3\n10 - 50%\n1 - 5s\n10 - 50%"
	
	


func compute_wood_cost() -> void:
	if item_type == -1:
		return
	
	wood_cost = OreQuantity.new()
	wood_cost.ore = Enums.ORE.WOOD
	wood_cost_node.visible = true
	
	match item_type:
		Enums.ITEM_TYPE.PICKAXE:
			wood_cost.quantity = 200
		Enums.ITEM_TYPE.HELMET:
			wood_cost.quantity = 100
		Enums.ITEM_TYPE.LANTERN:
			wood_cost.quantity = 50
		Enums.ITEM_TYPE.JEWEL:
			wood_cost.quantity = 10


func compute_metal_cost() -> void:
	if item_type == -1:
		return
	
	metal_cost = OreQuantity.new()
	metal_cost.ore = Enums.ORE.METAL
	metal_cost_node.visible = true
	
	match item_type:
		Enums.ITEM_TYPE.PICKAXE:
			metal_cost.quantity = 100
		Enums.ITEM_TYPE.HELMET:
			metal_cost.quantity = 150
		Enums.ITEM_TYPE.LANTERN:
			metal_cost.quantity = 150
		Enums.ITEM_TYPE.JEWEL:
			metal_cost.quantity = 200


func compute_gold_cost() -> void:
	if item_type == -1:
		return
	
	gold_cost = OreQuantity.new()
	gold_cost.ore = Enums.ORE.GOLD
	gold_cost_node.visible = true
	
	match item_type:
		Enums.ITEM_TYPE.PICKAXE, Enums.ITEM_TYPE.HELMET:
			gold_cost.quantity = 100
		Enums.ITEM_TYPE.LANTERN:
			gold_cost.quantity = 200
		Enums.ITEM_TYPE.JEWEL:
			gold_cost.quantity = 300


func compute_ore_cost() -> void:
	if ore == -1:
		return
	
	ore_cost = OreQuantity.new()
	ore_cost.ore = ore
	
	match ore:
		Enums.ORE.SAPPHIRE:
			ore_cost.quantity = 400
		Enums.ORE.RUBY:
			ore_cost.quantity = 300
		Enums.ORE.EMERALD:
			ore_cost.quantity = 200
		Enums.ORE.DIAMOND:
			ore_cost.quantity = 100


func can_forge() -> bool:
	var inventory_slot = GameManager.get_remaining_inventory_slot()
	
	if inventory_slot == 0:
		feedback_inventory_fail()
		return false
	
	if item_type == -1:
		feedback_item_fail()
		return false
	
	if ore == -1:
		feedback_ore_fail()
		return false
	
	if GameManager.ore_inventory[Enums.ORE.WOOD] < wood_cost.quantity or GameManager.ore_inventory[Enums.ORE.METAL] < metal_cost.quantity or GameManager.ore_inventory[Enums.ORE.GOLD] < gold_cost.quantity or GameManager.ore_inventory[ore_cost.ore] < ore_cost.quantity:
		feedback_cost_fail()
		return false
	
	return true


func feedback_inventory_fail() -> void:
	var slot_count_position = slot_count.position
	# Empêche plusieurs animations de s'empiler
	var tween = create_tween()
	tween.set_parallel(false)

	# Rouge + petit déplacement
	tween.tween_property(slot_count, "modulate", Color(1.0, 0.35, 0.35), 0.05)
	tween.parallel().tween_property(slot_count, "position", slot_count_position + Vector2(8, 0), 0.05)

	# Vibration
	tween.tween_property(slot_count, "position", slot_count_position + Vector2(-8, 0), 0.06)
	tween.tween_property(slot_count, "position", slot_count_position + Vector2(6, 0), 0.06)
	tween.tween_property(slot_count, "position", slot_count_position + Vector2(-5, 0), 0.05)
	tween.tween_property(slot_count, "position", slot_count_position + Vector2(3, 0), 0.05)

	# Retour à l'état normal
	tween.tween_property(slot_count, "position", slot_count_position, 0.05)
	tween.tween_property(slot_count, "modulate", Color.WHITE, 0.12)


func feedback_item_fail() -> void:
	var item_panel_position = item_panel.position
	# Empêche plusieurs animations de s'empiler
	var tween = create_tween()
	tween.set_parallel(false)

	# Rouge + petit déplacement
	tween.tween_property(item_panel, "modulate", Color(1.0, 0.35, 0.35), 0.05)
	tween.parallel().tween_property(item_panel, "position", item_panel_position + Vector2(8, 0), 0.05)

	# Vibration
	tween.tween_property(item_panel, "position", item_panel_position + Vector2(-8, 0), 0.06)
	tween.tween_property(item_panel, "position", item_panel_position + Vector2(6, 0), 0.06)
	tween.tween_property(item_panel, "position", item_panel_position + Vector2(-5, 0), 0.05)
	tween.tween_property(item_panel, "position", item_panel_position + Vector2(3, 0), 0.05)

	# Retour à l'état normal
	tween.tween_property(item_panel, "position", item_panel_position, 0.05)
	tween.tween_property(item_panel, "modulate", Color.WHITE, 0.12)


func feedback_ore_fail() -> void:
	var ore_panel_position = ore_panel.position
	# Empêche plusieurs animations de s'empiler
	var tween = create_tween()
	tween.set_parallel(false)

	# Rouge + petit déplacement
	tween.tween_property(ore_panel, "modulate", Color(1.0, 0.35, 0.35), 0.05)
	tween.parallel().tween_property(ore_panel, "position", ore_panel_position + Vector2(8, 0), 0.05)

	# Vibration
	tween.tween_property(ore_panel, "position", ore_panel_position + Vector2(-8, 0), 0.06)
	tween.tween_property(ore_panel, "position", ore_panel_position + Vector2(6, 0), 0.06)
	tween.tween_property(ore_panel, "position", ore_panel_position + Vector2(-5, 0), 0.05)
	tween.tween_property(ore_panel, "position", ore_panel_position + Vector2(3, 0), 0.05)

	# Retour à l'état normal
	tween.tween_property(ore_panel, "position", ore_panel_position, 0.05)
	tween.tween_property(ore_panel, "modulate", Color.WHITE, 0.12)


func feedback_cost_fail() -> void:
	var cost_panel_position = cost_panel.position
	# Empêche plusieurs animations de s'empiler
	var tween = create_tween()
	tween.set_parallel(false)

	# Rouge + petit déplacement
	tween.tween_property(cost_panel, "modulate", Color(1.0, 0.35, 0.35), 0.05)
	tween.parallel().tween_property(cost_panel, "position", cost_panel_position + Vector2(8, 0), 0.05)

	# Vibration
	tween.tween_property(cost_panel, "position", cost_panel_position + Vector2(-8, 0), 0.06)
	tween.tween_property(cost_panel, "position", cost_panel_position + Vector2(6, 0), 0.06)
	tween.tween_property(cost_panel, "position", cost_panel_position + Vector2(-5, 0), 0.05)
	tween.tween_property(cost_panel, "position", cost_panel_position + Vector2(3, 0), 0.05)

	# Retour à l'état normal
	tween.tween_property(cost_panel, "position", cost_panel_position, 0.05)
	tween.tween_property(cost_panel, "modulate", Color.WHITE, 0.12)


func update_forge_item() -> void:
	update_equipment_sprite(item_type)
	update_price_from_item_type()


func update_forge_ore() -> void:
	update_ore_affinity_container()
	update_price_from_ore()


func _on_pickaxe_button_pressed() -> void:
	item_type = Enums.ITEM_TYPE.PICKAXE
	item_label.text = tr(Constants.ITEM_NAME[Enums.ITEM_TYPE.PICKAXE]).to_upper()
	update_forge_item()


func _on_helmet_button_pressed() -> void:
	item_type = Enums.ITEM_TYPE.HELMET
	item_label.text = tr(Constants.ITEM_NAME[Enums.ITEM_TYPE.HELMET]).to_upper()
	update_forge_item()


func _on_lantern_button_pressed() -> void:
	item_type = Enums.ITEM_TYPE.LANTERN
	item_label.text = tr(Constants.ITEM_NAME[Enums.ITEM_TYPE.LANTERN]).to_upper()
	update_forge_item()


func _on_jewel_button_pressed() -> void:
	item_type = Enums.ITEM_TYPE.JEWEL
	item_label.text = tr(Constants.ITEM_NAME[Enums.ITEM_TYPE.JEWEL]).to_upper()
	update_forge_item()


func _on_sapphire_button_pressed() -> void:
	ore = Enums.ORE.SAPPHIRE
	
	update_forge_ore()


func _on_ruby_button_pressed() -> void:
	ore = Enums.ORE.RUBY
	
	update_forge_ore()


func _on_emerald_button_pressed() -> void:
	ore = Enums.ORE.EMERALD
	
	update_forge_ore()


func _on_diamond_button_pressed() -> void:
	ore = Enums.ORE.DIAMOND
	
	update_forge_ore()


func _on_forge_button_pressed() -> void:
	if not can_forge():
		return
	
	GameManager.remove_ore(Enums.ORE.WOOD, wood_cost.quantity)
	GameManager.remove_ore(Enums.ORE.METAL, metal_cost.quantity)
	GameManager.remove_ore(Enums.ORE.GOLD, gold_cost.quantity)
	GameManager.remove_ore(ore_cost.ore, ore_cost.quantity)
	
	var item = Item.new()
	
	item.rarity = ItemFactory.roll_item_rarity()
	item.type = item_type
	item.description = ItemFactory.roll_item_description(item_type, item.rarity)
	item.icon = item.description.icon
	
	for i in range(item.rarity +1):
		var stat = StatValue.new()
		stat = ItemFactory.roll_ore_affinity_stat(ore_cost.ore)
		
		item.stats.append(stat)
		
	var item_hash = ItemFactory.build_hash(item)
	item.hash = item_hash
	
	crafted_item = item
	
	update_item_result()
	
	GameManager.add_item(item_hash)
	SaveManager.save_game(SaveManager.get_save_data())
	
	update_inventory_slot()
	
	match item_type:
		Enums.ITEM_TYPE.PICKAXE: GameManager.task_states[Enums.TASK.FORGE_PICKAXE].current_amount += 1
		Enums.ITEM_TYPE.HELMET: GameManager.task_states[Enums.TASK.FORGE_HELMET].current_amount += 1
		Enums.ITEM_TYPE.LANTERN: GameManager.task_states[Enums.TASK.FORGE_LANTERN].current_amount += 1
		Enums.ITEM_TYPE.JEWEL: GameManager.task_states[Enums.TASK.FORGE_JEWEL].current_amount += 1
	
	GameManager.task_states[Enums.TASK.FORGE_ITEM].current_amount += 1
	
	ItemFactory.item_crafted.emit()


func _on_inventory_item_changed() -> void:
	update_inventory_slot()


func update_item_result() -> void:
	equipment_button.disabled = false
	equipment_button.mouse_filter = Control.MOUSE_FILTER_STOP
	
	equipment_icon.texture = crafted_item.icon


func _on_equipment_button_pressed() -> void:
	if crafted_item == null:
		return
	
	tooltip.show_item(crafted_item)


func _on_delete_button_pressed(item: Item) -> void:
	GameManager.remove_item(item.hash)
	SaveManager.save_game(SaveManager.get_save_data())
	
	crafted_item = null
	equipment_icon.texture = null
	
	InventoryManager.item_deleted.emit()


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
