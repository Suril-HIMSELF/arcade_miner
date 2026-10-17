class_name GameMenu extends Control


@onready var sprite: Node2D = $CenterUI/StoneSprite
@onready var static_ui: Control = $StaticUI

# Header section
@onready var ore_counter: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/OreCounter

@onready var ore_icons: Array[TextureRect] = [
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Stone/Icon,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Gold/Icon,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Sapphire/Icon,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Ruby/Icon,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Emerald/Icon,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Diamond/Icon,
]

@onready var ore_run_labels: Array[Label] = [
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Stone/Label,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Gold/Label,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Sapphire/Label,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Ruby/Label,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Emerald/Label,
	$StaticUI/MarginContainer/VBoxContainer/Header/OreCounter/HboxContainer/Diamond/Label,
]

# Multiplier section
@onready var xp_panel: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/Multiplier/XPPanel
@onready var multiplier_panel: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/Multiplier/XPPanel/MultiplierPanel
@onready var xp_bar: ProgressBar = $StaticUI/MarginContainer/VBoxContainer/Header/Multiplier/XPPanel/XPBar
@onready var multiplier_label: Label = $StaticUI/MarginContainer/VBoxContainer/Header/Multiplier/XPPanel/MultiplierPanel/MultiplierLabel

# Sequence section
@onready var input_section: HBoxContainer = $CenterUI/SequencePanel/InputSection
@onready var heat_bar: ProgressBar = $CenterUI/SequencePanel/Panel/HeatBar

# Life
@onready var life_bar: ProgressBar = $CenterUI/OreLife/LifeBar

# End page
@onready var end_screen_ui: Control = $EndScreenUI
@onready var run_stats: RichTextLabel = $EndScreenUI/RunStats/VBoxContainer/RunStats

@onready var ore_end_labels: Array[RichTextLabel] = [
	$EndScreenUI/RunStats/VBoxContainer/Stone/StoneStat,
	$EndScreenUI/RunStats/VBoxContainer/Gold/GoldStat,
	$EndScreenUI/RunStats/VBoxContainer/Sapphire/SapphireStat,
	$EndScreenUI/RunStats/VBoxContainer/Ruby/RubyStat,
	$EndScreenUI/RunStats/VBoxContainer/Emerald/EmeraldStat,
	$EndScreenUI/RunStats/VBoxContainer/Diamond/DiamondStat,
]

# End artefacts
@onready var end_artefacts_ui: Control = $EndArtefactsUI
@onready var artefact_container: HBoxContainer = $EndArtefactsUI/Panel/VBoxContainer/Artefacts

# End reward
@onready var end_reward_ui: Control = $EndRewardUI
@onready var ore_level: RichTextLabel = $EndRewardUI/Panel/VBoxContainer/Header/TitleContainer/OreLevel
@onready var reward_icon: TextureRect = $EndRewardUI/Panel/VBoxContainer/RewardContent/RewardIcon
@onready var reward_quantity_label: Label = $EndRewardUI/Panel/VBoxContainer/RewardContent/RewardQuantityLabel
@onready var double_reward: Button = $EndScreenUI/RunStats/VBoxContainer/HBoxContainer/DoubleReward


# Sounds
@onready var music: AudioStreamPlayer2D = $Music
@onready var sfx_pickaxe: AudioStreamPlayer2D = $SFXPickaxe
@onready var sfx_pickaxe_critical: AudioStreamPlayer2D = $SFXPickaxeCritical
@onready var sfx_pickaxe_fail: AudioStreamPlayer2D = $SFXPickaxeFail
@onready var sfx_echo: AudioStreamPlayer2D = $SFXEcho
@onready var sfx_gold_rush: AudioStreamPlayer2D = $SFXGoldRush
@onready var sfx_relic: AudioStreamPlayer2D = $SFXRelic
@onready var sfx_bomb: AudioStreamPlayer2D = $SFXBomb

@onready var timer: Timer = $StaticUI/Timer
@onready var timer_label: Label = $StaticUI/MarginContainer/VBoxContainer/Header/Timer/TimerPanel/HBoxContainer/TimerLabel

@onready var active_effect_status: HBoxContainer = $CenterUI/Effects/ActiveEffectsStatus


