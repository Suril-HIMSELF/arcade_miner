class_name QuestMenu extends Control

@onready var task_list: VBoxContainer = $MarginContainer/ScrollContainer/TaskList

const task_frame_scene: PackedScene = preload("res://scenes/quest_menu/task_frame/task_frame.tscn")


func _ready() -> void:
	var __ = GameManager.update_task.connect(_on_update_task)

	GameManager.check_tasks_progress()

	set_tasks()


func set_tasks() -> void:
	for task_id in Database.tasks:
		var task := create_task(task_id)

		var task_frame: TaskFrame = task_frame_scene.instantiate()

		task_list.add_child(task_frame)
		task_frame.setup(task)


func create_task(task_id: Enums.TASK) -> Task:
	var task_data = Database.tasks[task_id]

	var task := Task.new()

	task.id = task_id
	task.type = task_data.type
	task.description = task_data.description
	task.base_required_amount = task_data.base_required_amount
	task.required_exponent = task_data.required_exponent
	task.base_rewards = task_data.base_rewards
	task.reward_exponent = task_data.reward_exponent
	task.max_level = task_data.max_level
	task.icon = task_data.icon

	return task


func _on_update_task(id: Enums.TASK) -> void:
	for task_node in task_list.get_children():
		if task_node.task.id == id:
			var task := Task.from_data(id, Database.tasks[id])
			task_node.setup(task)
