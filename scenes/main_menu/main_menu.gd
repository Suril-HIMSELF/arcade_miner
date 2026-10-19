class_name MainMenu extends Control

@onready var menu = $Menu

@onready var market_menu: Control = $Menu/MarketMenu
@onready var market_tooltip: CanvasLayer = $Menu/MarketMenu/TooltipMarket
@onready var inventory_menu: Control = $Menu/InventoryMenu
@onready var inventory_tooltip: CanvasLayer = $Menu/InventoryMenu/Tooltip
@onready var artefact_menu: Control = $Menu/ArtefactMenu
@onready var artefact_tooltip: CanvasLayer = $Menu/ArtefactMenu/Tooltip
@onready var game_menu: Control = $Menu/GameMenu
@onready var skills_menu: Control = $Menu/SkillsMenu
@onready var skills_tooltip: CanvasLayer = $Menu/SkillsMenu/Tooltip
@onready var forge_menu: Control = $Menu/ForgeMenu
@onready var statistic_menu: Control = $Menu/StatisticMenu
@onready var quest_menu: Control = $Menu/QuestMenu
@onready var settings_menu: Control = $Menu/SettingsMenu

@onready var ore_container: Control = $OreContainer
@onready var stone_label: Label = $OreContainer/OrePanel/VBoxContainer/Stone/StoneLabel
@onready var gold_label: Label = $OreContainer/OrePanel/VBoxContainer/Gold/GoldLabel
@onready var sapphire_label: Label = $OreContainer/OrePanel/VBoxContainer/SapphireContainer/SapphireLabel
@onready var ruby_label: Label = $OreContainer/OrePanel/VBoxContainer/RubyContainer/RubyLabel
@onready var emerald_label: Label = $OreContainer/OrePanel/VBoxContainer/EmeraldContainer/EmeraldLabel
@onready var diamond_label: Label = $OreContainer/OrePanel/VBoxContainer/DiamondContainer/DiamondLabel
@onready var wood_label: Label = $OreContainer/OrePanel/VBoxContainer/WoodContainer/WoodLabel
@onready var metal_label: Label = $OreContainer/OrePanel/VBoxContainer/MetalContainer/MetalLabel

@onready var level_icon: TextureRect = $HeaderPanel/HBoxContainer/Level/LevelIcon
@onready var level_label: Label = $HeaderPanel/HBoxContainer/Level/LevelLabel
@onready var restock_label: Label = $HeaderPanel/HBoxContainer/Restock/RestockLabel

@onready var music: AudioStreamPlayer2D = $Music

# Tutorial
@onready var tutorial: CanvasLayer = $Tutorial
@onready var statistics_button: Button = $HeaderPanel/HBoxContainer/Statistics
@onready var quest_button: Button = $HeaderPanel/HBoxContainer/QuestMenu

@onready var forge_button: Control = $Footer/VBoxContainer/NavigationPanel/HBoxContainer/ForgeMenu
@onready var skills_button: Button = $Footer/VBoxContainer/NavigationPanel/HBoxContainer/SkillsMenu
@onready var game_button: Button = $Footer/VBoxContainer/NavigationPanel/HBoxContainer/GameMenu
@onready var inventory_button: Button = $Footer/VBoxContainer/NavigationPanel/HBoxContainer/InventoryMenu
@onready var market_button: Button = $Footer/VBoxContainer/NavigationPanel/HBoxContainer/MarketMenu
@onready var restock_icon: VBoxContainer = $HeaderPanel/HBoxContainer/Restock
@onready var ore_panel_toggle: Button = $OreContainer/OrePanelToggle
@onready var settings_button: Button = $HeaderPanel/HBoxContainer/SettingsMenu
@onready var play_button: Button = $Menu/GameMenu/VBoxContainer/GameButton


var panel_open = false


signal artefact_menu_clicked
signal inventory_menu_clicked