# Tutorial
@onready var tutorial: CanvasLayer = $Tutorial
@onready var ore_life_panel: Panel = $CenterUI/OreLife
@onready var heat_panel: Panel = $CenterUI/SequencePanel/Panel
@onready var input_panel: HBoxContainer = $CenterUI/SequencePanel/InputSection
@onready var timer_panel: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/Timer/TimerPanel
@onready var xp_bar_panel: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/Multiplier/XPPanel
@onready var mult_panel: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/Multiplier/XPPanel/MultiplierPanel
@onready var ore_panel: Panel = $StaticUI/MarginContainer/VBoxContainer/Header/OreCounter


var symbol_scene: PackedScene = preload("res://scenes/game_menu/symbol/symbol.tscn")
var sequence: Array[OreShape]
var sequence_length: int = 5
var input: int = -1

# Runtime variables
var multiplier: int = 0
var multiplier_xp: int = 0
var multiplier_next_level: int = 5
var heat_energy: float = 0
var ore_hp: float = 0
var ore_max_hp: float = 0
var ore_dead: bool = false
var timer_duration: float = GameManager.stats[Enums.STAT.TIMER_DURATION]
var is_critical: bool = false
var is_started: bool = false
var reward_was_doubled: bool = false

var pickaxe_effect_scene: PackedScene = preload("res://scenes/effects/pickaxe_effect/pickaxe_effect.tscn")
var bomb_effect_scene: PackedScene = preload("res://scenes/effects/bomb/bomb_effect.tscn")
var ore_pop_effect_scene: PackedScene = preload("res://scenes/effects/ore_pop/ore_pop.tscn")
var relic_effect_scene: PackedScene = preload("res://scenes/effects/relic/relic_effect.tscn")
var quantity_popup_effect_scene: PackedScene = preload("res://scenes/effects/quantity_popup/quantity_popup_effect.tscn")

var heat_xp: float = 0
var heat_crit: float = 0
var heat_quantity: float = 0

var action_success: int = 0
var action_failed: int = 0
var run_finished = false

var input_count = [0, 0, 0, 0, 0]

var tween_sprite
var tween_resource

var inventory: Array
var effect_manager: EffectManager
var current_heat_tier = 0

var unlocked_artefacts: Array

const BASE_HEIGHT = 1920


func _ready() -> void:
	await get_tree().process_frame
	
	sprite.visible = true
	end_screen_ui.visible = false
	end_artefacts_ui.visible = false
	end_reward_ui.visible = false
	ore_dead = false
	
	
	var __ = InputManager.tap.connect(_on_tap_input)
	__ = InputManager.swipe.connect(_on_swipe_input)
	__ = InputManager.hold.connect(_on_hold_input)
	__ = AdManager.rewarded_availability_changed.connect(_on_rewarded_availability_changed)
	
	reward_was_doubled = false

	double_reward.visible = (
		not reward_was_doubled
		and AdManager.is_rewarded_available()
	)
	
	effect_manager = EffectManager.new()
	add_child(effect_manager)

	effect_manager.effect_added.connect(_on_effect_added)
	effect_manager.effect_removed.connect(_on_effect_removed)
	effect_manager.effect_triggered.connect(_on_effect_triggered)
	
	xp_bar.max_value = multiplier_next_level
	xp_bar.value = 0
	update_multiplier_label()
	
	heat_bar.value = 0
	
	ore_hp = GameManager.ore_hp
	ore_max_hp = GameManager.ore_max_hp
	
	life_bar.value = ore_hp
	life_bar.max_value = GameManager.compute_ore_max_hp(GameManager.ore_level)
	update_life_bar()
	
	for ore in Enums.ORE.size():
		if ore == Enums.ORE.WOOD or ore == Enums.ORE.METAL:
			continue
		
		inventory.append(0)
		update_ore_label(ore, 0)
	
	for i in range(sequence_length):
		generate_symbol()
	
	music.play()
	
	timer.wait_time = timer_duration
	timer.stop()
	
	update_timer_label()
	
	await get_tree().process_frame
	
	if not GameManager.tuto_completed_game:
		tutorial.tutorial_finished.connect(_on_tutorial_finished)
		
		tutorial.start_tutorial([
			{"target": null, "text": "TUTO_GAME_MENU_WELCOME"},
			{"target": input_panel, "text": "TUTO_GAME_MENU_PANEL_INPUT"},
			{"target": heat_panel, "text": "TUTO_GAME_MENU_PANEL_HEAT"},
			{"target": timer_panel, "text": "TUTO_GAME_MENU_PANEL_TIMER"},
			{"target": xp_bar_panel, "text": "TUTO_GAME_MENU_PANEL_XP"},
			{"target": mult_panel, "text": "TUTO_GAME_MENU_PANEL_MULTIPLIER"},
			{"target": ore_panel, "text": "TUTO_GAME_MENU_PANEL_ORE"},
			{"target": ore_life_panel, "text": "TUTO_GAME_MENU_PANEL_LIFE"},
		])
	else:
		tutorial.visible = false


