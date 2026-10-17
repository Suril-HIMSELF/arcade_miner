class_name TooltipSkill extends Control

@onready var black_veil: ColorRect = $BlackVeil
@onready var backdrop: Control = $Backdrop
@onready var panel: PanelContainer = $Panel

@onready var title: Label = $Panel/VBoxContainer/Header/TitleContainer/Title
@onready var level: Label = $Panel/VBoxContainer/Header/TitleContainer/Level
@onready var icon: TextureRect = $Panel/VBoxContainer/Header/Button/Icon
@onready var description: Label = $Panel/VBoxContainer/DescriptionPanel/Description

@onready var separator_1: TextureRect = $Panel/VBoxContainer/Separator1

@onready var current_level: Control = $Panel/VBoxContainer/ContentPanel/ContentContainer/CurrentLevel
@onready var current_label: Label = $Panel/VBoxContainer/ContentPanel/ContentContainer/CurrentLevel/CurrentLabel
@onready var transition: Control = $Panel/VBoxContainer/ContentPanel/ContentContainer/Transition
@onready var next_level: Control = $Panel/VBoxContainer/ContentPanel/ContentContainer/NextLevel
@onready var next_label: Label = $Panel/VBoxContainer/ContentPanel/ContentContainer/NextLevel/NextLabel

@onready var footer: VBoxContainer = $Panel/VBoxContainer/Footer
@onready var cost_container: HBoxContainer = $Panel/VBoxContainer/Footer/CostContainer
@onready var button: Button = $Panel/VBoxContainer/Footer/Button

@onready var tooltip_skill: CanvasLayer = $".."

var current_id
var is_visible: bool = false

signal skill_bought(current_id)


func _ready():
	black_veil.visible = false
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	backdrop.gui_input.connect(_on_backdrop_gui_input)


func show_skill(id):
	black_veil.visible = true
	current_id = id
	var skill = Database.skills[id]
	
	if skill == null:
		return
	
	visible = true
	backdrop.visible = true
	panel.visible = true
	is_visible = true
	
	refresh_tooltip_skill()

func is_open() -> bool:
	return is_visible


func close_tooltip() -> void:
	black_veil.visible = false
	is_visible = false
	visible = false
	current_id = -1

	clear_cost()


func clear_cost() -> void:
	for node in cost_container.get_children():
		node.queue_free()


func refresh_button_skill():
	var skill = Database.skills[current_id]
	
	if skill == null:
		return
	
	var can_buy = SkillTreeManager.can_buy(current_id)
	var level = GameManager.get_skill_level(current_id)
	
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.visible = true
	button.text = "BUY"
	
	if level >= skill.max_level:
		button.disabled = true
		button.text = "MAX"
		cost_container.visible = false
	else:
		button.disabled = not can_buy
		cost_container.visible = true
	
	panel.call_deferred("reset_size")
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	if can_buy:
		button.modulate = Color(1, 1, 1)
	else:
		button.modulate = Color(0.5, 0.5, 0.5)


func refresh_tooltip_skill():
	const ore_cost_scene = preload("res://scenes/skill_tree/ore_cost/ore_cost.tscn")
	
	clear_cost()

	# Reset de la visibilité du contenu
	separator_1.visible = true
	current_level.visible = true
	transition.visible = true
	next_level.visible = true
	
	var skill = Database.skills[current_id]
	var level_skill = GameManager.get_skill_level(current_id)
	var costs = SkillTreeManager.get_cost(current_id)
	
	title.text = tr(skill.name).to_upper()
	level.text = tr("TOOLTIP_SKILL_LABEL_LEVEL") + " " + str(level_skill) + "/" + str(skill.max_level)
	icon.texture = skill.primary_icon
	
	description.text = tr(skill.description)
	
	if skill.stat.id != Enums.STAT.UNLOCK:
		if skill.stat != null:
			var current_value = Utils.display_stat_value(skill.bonus * level_skill, skill.stat.mode)
			var next_value = Utils.display_stat_value(skill.bonus * (level_skill + 1), skill.stat.mode)
		
			if level_skill < skill.max_level:
				current_label.text = current_value
				next_label.text = next_value
			else:
				transition.visible = false
				next_level.visible = false
				current_label.text = current_value
	else:
		separator_1.visible = false
		current_level.visible = false
		transition.visible = false
		next_level.visible = false
	
	if not costs.is_empty():
		for cost in costs:
			var ore_cost = ore_cost_scene.instantiate()
			
			cost_container.add_child(ore_cost)
			
			ore_cost.setup(cost.ore, cost.quantity)
	
	refresh_button_skill()


func _on_buy_button_pressed() -> void:
	if SkillTreeManager.buy(current_id):
		skill_bought.emit(current_id)
		refresh_tooltip_skill()


func _on_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			close_tooltip()
			backdrop.accept_event()

	elif event is InputEventScreenTouch:
		if event.pressed:
			close_tooltip()
			backdrop.accept_event()
