class_name MarketSlot extends Button

@onready var title: Label = $Panel/HBoxContainer/TitleContainer/Title
@onready var ore_icon: TextureRect = $Panel/HBoxContainer/Button/Icon
@onready var quantity: RichTextLabel = $Panel/HBoxContainer/TitleContainer/Quantity
@onready var price_buy: Label = $Panel/HBoxContainer/PriceLabel/HBoxContainer/BuyValueLabel
@onready var price_sell: Label = $Panel/HBoxContainer/PriceValues/HBoxContainer/SellValueLabel

@export var ore: Enums.ORE


func _ready() -> void:
	ore_icon.texture = Utils.get_ore_icon(ore)


func setup(_quantity: int, _buy: int, _sell: int):
	title.text = tr(Utils.get_ore_name(ore)).to_upper()
	quantity.text = tr("UI_MARKETSLOT_LABEL_STOCK") + " : [color='#91c65eff']"  + str(_quantity) + "[/color]"
	price_buy.text = str(_buy)
	price_sell.text = str(_sell)