func _process(delta: float) -> void:
	if not GameManager.tuto_completed_game:
		return
	
	if not is_started:
		if input != -1:
			is_started = true
			timer.start()
	
	heat_energy -= Constants.HEAT_ENERGY_LOSS * delta
	
	update_heat_energy()
	update_timer_label()
	
	if run_finished:
		return
	
	if input != -1:
		var success = is_input_valid(input)

		if success:
			input_count[input] += 1
			input_success()
		else:
			input_failed()

		effect_manager.consume_input(success)

		update_sequence()
	
	input = -1
	
	effect_manager.process_effects(delta)


func get_shape_name(shape: int) -> String:
	return Constants.SHAPE_NAME[shape]


func get_ore_name(ore: Enums.ORE) -> String:
	return tr(Constants.ORE_NAME[ore])


func get_ore_quantity(ore: int) -> int:
	return inventory[ore]


func compute_spacer_height() -> void:
	var screen = get_viewport_rect().size
	var extra_height = max(0.0, screen.y - BASE_HEIGHT)


func play_ore_pop(ore: Enums.ORE) -> void:
	var effect := ore_pop_effect_scene.instantiate() as OrePopEffect
	sprite.add_child(effect)
	effect.play(ore)


func play_echo(ore: Enums.ORE) -> void:
	var effect := ore_pop_effect_scene.instantiate() as OrePopEffect
	
	sprite.add_child(effect)
	effect.play(ore)


func play_relic() -> void:
	var effect := relic_effect_scene.instantiate() as RelicEffect
	
	sprite.add_child(effect)
	effect.play()


func play_pickaxe() -> void:
	var effect := pickaxe_effect_scene.instantiate() as PickaxeEffect
	
	sprite.add_child(effect)
	effect.play()


func play_quantity_popup(quantity: int, ore: Enums.ORE) -> void:
	var effect := quantity_popup_effect_scene.instantiate() as QuantityPopupEffect
	
	input_section.add_child(effect)
	effect.play(quantity, ore)


func play_bomb() -> void:
	var effect := bomb_effect_scene.instantiate() as BombEffect
	
	sprite.add_child(effect)
	
	effect.exploded.connect(_on_bomb_exploded)
	effect.play()


func generate_symbol() -> void:
	var rdm_shape = roll_shape()
	var rdm_ore = roll_ore()
	var symbol = symbol_scene.instantiate() as Symbol
	
	symbol.ore = rdm_ore
	symbol.shape = rdm_shape
	
	input_section.add_child(symbol)
	
	var ore_shape = OreShape.new()
	
	ore_shape.ore = rdm_ore
	ore_shape.shape = rdm_shape
	
	sequence.append(ore_shape)


func is_input_valid(_input: int) -> bool:
	return _input == sequence[0].shape


func fill_sequence() -> void:
	var sequence_count = sequence.size()
	
	if sequence_count < sequence_length:
		var missing_symbol = sequence_length - sequence_count
		
		for i in range(missing_symbol):
			generate_symbol()


func roll_shape() -> int:
	var total = GameManager.get_total_shape_weight()
	var rdm = randf() * total
	var cumulative = 0
	
	for shape in Constants.SHAPE_WEIGHT:
		cumulative += Constants.SHAPE_WEIGHT[shape]
		
		if rdm <= cumulative:
			return shape
	
	return 0


func roll_ore() -> int:
	var total = GameManager.get_total_ore_weight()
	var rdm = randf() * total
	var cumulative = 0
	
	for ore in Constants.STAT_ORE_WEIGHT:
		cumulative += GameManager.stats[Constants.STAT_ORE_WEIGHT[ore]]
		
		if rdm <= cumulative:
			return ore
	
	return 0


func roll_artefact() -> void:
	var rdm = randf()
	
	if rdm <= Constants.ARTEFACT_CHANCE:
		var locked = []

		for key in GameManager.artefact_states:
			if GameManager.artefact_states[key] == 0:
				locked.append(key)

		if locked.is_empty():
			return

		var selected = locked.pick_random()
		GameManager.artefact_states[selected] = 1
		GameManager.artefact_remaining -= 1
		
		unlocked_artefacts.append(selected)


