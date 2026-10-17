class_name SkillButton extends Button

@onready var background_texture: TextureRect = $Background
@onready var primary_icon: TextureRect = $PrimaryIcon
@onready var secondary_icon: TextureRect = $SecondaryIcon

@export var skill_id: Enums.SKILL

var skill = null
var index: int

func _ready():
	skill = Database.skills[skill_id]
	
	primary_icon.texture = skill.primary_icon
	secondary_icon.texture = skill.secondary_icon
	tooltip_text = ""
	update_visual()


func set_index(_index: int) -> void:
	index = _index


func update_visual():
	if skill == null:
		return
	
	var level = GameManager.get_skill_level(skill_id)
	
	if level >= skill.max_level:
		self_modulate = Color(0.931, 0.782, 0.0, 1.0) # max
		background_texture.modulate = Color(1, 1, 1) # unlocked
		primary_icon.modulate = Color(1, 1, 1) # unlocked
		secondary_icon.modulate = Color(1, 1, 1) # unlocked
	
	elif SkillTreeManager.can_buy(skill_id):
		self_modulate = Color(0.0, 1.0, 0.0, 1.0) # locked
		background_texture.modulate = Color(1.0, 1.0, 1.0, 1.0) # locked
		primary_icon.modulate = Color(1.0, 1.0, 1.0, 1.0) # locked
		secondary_icon.modulate = Color(1.0, 1.0, 1.0, 1.0) # locked
	
	else:
		self_modulate = Color(1.0, 0.0, 0.0, 1.0) # locked
		background_texture.modulate = Color(1.0, 1.0, 1.0, 1.0) # locked
		primary_icon.modulate = Color(1.0, 1.0, 1.0, 1.0) # locked
		secondary_icon.modulate = Color(1.0, 1.0, 1.0, 1.0) # locked
