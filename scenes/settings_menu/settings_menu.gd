extends Control

@onready var language_options: OptionButton = $ScrollContainer/VBoxContainer/LanguagePanel/VBoxContainer/Container/Language/LanguageOptions
@onready var tooltip: TooltipSettings = $Tooltip/Control


func _ready() -> void:
	var current_locale := TranslationServer.get_locale()
	
	match current_locale:
		"en" : language_options.select(0)
		"fr" : language_options.select(1)
		"es" : language_options.select(2)
		"de" : language_options.select(3)
		"it" : language_options.select(4)
	
	language_options.item_selected.connect(_on_language_options_item_selected)
	 
	tooltip.visible = false
	
	var popup := language_options.get_popup()
	popup.add_theme_font_size_override("font_size", 35)
	
	# Appliquer les valeurs aux bus audio
	_on_music_volume_changed(GameManager.music_volume)
	_on_sfx_volume_changed(GameManager.sfx_volume)


func set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		return

	if value <= 0.0:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		# 100% = -6 dB
		var db := linear_to_db(value / 100.0) - 6.0
		AudioServer.set_bus_volume_db(bus_index, db)
	
	SaveManager.save_game(SaveManager.get_save_data())


func _on_music_volume_changed(value: float) -> void:
	GameManager.music_volume = value
	set_bus_volume("Music", value)

func _on_sfx_volume_changed(value: float) -> void:
	GameManager.sfx_volume = value
	set_bus_volume("SFX", value)


func _on_language_options_item_selected(index: int) -> void:
	match index:
		0: GameManager.language = "en"
		1: GameManager.language = "fr"
		2: GameManager.language = "es"
		3: GameManager.language = "de"
		4: GameManager.language = "it"
		_: GameManager.language = "en"
	
	LanguageManager.set_language(GameManager.language)
	
	language_options.select(index)
	language_options.text = language_options.get_item_text(index)
	
	SaveManager.save_game(SaveManager.get_save_data())


func _on_delete_button_pressed() -> void:
	SaveManager.delete_save()
	GameManager.reset_game()


func _on_credits_button_pressed() -> void:
	tooltip.show_content()


func _on_music_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.music_volume = 100
		set_bus_volume("Music", 100)
	else:
		GameManager.music_volume = 0
		set_bus_volume("Music", 0)


func _on_sfx_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.sfx_volume = 100
		set_bus_volume("sfx", 100)
	else:
		GameManager.sfx_volume = 0
		set_bus_volume("sfx", 0)
"res://assets/buttons/check_button_off.png"