func collect_artefact() -> void:
	var locked = []

	for key in GameManager.artefact_states:
		if GameManager.artefact_states[key] == 0:
			locked.append(key)

	if locked.is_empty():
		return

	var selected = locked.pick_random()
	GameManager.artefact_states[selected] = 1
	GameManager.artefact_remaining -= 1


func feedback_fail() -> void:
	var tween = create_tween()
	tween.tween_property(static_ui, "position:x", -12, 0.03)
	tween.tween_property(static_ui, "position:x", 12, 0.03)
	tween.tween_property(static_ui, "position:x", -8, 0.03)
	tween.tween_property(static_ui, "position:x", 8, 0.03)
	tween.tween_property(static_ui, "position:x", 0, 0.03)
	
	Input.vibrate_handheld(30)


func feedback_sprite(critical: bool) -> void:
	if tween_sprite:
		tween_sprite.kill()
	
	tween_sprite = create_tween()
	tween_sprite.set_trans(Tween.TRANS_BACK)
	tween_sprite.set_ease(Tween.EASE_OUT)
	
	if critical:
		tween_sprite.tween_property(sprite, "self_modulate", Color(1.0, 0.0, 0.0, 1.0), 0.08)
		tween_sprite.tween_property(sprite, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.01)
	
	tween_sprite.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.08)
	tween_sprite.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.12)


func feedback_resource(ore: int) -> void:
	var resource_icon = null
	
	resource_icon = ore_icons[ore]
	
	if tween_resource:
		tween_resource.kill()
	
	tween_resource = create_tween()
	tween_resource.set_trans(Tween.TRANS_BACK)
	tween_resource.set_ease(Tween.EASE_OUT)
	
	tween_resource.tween_property(resource_icon, "scale", Vector2(1.1, 1.1), 0.08)
	tween_resource.tween_property(resource_icon, "scale", Vector2(1.0, 1.0), 0.12)


func die() -> void:
	timer.paused = true
	
	end_run()


func input_success() -> void:
	play_pickaxe()
	
	action_success += 1
	is_critical = false
	heat_energy += GameManager.stats[Enums.STAT.HEAT_ENERGY_GAIN]
	
	if heat_energy > 100.0:
		heat_energy = 100.0
	
	# Critical input
	var rdm_crit = randf()
	var crit_chance = GameManager.stats[Enums.STAT.CRIT_CHANCE]
	
	crit_chance += heat_crit
	
	if rdm_crit <= crit_chance:
		is_critical = true
		sfx_pickaxe_critical.play()
	else:
		sfx_pickaxe.play()
	
	var ore = sequence[0].ore
	var quantity = GameManager.stats[Constants.STAT_ORE_QUANTITY[ore]]
	var heat_bonus = true
	
	collect_ore(ore, quantity, is_critical, heat_bonus)
	feedback_resource(ore)
	feedback_sprite(is_critical)
	update_multiplier_from_ore(ore)
	update_heat_energy()
	play_ore_pop(ore)
	play_quantity_popup(quantity, ore)
	
	# Echo effect
	var rdm_echo = randf()
	var echo_chance = GameManager.stats[Enums.STAT.ECHO_CHANCE] + GameManager.stats[Enums.STAT.LUCK]
	
	if rdm_echo <= echo_chance:
		var echo_quantity = quantity * GameManager.stats[Enums.STAT.ECHO_POWER]
		collect_ore(ore, echo_quantity, false, false)
		play_echo(ore)
		sfx_echo.play()
	
	# Relic effect
	var rdm_relic = randf()
	var relic_chance = GameManager.stats[Enums.STAT.RELIC_CHANCE] + GameManager.stats[Enums.STAT.LUCK]

	if rdm_relic <= relic_chance:
		var relic_xp = GameManager.stats[Enums.STAT.RELIC_POWER]

		multiplier_xp += relic_xp
		update_multiplier(multiplier_xp)
		play_relic()
		sfx_relic.play()
	
	# Bomb effect
	var rdm_bomb = randf()
	var bomb_chance = GameManager.stats[Enums.STAT.BOMB_CHANCE] + GameManager.stats[Enums.STAT.LUCK]

	if rdm_bomb <= bomb_chance:
		play_bomb()
		sfx_bomb.play()
	
	# Gold rush effect
	var rdm_gold_rush = randf()
	var gold_rush_chance = GameManager.stats[Enums.STAT.GOLD_RUSH_CHANCE] + GameManager.stats[Enums.STAT.LUCK]

	if not effect_manager.has_effect("gold_rush"):
		if rdm_gold_rush <= gold_rush_chance:
			effect_manager.add_effect(Database.effects["gold_rush"], -1.0, 5, EffectManager.ConsumeMode.SUCCESS, Callable(self, "_apply_gold_rush"))
	
	var damage = GameManager.stats[Enums.STAT.DAMAGE_FLAT] + (GameManager.stats[Enums.STAT.DAMAGE_FLAT] * GameManager.stats[Enums.STAT.DAMAGE_PERCENT])
	
	if is_critical:
		damage = damage * GameManager.stats[Enums.STAT.CRIT_POWER]
	
	deal_damage(damage)
	
	if GameManager.artefact_remaining > 0 and GameManager.is_skill_unlocked(Enums.SKILL.UNLOCK_ARTEFACT):
		roll_artefact()


