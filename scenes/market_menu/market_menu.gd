class_name MarketMenu extends Control

@onready var ore_slots: Array[MarketSlot] = [
	$MarginContainer/OreContainer/SapphireSlot,
	$MarginContainer/OreContainer/RubySlot,
	$MarginContainer/OreContainer/EmeraldSlot,
	$MarginContainer/OreContainer/DiamondSlot,
	$MarginContainer/OreContainer/WoodSlot, 
	$MarginContainer/OreContainer/MetalSlot,
]

@onready var ore_container: VBoxContainer = $MarginContainer/OreContainer
@onready var tooltip_market: Control = $TooltipMarket/Control

var market_restock: int = GameManager.stats[Enums.STAT.MARKET_RESTOCK]
var next_restock: int = abs(GameManager.run_completed - market_restock)
var market_modifier: float


func _ready() -> void:
	var __ = tooltip_market.tooltip_closed.connect(_on_tooltip_closed)
	
	tooltip_market.visible = false
	
	refresh_restock()
	
	for slot in ore_slots:
		if slot == null:
			continue
		
		__ = slot.pressed.connect(_on_ore_slot_pressed.bind(slot))
		
		refresh_ore_slot(slot)


func refresh_ore_slot(slot: MarketSlot) -> void:
	var ore = slot.ore
	
	slot.setup(GameManager.market_state[ore].quantity, GameManager.market_state[ore].buy_price, GameManager.market_state[ore].sell_price)


func refresh_restock() -> void:
	if next_restock == 0:
		next_restock = market_restock


func _on_ore_slot_pressed(slot: MarketSlot) -> void:
	tooltip_market.show_market_data(slot)


func _on_tooltip_closed(slot: MarketSlot) -> void:
	refresh_ore_slot(slot)
	SaveManager.save_game(SaveManager.get_save_data())
