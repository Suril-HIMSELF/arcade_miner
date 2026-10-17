extends Node

signal skill_bought(id)
signal skill_inventory_bought
signal skill_restock_bought


func get_cost(id: Enums.SKILL) -> Array[OreQuantity]:
	var skill = Database.skills[id]
	var level = GameManager.get_skill_level(id)
	var base_cost = skill.cost as Array[OreQuantity]
	var new_cost: Array[OreQuantity] = []
	
	for cost in base_cost:
		var cost_level = cost.quantity * pow(Constants.SKILL_GROWTH, level)
		new_cost.append(OreQuantity.new(cost.ore, cost_level))
	
	return new_cost


func can_buy(id: Enums.SKILL) -> bool:
	var skill = Database.skills[id]
	var skill_level = GameManager.get_skill_level(id)
	
	if GameManager.skill_states.has(id):
		skill_level = GameManager.skill_states[id]
	
	if skill_level >= skill.max_level:
		return false
	
	var current_cost = get_cost(id)
	
	for cost in current_cost:
		if not GameManager.has_enough(cost.ore, cost.quantity):
			return false
	
	return true


func buy(id: Enums.SKILL) -> bool:
	if not can_buy(id):
		return false
	
	var current_cost = get_cost(id)
	
	GameManager.skill_states[id] = GameManager.get_skill_level(id) + 1
	
	var skill = Database.skills[id]
	
	if skill.stat != null:
		for cost in current_cost:
			GameManager.remove_ore(cost.ore, cost.quantity)
		
		GameManager.update_stat(skill.stat.id, skill.bonus)
	
	GameManager.level += 1
	GameManager.level_up.emit()
	GameManager.update_stats.emit()
	
	if skill.stat != null and skill.stat.id == Enums.STAT.INVENTORY_SLOTS:
		skill_inventory_bought.emit()
	
	if skill.stat != null and skill.stat.id == Enums.STAT.MARKET_RESTOCK:
		skill_restock_bought.emit()
	
	skill_bought.emit(id)
	
	SaveManager.save_game(SaveManager.get_save_data())
	
	return true


func skill_name(skill_id: Enums.SKILL) -> String:
	return Enums.SKILL.keys()[Enums.SKILL.values().find(skill_id)]