func input_failed() -> void:
	action_failed += 1
	
	feedback_fail()
	multiplier_penalty()
	timer_penalty()
	heat_penalty()
	
	sfx_pickaxe_fail.play()


func update_sequence() -> void:
	sequence.remove_at(0)
	
	var symbole = input_section.get_child(0)
	
	symbole.queue_free()
	
	var new_ore = sequence[0].ore
	
	generate_symbol()


func compute_xp(ore: Enums.ORE) -> float:
	var value = Constants.ORE_XP[ore]
	value += GameManager.stats[Constants.STAT_ORE_XP[ore]]
	
	return value
	

func update_multiplier_from_ore(ore: int) -> void:
	multiplier_xp += compute_xp(ore)
	multiplier_xp += (multiplier_xp * heat_xp)
	
	update_multiplier(multiplier_xp)


func update_multiplier(xp: float) -> void:
	xp_bar.value = xp
	
	while multiplier_xp > multiplier_next_level:
		multiplier += 1
		multiplier_xp -= multiplier_next_level
		multiplier_next_level = multiplier_xp_required(multiplier)
		xp_bar.max_value = multiplier_next_level
		xp_bar.value = multiplier_xp
	
	update_multiplier_label()


func update_heat_energy() -> void:
	if heat_energy < 0:
		heat_energy = 0
	
	heat_bar.value = heat_energy
	
	var heat_fill = heat_bar.get_theme_stylebox("fill")
	var new_heat_tier = 0
	
	if heat_energy < GameManager.stats[Enums.STAT.HEAT_TIER1] and current_heat_tier != new_heat_tier:
		new_heat_tier = 0
		
		heat_fill.border_color = Color(0.8, 0.8, 0.8, 1.0)
		heat_fill.bg_color = Color(0.6, 0.6, 0.6, 1.0)
		
	if heat_energy >= GameManager.stats[Enums.STAT.HEAT_TIER1] and heat_energy < GameManager.stats[Enums.STAT.HEAT_TIER2]:
		new_heat_tier = 1
		
		heat_fill.border_color = Color(0.918, 0.711, 0.0, 1.0)
		heat_fill.bg_color = Color(0.630, 0.491, 0.0, 1.0)
		
	elif heat_energy >= GameManager.stats[Enums.STAT.HEAT_TIER2] and heat_energy < GameManager.stats[Enums.STAT.HEAT_TIER3]:
		new_heat_tier = 2
		
		heat_fill.border_color = Color(0.0, 1.0, 0.0, 1.0)
		heat_fill.bg_color = Color(0.0, 0.630, 0.0, 1.0)
		
	elif heat_energy >= GameManager.stats[Enums.STAT.HEAT_TIER3]:
		new_heat_tier = 3
		
		heat_fill.border_color = Color(0.0, 0.448, 1.243, 1.0)
		heat_fill.bg_color = Color(0.0, 0.249, 0.731, 1.0)
	
	heat_bar.add_theme_stylebox_override("fill", heat_fill)
	
	if new_heat_tier != current_heat_tier:
		apply_heat_effects(new_heat_tier)
		current_heat_tier = new_heat_tier


func apply_heat_effects(tier: int) -> void:
	if tier >= 1:
		apply_heat_effect("heat_xp")
	else:
		remove_heat_effect("heat_xp")

	if tier >= 2:
		apply_heat_effect("heat_crit")
	else:
		remove_heat_effect("heat_crit")

	if tier >= 3:
		apply_heat_effect("heat_quantity")
	else:
		remove_heat_effect("heat_quantity")


