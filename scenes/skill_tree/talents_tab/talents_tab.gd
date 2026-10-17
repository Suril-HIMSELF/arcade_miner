extends Control

@onready var skills_container: GridContainer = $MarginContainer/ScrollContainer/SkillsContainer
@onready var sfx_skill: AudioStreamPlayer2D = $SFXSkill
@onready var tooltip: TooltipSkill = $Tooltip/Control


var skills_list = {}
const ore_cost_scene = preload("res://scenes/skill_tree/ore_cost/ore_cost.tscn")


func _ready() -> void:
	var __ = tooltip.skill_bought.connect(_on_skill_bought)
	
	var index = 0
	for button in skills_container.get_children():
		button.pressed.connect(_on_skill_pressed.bind(button.skill_id))
		
		skills_list[button.skill_id] = index
		
		index += 1


func _on_skill_pressed(skill_id: Enums.SKILL):
	if tooltip.visible:
		return
	
	tooltip.show_skill(skill_id)


func _on_skill_bought(skill_id: Enums.SKILL):
	sfx_skill.play()
	
	var node = skills_container.get_child(skills_list[skill_id]) as SkillButton
	
	node.update_visual()
	
	for button in skills_container.get_children():
		button.update_visual()
