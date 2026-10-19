class_name MarketSlot extends Button

@onready var title: Label = $Panel/HBoxContainer/TitleContainer/Title
@onready var ore_icon: TextureRect = $Panel/HBoxContainer/Button/Icon
@onready var quantity: RichTextLabel = $Panel/HBoxContainer/TitleContainer/Quantity
@onready var price_buy: Label = $Panel/HBoxContainer/PriceLabel/HBoxContainer/BuyValueLabel
@onready var price_sell: Label = $Panel/HBoxContainer/PriceValues/HBoxContainer/SellValueLabel

@export var ore: Enums.ORE

var current_quantity: int
var current_buy: int
var current_sell: int


func _ready() -> void:
	ore_icon.texture = Utils.get_ore_icon(ore)
	
	quantity.set_meta("skip_auto_localize", true)

func setup(_quantity: int, _buy: int, _sell: int) -> void:
	current_quantity = _quantity
	current_buy = _buy
	current_sell = _sell

	title.set_meta("loc_key", Utils.get_ore_name(ore))
	refresh_translations()


func refresh_translations() -> void:
	title.text = tr(Utils.get_ore_name(ore)).to_upper()
	quantity.text = tr("UI_MARKETSLOT_LABEL_STOCK") + " : [color='#91c65eff']" + str(current_quantity) + "[/color]"
	price_buy.text = str(current_buy)
	price_sell.text = str(current_sell)