func apply_heat_effect(effect_name: String) -> void:
	var effect = Database.effects[effect_name]

	match effect.name:
		"heat_xp":
			heat_xp = effect.stat_value.value

		"heat_crit":
			heat_crit = effect.stat_value.value

		"heat_quantity":
			heat_quantity = effect.stat_value.value

	effect_manager.add_effect(effect)


func remove_heat_effect(effect_name: String) -> void:
	match effect_name:
		"heat_xp":
			heat_xp = 0.0

		"heat_crit":
			heat_crit = 0.0

		"heat_quantity":
			heat_quantity = 0.0

	effect_manager.remove_effect(effect_name)


func remove_heat_effects() -> void:
	heat_xp = 0
	heat_crit = 0
	heat_quantity = 0

	effect_manager.remove_effect("heat_xp")
	effect_manager.remove_effect("heat_crit")
	effect_manager.remove_effect("heat_quantity")


func _apply_gold_rush(_active_effect: EffectManager.ActiveEffect) -> void:
	var gold_quantity = GameManager.stats[Enums.STAT.GOLD_RUSH_POWER]

	collect_ore(Enums.ORE.GOLD, gold_quantity, false, false)
	
	sfx_gold_rush.play()


func multiplier_penalty() -> void:
	multiplier -= multiplier * GameManager.stats[Enums.STAT.MULTIPLIER_PENALTY]
	multiplier_xp = 0
	xp_bar.value = 0
	
	if multiplier < 0: 
		multiplier = 0
	
	update_multiplier_label()


func timer_penalty() -> void:
	var new_timer = timer.time_left - GameManager.stats[Enums.STAT.TIMER_PENALTY]
	
	update_timer(new_timer)


func heat_penalty() -> void:
	heat_energy = heat_energy - (heat_energy * GameManager.stats[Enums.STAT.HEAT_PENALTY])
	heat_bar.value = heat_energy - (heat_energy * GameManager.stats[Enums.STAT.HEAT_PENALTY])
	
	update_heat_energy()


func deal_damage(damage: int) -> void:
	ore_hp -= damage
	
	update_life_bar()
	
	GameManager.task_states[Enums.TASK.DAMAGE_STONE].current_amount += damage
	
	if ore_hp <= 0:
		ore_dead = true
		

func _on_bomb_exploded() -> void:
	deal_damage(GameManager.stats[Enums.STAT.BOMB_POWER])
	
	var critical = true
	feedback_sprite(critical)
	

func update_life_bar() -> void:
	life_bar.value = ore_hp
	
	if ore_hp > ore_max_hp * 0.50 and ore_hp <= ore_max_hp * 0.75 :
		$CenterUI/StoneSprite/Sprite100.visible = false
		$CenterUI/StoneSprite/Sprite75.visible = true
		$CenterUI/StoneSprite/Sprite50.visible = false
		$CenterUI/StoneSprite/Sprite25.visible = false
	
	elif ore_hp > ore_max_hp * 0.25 and ore_hp <= ore_max_hp * 0.50:
		$CenterUI/StoneSprite/Sprite100.visible = false
		$CenterUI/StoneSprite/Sprite75.visible = false
		$CenterUI/StoneSprite/Sprite50.visible = true
		$CenterUI/StoneSprite/Sprite25.visible = false
	
	elif ore_hp > 0 and ore_hp <= ore_max_hp * 0.25:
		$CenterUI/StoneSprite/Sprite100.visible = false
		$CenterUI/StoneSprite/Sprite75.visible = false
		$CenterUI/StoneSprite/Sprite50.visible = false
		$CenterUI/StoneSprite/Sprite25.visible = true


func update_timer(value: float) -> void:
	if value <= 0:
		update_timer_label()
		timer.timeout.emit()
		return
	
	timer.start(value)


func update_timer_label() -> void:
	if is_started:
		timer_label.text = "%d" % [floor(int(timer.time_left))]
	else:
		timer_label.text = "%d" % [floor(int(timer_duration))]


func collect_ore(ore: int, quantity: float, critical: bool, heat: bool) -> void:
	var inventory_quantity = get_ore_quantity(ore)
	
	if heat:
		quantity += (quantity * heat_quantity)
	
	if critical:
		quantity += (quantity * GameManager.stats[Enums.STAT.CRIT_POWER])
	
	inventory_quantity += quantity
	
	update_inventory(ore, inventory_quantity)


