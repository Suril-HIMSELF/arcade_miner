class_name StatDisplay extends HBoxContainer

@onready var primary_icon: TextureRect = $Control/PrimaryIcon
@onready var secondary_icon: TextureRect = $Control/SecondaryIcon
@onready var stat_label: Label = $StatLabel

@export var stat: Enums.STAT = Enums.STAT.STONE_QUANTITY


func _ready() -> void:
	primary_icon.texture = Database.stats[stat].primary_icon
	secondary_icon.texture = Database.stats[stat].secondary_icon
	tooltip_text = tr(Database.stat_definitions[stat].name) + "\n\n" + tr(Database.stat_definitions[stat].description)
	primary_icon.tooltip_text = tr(Database.stat_definitions[stat].name) + "\n\n" + tr(Database.stat_definitions[stat].description)
	
	refresh_value()


func refresh_value() -> void:
	var stat_value = GameManager.stats[stat]
	var stat_mode = Database.stat_definitions[stat].mode
	
	stat_label.text = Utils.display_stat_value(stat_value, stat_mode)