func _ready() -> void:
	var __ = GameManager.level_up.connect(_on_level_up)
	__ = GameManager.update_ore.connect(_on_update_header_ore)
	__ = inventory_menu_clicked.connect(_on_inventory_menu_pressed)
	__ = artefact_menu_clicked.connect(_on_artefact_menu_clicked)
	__ = SkillTreeManager.skill_restock_bought.connect(_on_skill_restock_bought)
	
	update_level()
	update_header_ore()
	update_restock()
	
	for node in menu.get_children():
		node.visible = false
	
	game_menu.visible = true
	$Footer/VBoxContainer/NavigationPanel/HBoxContainer/GameMenu.button_pressed = true
	ore_container.position.x = -ore_container.size.x
	
	stone_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.STONE])
	sapphire_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.SAPPHIRE])
	ruby_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.RUBY])
	emerald_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.EMERALD])
	diamond_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.DIAMOND])
	wood_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.WOOD])
	metal_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.METAL])
	
	LanguageManager.language_changed.connect(_on_language_changed)
	_on_language_changed()
	
	music.play()
	
	await get_tree().process_frame
	
	if not GameManager.tuto_completed_main:
		tutorial.start_tutorial([
			{"target": null, "text": "TUTO_MAIN_MENU_WELCOME"},
			{"target": statistics_button, "text": "TUTO_MAIN_MENU_BUTTON_STATISTICS"},
			{"target": quest_button, "text": "TUTO_MAIN_MENU_BUTTON_QUESTS"},
			{"target": market_button, "text": "TUTO_MAIN_MENU_BUTTON_MARKET"},
			{"target": restock_icon, "text": "TUTO_MAIN_MENU_IMAGE_RESTOCK"},
			{"target": inventory_button, "text": "TUTO_MAIN_MENU_BUTTON_INVENTORY"},
			{"target": game_button, "text": "TUTO_MAIN_MENU_BUTTON_GAME"},
			{"target": skills_button, "text": "TUTO_MAIN_MENU_BUTTON_SKILL"},
			{"target": forge_button, "text": "TUTO_MAIN_MENU_BUTTON_FORGE"},
			{"target": ore_panel_toggle, "text": "TUTO_MAIN_MENU_PANEL_ORE"},
			{"target": play_button, "text": "TUTO_MAIN_MENU_BUTTON_PLAY"}
		])
		
		GameManager.tuto_completed_main = true
		
		SaveManager.save_game(SaveManager.get_save_data())
	else:
		tutorial.visible = false
	
	# Test Admob
	AdManager.show_banner()


func update_level() -> void:
	level_icon.texture = Utils.get_level_icon(GameManager.level)
	level_label.text = str(GameManager.level)


func update_header_ore() -> void:
	stone_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.STONE])
	gold_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.GOLD])
	sapphire_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.SAPPHIRE])
	ruby_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.RUBY])
	emerald_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.EMERALD])
	diamond_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.DIAMOND])
	wood_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.WOOD])
	metal_label.text = Utils.format_number(GameManager.ore_inventory[Enums.ORE.METAL])


func update_restock() -> void:
	restock_label.text = str(GameManager.run_completed % int(GameManager.stats[Enums.STAT.MARKET_RESTOCK])) + " / " + str(int(GameManager.stats[Enums.STAT.MARKET_RESTOCK]))


func _on_skills_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/skill_tree_menu/skill_tree_menu.tscn")


func _on_level_up() -> void:
	update_level()


func _on_update_header_ore() -> void:
	update_header_ore()


func _on_language_changed():
	LanguageManager.localize_tree(self)


func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	LanguageManager.set_language("en")


func _on_french_pressed() -> void:
	TranslationServer.set_locale("fr")
	LanguageManager.set_language("fr")


func _on_delete_pressed() -> void:
	SaveManager.delete_save()
	GameManager.reset_game()


func _on_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_menu/game_menu.tscn")


func _on_forge_button_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = true
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	forge_menu.visible = true


func _on_market_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = true
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	market_menu.visible = true


func _on_skills_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = true
	
	skills_menu.visible = true


func _on_inventory_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = true
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	inventory_menu.visible = true


func _on_artefact_menu_clicked() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = true
	skills_tooltip.visible = false
	
	artefact_menu.visible = true


func _on_game_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	game_menu.visible = true


func _on_forge_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	forge_menu.visible = true


func _on_quest_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	quest_menu.visible = true


func _on_settings_menu_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	settings_menu.visible = true


func _on_statistics_pressed() -> void:
	for node in menu.get_children():
		node.visible = false
	
	market_tooltip.visible = false
	inventory_tooltip.visible = false
	artefact_tooltip.visible = false
	skills_tooltip.visible = false
	
	settings_menu.visible = false
	statistic_menu.visible = true


func _on_ore_panel_toggle_pressed() -> void:
	panel_open = not panel_open

	var target_x := 0.0 if panel_open else -ore_container.size.x

	var tween := create_tween()
	tween.tween_property(
		ore_container,
		"position:x",
		target_x,
		0.25
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_skill_restock_bought() -> void:
	update_restock()