func collect_reward(ore: Enums.ORE, quantity: int) -> void:
	GameManager.ore_inventory[ore] += quantity


func update_inventory(ore: int, quantity: int) -> void:
	inventory[ore] = int(quantity)
	update_ore_label(ore, quantity)


func update_ore_label(ore: int, quantity: int) -> void:
	var str_quantity = quantity
	
	if quantity == 0:
		str_quantity = "-"
	
	ore_run_labels[ore].text = str(str_quantity)


func update_multiplier_label() -> void:
	multiplier_label.text = str(multiplier)


func multiplier_xp_required(level: int) -> int:
	return int(2 + pow(level, 1.4) * 2)


func end_run() -> void:
	if timer.time_left != 0:
		timer.stop()
	
	run_finished = true
	effect_manager.clear()
	end_screen_ui.visible = true
	
	GameManager.run_completed += 1
	GameManager.task_states[Enums.TASK.RUN_COUNT].current_amount += 1
	
	GameManager.market_check_restock()
	
	var run_stats_str = tr("UI_GAME_RUNSTATS_LABEL_SUCCESS") + " : [color=#00ff00]" + str(action_success) + "[/color] - " + tr("UI_GAME_RUNSTATS_LABEL_FAIL") + " : [color=#ff0000]" + str(action_failed) + "[/color]\n"
	run_stats_str += tr("UI_GAME_RUNSTATS_LABEL_MULTIPLIER") + " : [color=#b434eb]" + str(multiplier) + "[/color]"
	
	run_stats.text = run_stats_str
	
	for i in inventory.size():
		var ore_amount = inventory[i] * multiplier
		var label_text = ""
		
		if inventory[i] == 0:
			label_text = "-"
		else:
			label_text = str(inventory[i]) + " x [color=#b434eb]" + str(multiplier) + "[/color] = " + str(ore_amount)
		
		ore_end_labels[i].text = label_text
		
		GameManager.add_ore(i, ore_amount)
	
	if not unlocked_artefacts.is_empty():
		end_artefacts_ui.visible = true
		
		for i in unlocked_artefacts.size():
			var artefact = Database.artefacts[unlocked_artefacts[i]]
			
			var icon = TextureRect.new()
			icon.custom_minimum_size = Vector2(150, 150)
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.texture = artefact.icon
			
			artefact_container.add_child(icon)
	
	if ore_dead:
		GameManager.ore_level += 1
		GameManager.ore_max_hp = GameManager.compute_ore_max_hp(GameManager.ore_level)
		GameManager.ore_hp = GameManager.ore_max_hp
		
		drop_reward()
		
		GameManager.task_states[Enums.TASK.DESTROY_STONE].current_amount += 1
	else:
		GameManager.ore_hp = ore_hp
	
	update_task_progress()
	
	SaveManager.save_game(SaveManager.get_save_data())


func update_task_progress() -> void:
	if multiplier > 0:
		GameManager.add_task_progress(Enums.TASK.COLLECT_STONE, inventory[Enums.ORE.STONE])
		GameManager.add_task_progress(Enums.TASK.COLLECT_GOLD, inventory[Enums.ORE.GOLD])
		GameManager.add_task_progress(Enums.TASK.COLLECT_SAPPHIRE, inventory[Enums.ORE.SAPPHIRE])
		GameManager.add_task_progress(Enums.TASK.COLLECT_RUBY, inventory[Enums.ORE.RUBY])
		GameManager.add_task_progress(Enums.TASK.COLLECT_EMERALD, inventory[Enums.ORE.EMERALD])
		GameManager.add_task_progress(Enums.TASK.COLLECT_DIAMOND, inventory[Enums.ORE.DIAMOND])
		
		var ore_collected = inventory[Enums.ORE.STONE] + inventory[Enums.ORE.GOLD] + inventory[Enums.ORE.SAPPHIRE] + inventory[Enums.ORE.RUBY] + inventory[Enums.ORE.EMERALD] + inventory[Enums.ORE.DIAMOND]
		GameManager.add_task_progress(Enums.TASK.COLLECT_ORE, ore_collected)
	
	GameManager.add_task_progress(Enums.TASK.INPUT_UP, input_count[0])
	GameManager.add_task_progress(Enums.TASK.INPUT_RIGHT, input_count[1])
	GameManager.add_task_progress(Enums.TASK.INPUT_DOWN, input_count[2])
	GameManager.add_task_progress(Enums.TASK.INPUT_LEFT, input_count[3])
	GameManager.add_task_progress(Enums.TASK.INPUT_TAP, input_count[4])
	
	var input_succeeded = input_count[0] + input_count[1] + input_count[2] + input_count[3] + input_count[4]
	GameManager.add_task_progress(Enums.TASK.INPUT_SUCCESS, input_succeeded)


