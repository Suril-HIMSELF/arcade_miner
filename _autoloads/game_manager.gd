extends Node


signal update_ore
signal level_up
signal update_stats
signal update_task

# GAME
var run_completed: int
var level: int
var master_volume: float = 100.0
var music_volume: float = 100.0
var sfx_volume: float = 100.0
var language: String = "en"
var audio_muted: bool = false
var tuto_completed_main: bool = false
var tuto_completed_game: bool = false

# STATS
var default = {
	Enums.STAT.STONE_QUANTITY: 1.0,
	Enums.STAT.GOLD_QUANTITY: 1.0,
	Enums.STAT.SAPPHIRE_QUANTITY: 1.0,
	Enums.STAT.RUBY_QUANTITY: 1.0,
	Enums.STAT.EMERALD_QUANTITY: 1.0,
	Enums.STAT.DIAMOND_QUANTITY: 1.0,
	
	Enums.STAT.STONE_XP: 1.0,
	Enums.STAT.GOLD_XP: 1.0,
	Enums.STAT.SAPPHIRE_XP: 1.0,
	Enums.STAT.RUBY_XP: 1.0,
	Enums.STAT.EMERALD_XP: 1.0,
	Enums.STAT.DIAMOND_XP: 1.0,
	
	Enums.STAT.TIMER_DURATION: 15.0,
	Enums.STAT.TIMER_PENALTY: 3.0,
	
	Enums.STAT.MULTIPLIER_PENALTY: 0.6,
	
	Enums.STAT.CRIT_CHANCE: 0.0,
	Enums.STAT.CRIT_POWER: 1.5,
	
	Enums.STAT.LUCK: 0.0,
	
	Enums.STAT.STONE_WEIGHT: Constants.BASE_ORE_WEIGHT[Enums.ORE.STONE],
	Enums.STAT.GOLD_WEIGHT: Constants.BASE_ORE_WEIGHT[Enums.ORE.GOLD],
	Enums.STAT.SAPPHIRE_WEIGHT: Constants.BASE_ORE_WEIGHT[Enums.ORE.SAPPHIRE],
	Enums.STAT.RUBY_WEIGHT: Constants.BASE_ORE_WEIGHT[Enums.ORE.RUBY],
	Enums.STAT.EMERALD_WEIGHT: Constants.BASE_ORE_WEIGHT[Enums.ORE.EMERALD],
	Enums.STAT.DIAMOND_WEIGHT: Constants.BASE_ORE_WEIGHT[Enums.ORE.DIAMOND],
	
	Enums.STAT.ECHO_CHANCE: 0.0,
	Enums.STAT.ECHO_POWER: 1.0,
	
	Enums.STAT.GOLD_RUSH_CHANCE: 0.0,
	Enums.STAT.GOLD_RUSH_POWER: 1.0,
	
	Enums.STAT.BOMB_CHANCE: 0.0,
	Enums.STAT.BOMB_POWER: 10.0,
	
	Enums.STAT.RELIC_CHANCE: 0.0,
	Enums.STAT.RELIC_POWER: 1.0,
	
	Enums.STAT.DAMAGE_FLAT: 10.0,
	Enums.STAT.DAMAGE_PERCENT: 0.0, 
	
	Enums.STAT.INVENTORY_SLOTS: 10.0,
	
	Enums.STAT.MARKET_RESTOCK: 10.0,
	
	Enums.STAT.HEAT_ENERGY_GAIN: 15.0,
	Enums.STAT.HEAT_ENERGY_LOSS: 10.0,
	Enums.STAT.HEAT_PENALTY: 1.0,
	Enums.STAT.HEAT_XP: 0.2,
	Enums.STAT.HEAT_CRIT: 0.1,
	Enums.STAT.HEAT_QUANTITY: 0.1,
	Enums.STAT.HEAT_TIER1: 40,
	Enums.STAT.HEAT_TIER2: 70,
	Enums.STAT.HEAT_TIER3: 85,
}

var stats: Dictionary

# ITEMS
var items: Dictionary = {}

# INVENTORY
var ore_inventory: Dictionary = {
	Enums.ORE.STONE: 0,
	Enums.ORE.GOLD: 0,
	Enums.ORE.SAPPHIRE: 0,
	Enums.ORE.RUBY: 0,
	Enums.ORE.EMERALD: 0,
	Enums.ORE.DIAMOND: 0,
	Enums.ORE.WOOD: 0,
	Enums.ORE.METAL: 0,
}

var equipment_items: Array = ["", "", "", ""]
var inventory_items: Array = [
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"", 
	"",
	"",
]

