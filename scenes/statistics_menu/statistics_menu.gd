extends Control


@onready var stat_container: VBoxContainer = $ScrollContainer/StatContainer


func _ready() -> void:
	var __ = InventoryManager.stat_changed.connect(_on_stat_changed)
	__ = SkillTreeManager.skill_bought.connect(_on_skill_bought)


func _on_skill_bought(id: int) -> void:
	var skill = Database.skills[id]
	var skill_stat = skill.stat.id
	
	var nodes = stat_container.find_children("*", "Node", true, false)
	
	for node in nodes:
		if not node is StatDisplay:
			continue
		
		if skill_stat == node.stat:
			node.refresh_value()




func _on_stat_changed() -> void:
	var nodes = stat_container.find_children("*", "Node", true, false)
	
	for node in nodes:
		if not node is StatDisplay:
			continue
		
		node.refresh_value()