func drop_reward() -> void:
	var rdm_reward = roll_reward()
	
	ore_level.text = tr("UI_GAME_MENU_REWARD_LABEL_LEVEL") + " : [color='#ff0000']"  + str(int(GameManager.ore_level)) + "[/color]"
	
	if rdm_reward == Enums.ORE_REWARD.ARTEFACT:
		collect_artefact()
		
		reward_icon.texture = load("res://assets/icons/artefact_icon.png")
	else:
		var rdm_quantity = roll_reward_quantity(rdm_reward)
		
		collect_reward(rdm_reward, rdm_quantity)
	
		reward_icon.texture = Utils.get_ore_icon(Constants.ORE_REWARD_ORE[rdm_reward])
		reward_quantity_label.text = "x " + str(rdm_quantity)


func roll_reward() -> int:
	var total = 0
	
	for weight in Constants.ORE_REWARD_WEIGHT:
		if weight == Enums.ORE_REWARD.ARTEFACT and (not GameManager.is_skill_unlocked(Enums.SKILL.UNLOCK_ARTEFACT) or GameManager.artefact_remaining <= 0):
			continue
		
		total += Constants.ORE_REWARD_WEIGHT[weight]
		
	var rdm = randf() * total
	var cumulative = 0
	
	for reward in Constants.ORE_REWARD_WEIGHT:
		if reward == Enums.ORE_REWARD.ARTEFACT and (not GameManager.is_skill_unlocked(Enums.SKILL.UNLOCK_ARTEFACT) or GameManager.artefact_remaining <= 0):
			continue
		
		cumulative += Constants.ORE_REWARD_WEIGHT[reward]
		
		if rdm <= cumulative:
			return reward
	
	return 0


func roll_reward_quantity(reward: Enums.ORE_REWARD) -> int:
	var reward_quantity = 1 
	
	if reward != Enums.ORE_REWARD.ARTEFACT:
		var rdm_quantity = randi_range(1, 10)
		
		reward_quantity = rdm_quantity * Constants.ORE_REWARD_MULT[reward] * GameManager.ore_level
	
	return reward_quantity


func _on_tap_input(_pos):
	input = 4


func _on_swipe_input(dir, _velocity):
	input = dir


func _on_hold_input(_pos, duration):
	pass


func _on_timer_timeout() -> void:
	end_run()


func _on_end_reward_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_end_screen_exit_pressed() -> void:
	if ore_dead:
		end_screen_ui.visible = false
		end_reward_ui.visible = true
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_effect_added(active_effect: EffectManager.ActiveEffect) -> void:
	var effect_icon := TextureRect.new()

	effect_icon.name = active_effect.effect.name
	effect_icon.texture = active_effect.effect.icon
	effect_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	effect_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	effect_icon.custom_minimum_size = Vector2(80, 80)

	active_effect_status.add_child(effect_icon)


func _on_effect_removed(active_effect: EffectManager.ActiveEffect) -> void:
	var effect_icon = active_effect_status.get_node_or_null(
		active_effect.effect.name
	)

	if effect_icon:
		effect_icon.queue_free()


func _on_effect_triggered(_active_effect: EffectManager.ActiveEffect) -> void:
	pass


func _on_end_artefact_exit_pressed() -> void:
	end_artefacts_ui.visible = false


func _on_tutorial_finished() -> void:
	GameManager.tuto_completed_game = true


func _on_double_reward_pressed() -> void:
	AdManager.show_rewarded_ad_with_callback(_on_reward_doubled)


func _on_reward_doubled() -> void:
	if reward_was_doubled:
		return

	reward_was_doubled = true
	
	for i in inventory.size():
		var ore_amount = inventory[i] * multiplier
		
		GameManager.add_ore(i, ore_amount)
	
	double_reward.visible = false


func _on_rewarded_availability_changed(available: bool) -> void:
	double_reward.visible = (
		not reward_was_doubled
		and available
	)
