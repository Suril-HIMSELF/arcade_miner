class_name TooltipMarket extends Control

@onready var black_veil: ColorRect = $BlackVeil
@onready var panel: PanelContainer = $Panel

@onready var ore_icon: TextureRect = $Panel/VBoxContainer/Header/Button/Icon
@onready var ore_name: Label = $Panel/VBoxContainer/Header/TitleContainer/Title

@onready var market_quantity_label: RichTextLabel = $Panel/VBoxContainer/Header/TitleContainer/Quantity
@onready var buy_button: Button = $Panel/VBoxContainer/Footer/BuyButton
@onready var buy_price_final_label: Label = $Panel/VBoxContainer/Footer/BuyButton/VBoxContainer/HBoxContainer/BuyPriceFinal

@onready var sell_button: Button = $Panel/VBoxContainer/Footer/SellButton
@onready var sell_price_final_label: Label = $Panel/VBoxContainer/Footer/SellButton/VBoxContainer/HBoxContainer/SellPriceFinal

@onready var line_edit: LineEdit = $Panel/VBoxContainer/ContentContainer/LineEdit


var ore: int
var slot: MarketSlot
var input_quantity: int = 0
var buy_price_final: int = 0
var sell_price_final: int = 0

var is_visible: bool = false

signal tooltip_closed(slot)


func _ready():
	var __ = InputManager.tap.connect(_on_tap_input)
	__ = buy_button.pressed.connect(_on_buy_button_pressed)
	__ = sell_button.pressed.connect(_on_sell_button_pressed)


func is_black_veil(pos: Vector2) -> bool:
	var panel_rect = panel.get_global_rect()
	
	if panel_rect.has_point(pos):
		return false
	
	return true


func show_market_data(_slot: MarketSlot) -> void:
	visible = true
	slot = _slot
	ore = slot.ore
	
	update_buy_container()
	update_sell_container()
	update_ore_container()
	
	line_edit.text = "1"
	update_button_price("1")


func update_buy_container() -> void:
	var market_quantity = GameManager.market_state[ore].quantity
	var buy_price = GameManager.market_state[ore].buy_price
	
	market_quantity_label.text = tr("UI_MARKETSLOT_LABEL_STOCK") + " : [color='#91c65eff']"  + str(int(market_quantity)) + "[/color]"


func update_sell_container() -> void:
	var player_quantity = GameManager.ore_inventory[ore]
	var sell_price = GameManager.market_state[ore].sell_price


func update_ore_container() -> void:
	ore_icon.texture = Utils.get_ore_icon(ore)
	ore_name.text = tr(Constants.ORE_NAME[ore]).to_upper()


func close_tooltip() -> void:
	is_visible = false
	visible = false
	
	tooltip_closed.emit(slot)


func update_button_price(new_text: String) -> void:
	var filtered = ""
	
	for c in new_text:
		if c.is_valid_int():
			filtered += c
	
	if filtered == "":
		filtered = "0"
	
	var value = max(int(filtered), 0)
	
	line_edit.text = str(value)
	line_edit.caret_column = line_edit.text.length()
	
	buy_price_final = GameManager.market_state[ore].buy_price * value
	buy_price_final_label.text = str(buy_price_final)
	
	sell_price_final = GameManager.market_state[ore].sell_price * value
	sell_price_final_label.text = str(sell_price_final)
	
	input_quantity = value


func purchase_ore(_price: int, _quantity: int) -> void:
	GameManager.ore_inventory[Enums.ORE.GOLD] -= _price
	GameManager.market_state[ore].quantity -= _quantity
	GameManager.ore_inventory[ore] += _quantity
	
	update_buy_container()
	update_sell_container()


func resale_ore(_price: int, _quantity: int) -> void:
	GameManager.ore_inventory[ore] -= _quantity
	GameManager.market_state[ore].quantity += _quantity
	GameManager.ore_inventory[Enums.ORE.GOLD] += _price
	
	update_sell_container()
	update_buy_container()


func _on_buy_button_pressed() -> void:
	if input_quantity <= 0 or buy_price_final > GameManager.ore_inventory[Enums.ORE.GOLD] or input_quantity > GameManager.market_state[ore].quantity:
		return
	
	purchase_ore(buy_price_final, input_quantity)
	
	GameManager.update_ore.emit()


func _on_sell_button_pressed() -> void:
	if input_quantity <= 0 or input_quantity > GameManager.ore_inventory[ore]:
		return
	
	resale_ore(sell_price_final, input_quantity)
	
	GameManager.update_ore.emit()


func _on_tap_input(pos):
	if is_black_veil(pos) and visible:
		close_tooltip()


func _on_line_edit_text_changed(new_text: String) -> void:
	update_button_price(new_text)