var equipped_artefact: String = ""
var inventory_artefacts: Array = ["", "", "", "", "", "", "", "", "", ""]
var artefact_states: Dictionary = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0}
var artefact_remaining: int
var artefact_chance: float

# SKILLS
var skill_states: Dictionary = {}

# MARKET
var market_modifier: float
var market_reload_count: int = 0
var market_state = [
		{"ore": Enums.ORE.STONE, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.GOLD, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.SAPPHIRE, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.RUBY, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.EMERALD, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.DIAMOND, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.WOOD, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.METAL, "buy_price": 0, "sell_price": 0, "quantity": 0},
	]

# QUEST
var task_states: Dictionary = {}

# Ore boss
var ore_hp: int = 25
var ore_max_hp: int = 25
var ore_level: int = 1


func _ready() -> void:
	var __ = InventoryManager.item_equipped.connect(_on_item_equipped)
	__ = InventoryManager.item_unequipped.connect(_on_item_unequipped)
	__ = InventoryManager.artefact_equipped.connect(_on_artefact_equipped)
	__ = InventoryManager.artefact_unequipped.connect(_on_artefact_unequipped)


func initialize():
	stats = default.duplicate(true)
	
	apply_unlocked_skills()
	
	for item_hash in inventory_items:
		update_items(item_hash)
	
	market_check_restock()
	update_artefacts()
	apply_equipped_artefact()
	apply_equipped_items()
	initialize_tasks()
	check_tasks_progress()
	
	ore_max_hp = compute_ore_max_hp(ore_level)
	ore_hp = ore_max_hp
	
	if tuto_completed_main:
		TranslationServer.set_locale(GameManager.language)
		LanguageManager.set_language(GameManager.language)
	else:
		var available_languages := TranslationServer.get_loaded_locales()
		
		GameManager.language = OS.get_locale().get_slice("_", 0)
		
		if GameManager.language in available_languages:
			TranslationServer.set_locale(GameManager.language)
			LanguageManager.set_language(GameManager.language)
		else:
			GameManager.language = "en"
			TranslationServer.set_locale(GameManager.language)
			LanguageManager.set_language(GameManager.language)


func apply_unlocked_skills() -> void:
	if skill_states.is_empty():
		return
	
	for id in skill_states:
		if Database.skills[id].stat == null: # Cas skill unlock
			continue
		
		var skill = Database.skills[id]
		
		if skill.bonus != 0:
			var value = skill.bonus * get_skill_level(id)
			
			GameManager.update_stat(skill.stat.id, value)
		else:
			continue


func update_items(item_hash: String) -> void:
	items.clear()
	
	if not item_hash.is_empty():
		var item = ItemFactory.item_from_hash(item_hash)
		
		items[item_hash] = {
			"description": item.description,
			"icon": item.icon,
			"type": item.type,
			"rarity": item.rarity,
			"stats": item.stats
		}


func apply_equipped_artefact() -> void:
	if GameManager.equipped_artefact == "":
		return
	
	var artefact_hash = GameManager.equipped_artefact
	var artefact = ItemFactory.item_from_hash(artefact_hash)
	
	for stat in artefact.stats:
		update_stat(stat.stat, stat.value)


func apply_equipped_items() -> void:
	pass


func add_ore(ore: Enums.ORE, amount: int) -> void:
	ore_inventory[ore] = ore_inventory.get(ore, 0) + amount


func remove_ore(ore: Enums.ORE, amount: int) -> bool:
	if not has_enough(ore, amount):
		return false
	
	ore_inventory[ore] = ore_inventory.get(ore, 0) - amount
	
	update_ore.emit()
	
	return true


func has_enough(ore: Enums.ORE, amount: int) -> bool:
	if ore_inventory.get(ore, 0) >= amount:
		return true
	
	return false


func get_total_shape_weight() -> float:
	var total = 0
	
	total += Constants.SHAPE_WEIGHT[Enums.SHAPE.UP]
	total += Constants.SHAPE_WEIGHT[Enums.SHAPE.RIGHT]
	total += Constants.SHAPE_WEIGHT[Enums.SHAPE.DOWN]
	total += Constants.SHAPE_WEIGHT[Enums.SHAPE.LEFT]
	total += Constants.SHAPE_WEIGHT[Enums.SHAPE.TAP]
	
	return total


