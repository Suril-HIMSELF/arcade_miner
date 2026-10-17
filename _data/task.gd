class_name Task
extends Resource


@export var type: Enums.TASK_TYPE
@export var id: Enums.TASK
@export var description: String
@export var base_required_amount: int
@export var required_exponent: float = 2.0
@export var base_rewards: Array[OreQuantity] = []
@export var reward_exponent: float = 1.0
@export var max_level: int = 0
@export var icon: Texture2D


func get_required_amount(level: int) -> int:
	var scaling_level := get_scaling_level(level)

	var amount := ceili(
		base_required_amount * pow(scaling_level, required_exponent)
	)

	if amount >= 10:
		amount = ceili(amount / 10.0) * 10

	return amount


func get_rewards(level: int) -> Array[OreQuantity]:
	var scaling_level := get_scaling_level(level)
	var rewards: Array[OreQuantity] = []

	for base_reward in base_rewards:
		var quantity := ceili(
			base_reward.quantity
			* pow(scaling_level, reward_exponent)
			/ 10.0
		) * 10

		var reward := OreQuantity.new(
			base_reward.ore,
			quantity
		)

		rewards.append(reward)

	return rewards


func get_description(level: int) -> String:
	return tr(description)


func is_completed(current_amount: int, level: int) -> bool:
	return current_amount >= get_required_amount(level)


func get_progress(current_amount: int, level: int) -> float:
	var required_amount := get_required_amount(level)

	if required_amount <= 0:
		return 1.0

	return clampf(
		float(current_amount) / float(required_amount),
		0.0,
		1.0
	)                              


static func from_data(id: Enums.TASK, data) -> Task:
	var task := Task.new()

	task.id = id
	task.description = data.description
	task.base_required_amount = data.base_required_amount
	task.required_exponent = data.required_exponent
	task.base_rewards = data.base_rewards
	task.reward_exponent = data.reward_exponent
	
	return task


func get_scaling_level(level: int) -> int:
	if max_level <= 0:
		return level

	return min(level, max_level)
