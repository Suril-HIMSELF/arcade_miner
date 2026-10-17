class_name TaskFrame
extends Panel

@onready var icon: TextureRect = $VBoxContainer/Header/Button/Icon
@onready var level: RichTextLabel = $VBoxContainer/Header/TitleHeader/HBoxContainer/Level
@onready var description: Label = $VBoxContainer/Header/TitleHeader/Description
@onready var requirement: Label = $VBoxContainer/Header/TitleHeader/HBoxContainer/Requirement
@onready var rewards_container: HBoxContainer = $VBoxContainer/HBoxContainer/RewardsContainer
@onready var claim_button: Button = $VBoxContainer/HBoxContainer/ClaimButton
@onready var sfx_claim: AudioStreamPlayer2D = $SfxClaim


const reward_scene: PackedScene = preload("res://scenes/quest_menu/task_rewards/task_rewards.tscn")

var task: Task


func _ready() -> void:
	claim_button.pressed.connect(_on_claim_pressed)


func setup(task_data: Task) -> void:
	task = task_data

	var state: Dictionary = GameManager.task_states[task.id]

	var state_level: int = state["level"]
	var current_amount: int = state["current_amount"]
	var required_amount: int = task.get_required_amount(state_level)
	
	icon.texture = task.icon
	level.text = tr("UI_TASK_FRAME_LABEL_LEVEL") + " : [color='#91c65eff']"  + str(state_level) + "[/color]"
	description.text = task.get_description(state_level) 
	requirement.text = " %d / %d" % [current_amount, required_amount]

	for child in rewards_container.get_children():
		child.queue_free()

	var rewards := task.get_rewards(state_level)

	for reward_data in rewards:
		var reward: Reward = reward_scene.instantiate()
		rewards_container.add_child(reward)
		reward.setup(reward_data)

	claim_button.disabled = not state["finished"]
	claim_button.focus_mode = (
		Control.FOCUS_ALL
		if state["finished"]
		else Control.FOCUS_NONE
	)


func _on_claim_pressed() -> void:
	sfx_claim.play()
	claim_button.release_focus()
	GameManager.claim_task(task.id)
	
	task.max_level = Database.tasks[task.id].max_level
	
	setup(task)