func get_total_ore_weight() -> float:
	var total = 0
	
	total += stats[Enums.STAT.STONE_WEIGHT]
	total += stats[Enums.STAT.GOLD_WEIGHT]
	total += stats[Enums.STAT.SAPPHIRE_WEIGHT]
	total += stats[Enums.STAT.RUBY_WEIGHT]
	total += stats[Enums.STAT.EMERALD_WEIGHT]
	total += stats[Enums.STAT.DIAMOND_WEIGHT]
	
	return total


func update_stat(stat: Enums.STAT, value: float) -> void:
	if stat == Enums.STAT.UNLOCK:
		return
	
	if not default.has(stat):
		push_error("Missing stat in GameManager.stats: " + str(stat))
		
		return
	
	stats[stat] = stats[stat] + value


# SKILL
func get_skill_level(id: int) -> int:
	return skill_states.get(id, 0)


func is_skill_unlocked(id: Enums.SKILL) -> bool:
	var skill_state = skill_states.get(id, 0)
	
	if skill_state != 0:
		return true
	
	return false

# MARKET
func market_reset_stocks() -> void:
	market_modifier = randf_range(0.9, 1.1)
	
	market_state = [
		{"ore": Enums.ORE.STONE, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.GOLD, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.SAPPHIRE, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.RUBY, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.EMERALD, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.DIAMOND, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.WOOD, "buy_price": 0, "sell_price": 0, "quantity": 0},
		{"ore": Enums.ORE.METAL, "buy_price": 0, "sell_price": 0, "quantity": 0},
	]


func market_compute_stocks() -> void:
	for ore in Enums.ORE.size():
		if ore == Enums.ORE.STONE or ore == Enums.ORE.GOLD:
			continue
		
		var buy_price = market_compute_ore_price(ore)
		var sell_price = int(floor(buy_price * randf_range(0.3, 0.6)))
		var quantity = market_compute_ore_quantity(ore)
		
		market_state[ore].quantity = quantity
		market_state[ore].buy_price = buy_price
		market_state[ore].sell_price = sell_price


func market_check_restock() -> void:
	if run_completed % int(stats[Enums.STAT.MARKET_RESTOCK]) == 0:
		market_reload_count = 0
		market_reset_stocks()
		market_compute_stocks()


func market_compute_ore_price(ore: int) -> int:
	var base_price = 0
	var noise = 0
	var price = 0
	
	if ore == Enums.ORE.WOOD:
		base_price = 5
	elif ore == Enums.ORE.METAL:
		base_price = 10
	else:
		var ore_value = Constants.BASE_ORE_VALUE[ore]
	
		base_price = Constants.PRICE_FACTOR * pow(ore_value, 0.8)
	
	noise = randf_range(0.80, 1.20)
	price = int(round(base_price * market_modifier * noise))
	
	return price


func market_compute_ore_quantity(ore: int) -> int:
	var quantity = randi_range(0, Constants.MARKET_MAX[ore])
	var rdm = randf()
		
	if rdm < 0.10:
		quantity += int(round(quantity * randf_range(1.5, 2.5)))
	
	return quantity


func compute_ore_max_hp(level: int) -> int:
	return 25 * (1 + 1.5 * (level - 1))


func update_effect_value(effect: Effect) -> void:
	effect.bonus.value = stats[effect.bonus.stat]


# ITEMS
func get_inventory_item_hash(inventory_slot: int) -> String:
	return inventory_items[inventory_slot]


func get_equipped_item_hash(equipment_slot: Enums.ITEM_TYPE) -> String:
	return equipment_items[equipment_slot]


func get_inventory_artefact_hash(artefact_id: int) -> String:
	return Database.artefacts[artefact_id]


func get_equipped_artefact_hash() -> String:
	return equipped_artefact


func add_item(item_hash: String) -> void:
	var slot = get_first_empty_slot()
	
	if slot == -1:
		return
	
	inventory_items[slot] = item_hash


func remove_item(item_hash: String) -> void:
	var slot = get_item_slot(item_hash)
	
	if slot == -1:
		return
	
	inventory_items[slot] = ""


func get_first_empty_slot() -> int:
	for i in inventory_items.size():
		if inventory_items[i] == "":
			return i
	
	return -1


func update_artefacts() -> void:
	artefact_remaining = Database.artefacts.size()
	
	for i in Database.artefacts.size():
		inventory_artefacts[i] = Database.artefacts[i].hash
	
	artefact_chance = Constants.ARTEFACT_CHANCE
	
	for key in artefact_states:
		if artefact_states[key] == 1:
			artefact_remaining -= 1


func get_item_slot(item_hash: String) -> int:
	return inventory_items.find(item_hash)


