extends Node

@export var ore_data := [
	{"weight": 50.0, "value": 1.0},
	{"weight": 30.0, "value": 3.0},
	{"weight": 10.0, "value": 6.0},
	{"weight": 6.0, "value": 10.0},
	{"weight": 3.0, "value": 30.0},
	{"weight": 1.0, "value": 50.0}
]




@export var stone_quantity: float = 1.0
@export var gold_quantity: float = 0.5
@export var sapphire_quantity: float = 0.5
@export var ruby_quantity: float = 0.5
@export var emerald_quantity: float = 0.5
@export var diamond_quantity: float = 1.0

@export var stone_xp: float = 0.5
@export var gold_xp: float = 0.5
@export var sapphire_xp: float = 0.5
@export var ruby_xp: float = 0.5
@export var emerald_xp: float = 0.5
@export var diamond_xp: float = 0.5

@export var timer_duration: float = 15.0
@export var timer_penalty: float = 3.0

@export var multiplier_penalty: float = 0.8

@export var crit_chance: float = 0.0
@export var crit_power: float = 1.2

@export var base_multiplier: float = 0.0

#Mapping ore <-> stat : quantity -> gold (1), xp -> sapphire (2), crit -> emerald (4), multiplier -> ruby (3), timer -> diamond (5)
@export var main_index: int = 5 # Index minerai lié à la stat -> coût principal skill
@export var context_index: int = 0 # Index minerai lié à la ressource affectée par la stat -> coût secondaire skill (-1 si non utilisé)
@export var use_stone: bool = false

var P_old: float = 146.971585504603


func _ready() -> void:
	print("compute_power : " + str(compute_power()))
	print("compute_value_per_input : " + str(compute_value_per_input()))
	print("compute_xp_average : " + str(compute_xp_average()))
	
	if P_old != 0:
		var gain = compute_gain()
		var cost = compute_cost(gain)
		var tier = compute_tier(gain)
		var split = split_cost(cost, main_index, context_index, use_stone, tier)
		
		
		print("\ngain% : " + str(gain))
		print("cost : " + str(cost))
		print("tier : " + str(tier))
		
		var split_str = "[ "
		
		for i in split.size():
			if split[i] == 0:
				continue
			
			split_str += Constants.ORE_NAME[i] + ": " + str(split[i]) + ", "
		
		split_str = split_str.left(split_str.length() -2)
		split_str += " ]"
		
		print("split : " + split_str)


func compute_power():
	var inputs_per_sec = 2.5
	var inputs = inputs_per_sec * timer_duration

	var V_input = compute_value_per_input()
	var xp_avg = compute_xp_average()

	var xp_total = inputs * xp_avg

	var levels = compute_levels_gained(xp_total, base_multiplier)
	
	var M = base_multiplier + levels * 0.5
	
	var crit = 1.0 + crit_chance * (crit_power - 1.0)

	return inputs * V_input * M * crit


func compute_value_per_input():
	var total = 0.0
	
	total += (ore_data[0].weight / 100) * stone_quantity * ore_data[0].value
	total += (ore_data[1].weight / 100) * gold_quantity * ore_data[1].value
	total += (ore_data[2].weight / 100) * sapphire_quantity * ore_data[2].value
	total += (ore_data[3].weight / 100) * ruby_quantity * ore_data[3].value
	total += (ore_data[4].weight / 100) * emerald_quantity * ore_data[4].value
	total += (ore_data[5].weight / 100) * diamond_quantity * ore_data[5].value

	return total


func compute_xp_average():
	var total = 0.0

	total += (ore_data[0].weight / 100) * stone_xp
	total += (ore_data[1].weight / 100) * gold_xp
	total += (ore_data[2].weight / 100) * sapphire_xp
	total += (ore_data[3].weight / 100) * ruby_xp
	total += (ore_data[4].weight / 100) * emerald_xp
	total += (ore_data[5].weight / 100) * diamond_xp
	
	return total


func compute_levels_gained(xp_total: float, base_level: float) -> float:
	var level = base_level
	var xp = xp_total
	var gained = 0.0

	while true:
		var needed = 2.0 + pow(level, 1.4) * 2.0

		if xp < needed:
			gained += xp / needed
			break

		xp -= needed
		level += 1.0
		gained += 1.0

	return gained


func compute_gain():
	var P_new = compute_power()
	
	return (P_new - P_old) / P_old


func compute_cost(gain_percent: float):
	var x = gain_percent * 100.0
	
	return 8.0 * pow(log(1.0 + x), 2.5)


func split_cost(cost_value: float, main: int, context: int, use_stone: bool, tier: int) -> Array:
	var ore_values = [1.0, 3.0, 6.0, 10.0, 30.0, 50.0]
	var result = [0, 0, 0, 0, 0, 0]

	# ratios
	var main_ratio = 0.6 + (tier - 1) * 0.05
	var context_ratio = 0.2 if context != -1 else 0.0
	var stone_ratio = 0.15 if use_stone else 0.0

	# clamp total
	var total = main_ratio + context_ratio + stone_ratio
	if total > 0.9:
		var scale = 0.9 / total
		main_ratio *= scale
		context_ratio *= scale
		stone_ratio *= scale

	var remaining = 1.0 - (main_ratio + context_ratio + stone_ratio)

	# MAIN
	result[main] = max(1, floor((cost_value * main_ratio) / ore_values[main]))

	# CONTEXT
	if context != -1:
		result[context] = max(1, floor((cost_value * context_ratio) / ore_values[context]))

	# STONE
	if use_stone:
		result[0] = max(1, floor((cost_value * stone_ratio) / ore_values[0]))

	# RANDOM (1 max)
	if remaining > 0.05:
		var candidates = []
		for i in range(6):
			if i != main and i != context and (not use_stone or i != 0):
				candidates.append(i)

		var rand_idx = candidates[randi() % candidates.size()]
		result[rand_idx] = max(1, floor((cost_value * remaining) / ore_values[rand_idx]))

	return result


func compute_tier(gain):
	if gain < 0.02:
		return 1
	elif gain < 0.05:
		return 2
	elif gain < 0.1:
		return 3
	elif gain < 0.2:
		return 4
	else:
		return 5