func get_remaining_inventory_slot() -> int:
	var count = 0
	
	for i in inventory_items.size():
		if inventory_items[i] == "":
			count += 1
	
	return count


func get_remaining_locked_artefact() -> int:
	var count = 0
	
	for i in artefact_states.size():
		if artefact_states[i] == 0:
			count += 1
	
	return count


func check_tasks_progress() -> void:
	for task_id in Database.tasks:
		var task_data = Database.tasks[task_id]
		var state: Dictionary = task_states[task_id]

		if state["finished"]:
			continue

		var task := Task.new()

		task.id = task_id
		task.description = task_data.description
		task.base_required_amount = task_data.base_required_amount
		task.required_exponent = task_data.required_exponent
		task.base_rewards = task_data.base_rewards
		task.reward_exponent = task_data.reward_exponent
		task.max_level = task_data.max_level

		var level: int = state["level"]
		var current_amount: int = state["current_amount"]
		var required_amount: int = task.get_required_amount(level)

		if current_amount >= required_amount:
			state["current_amount"] = required_amount
			state["finished"] = true


func add_task_progress(task_id: Enums.TASK, amount: int) -> void:
	var state: Dictionary = task_states[task_id]

	if state["finished"]:
		return

	var task_data = Database.tasks[task_id]

	var task := Task.new()

	task.id = task_id
	task.description = task_data.description
	task.base_required_amount = task_data.base_required_amount
	task.required_exponent = task_data.required_exponent
	task.base_rewards = task_data.base_rewards
	task.reward_exponent = task_data.reward_exponent
	task.max_level = task_data.max_level

	var level: int = state["level"]
	var required_amount: int = task.get_required_amount(level)

	state["current_amount"] = min(
		state["current_amount"] + amount,
		required_amount
	)

	if state["current_amount"] >= required_amount:
		state["finished"] = true


func claim_task(task_id: Enums.TASK) -> void:
	if not task_states.has(task_id):
		return

	var task_data = Database.tasks[task_id]
	var state: Dictionary = task_states[task_id]

	if not state["finished"]:
		return

	var task := Task.new()

	task.id = task_id
	task.description = task_data.description
	task.base_required_amount = task_data.base_required_amount
	task.required_exponent = task_data.required_exponent
	task.base_rewards = task_data.base_rewards
	task.reward_exponent = task_data.reward_exponent
	task.max_level = task_data.max_level
	
	var level: int = state["level"]
	var rewards := task.get_rewards(level)

	for reward in rewards:
		add_ore(reward.ore, reward.quantity)
	
	update_ore.emit()
	
	state["level"] += 1
	state["current_amount"] = 0
	state["finished"] = false
	
	SaveManager.save_game(SaveManager.get_save_data())
	
	update_task.emit(task_id)


func initialize_tasks() -> void:
	for task_id in Database.tasks:
		if not task_states.has(task_id):
			task_states[task_id] = {
				"level": 1,
				"current_amount": 0,
				"finished": false
			}


func reset_game() -> void:
	skill_states = {}
	equipped_artefact = ""
	artefact_states = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0}
	equipment_items = ["", "", "", ""]
	inventory_items = [
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
	]
	
	ore_inventory = {
		Enums.ORE.STONE: 100000,
		Enums.ORE.GOLD: 100000,
		Enums.ORE.SAPPHIRE: 100000,
		Enums.ORE.RUBY: 100000,
		Enums.ORE.EMERALD: 100000,
		Enums.ORE.DIAMOND: 100000,
		Enums.ORE.WOOD: 100000,
		Enums.ORE.METAL: 100000,
	}
	
	stats = default
	level = 0
	ore_level = 1
	ore_hp = compute_ore_max_hp(ore_level)
	run_completed = 0
	
	update_ore.emit()
	level_up.emit()
	
	market_reset_stocks()
	
	SaveManager.save_game(SaveManager.get_save_data())


func _on_item_equipped(item_hash: String) -> void:
	var item = ItemFactory.item_from_hash(item_hash)
	
	for stat in item.stats:
		update_stat(stat.stat, stat.value)


func _on_item_unequipped(item_hash: String) -> void:
	var item = ItemFactory.item_from_hash(item_hash)
	
	for stat in item.stats:
		update_stat(stat.stat, -stat.value)


func _on_artefact_equipped(artefact: Item) -> void:
	for stat in artefact.stats:
		update_stat(stat.stat, stat.value)


func _on_artefact_unequipped(artefact: Item) -> void:
	for stat in artefact.stats:
		update_stat(stat.stat, -stat.value)
