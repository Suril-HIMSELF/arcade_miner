extends Node


# Game data
var stat_definitions: Dictionary = {}
var ore_affinity: Dictionary = {}
var item_affinity: Dictionary = {}
var item_descriptions: Dictionary = {}
var artefacts: Dictionary = {}
var effects: Dictionary = {}
var skills: Dictionary = {}
var stats: Dictionary = {}
var tasks: Dictionary = {}
var skill_definitions: Dictionary = {}
var skill_children_cache: Dictionary = {}
var ore_icons: Array[Texture2D]
var symbol_icons: Array[Texture2D]
var artefact_icons: Array[Texture2D]


func initialize() -> void:
	load_ore_atlas()
	load_symbol_atlas()
	load_artefact_atlas()
	load_all_stats()
	load_all_item_descriptions()
	load_all_artefacts()
	load_all_effects()
	load_all_skills()
	load_all_tasks()


func load_all_stats():
	var path = "res://_resources/stats/"
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No data folder")
		return
	
	dir.list_dir_begin()
	var files = ResourceLoader.list_directory(path)
	
	for i in files.size():
		var stat: StatDefinition = load(path + files[i])
		
		stat_definitions[stat.id] = {
			"name": stat.name,
			"description": stat.description,
			"rarity": stat.rarity,
			"tags": stat.tags,
			"mode": stat.mode,
			"bonus_min": stat.bonus_min,
			"bonus_max": stat.bonus_max,
			"item_affinity": stat.item_affinity,
			"ore_affinity": stat.ore_affinity
		}
	
	#stat_definitions.sort()


func load_all_item_affinities():
	var path = "res://_resources/items/stat_affinity/"
	
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No data folder")
		return
	
	dir.list_dir_begin()
	var files = ResourceLoader.list_directory(path)
	
	for i in files.size():
		var affinity = load(path + files[i])
			
		item_affinity[affinity.item_type] = affinity.stats
	
	dir.list_dir_end()

func load_all_ore_affinities():
	var path = "res://_resources/ores/stat_affinity/"
	
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No data folder")
		return
	
	dir.list_dir_begin()
	var files = ResourceLoader.list_directory(path)
	
	for i in files.size():
		var affinity = load(path + files[i])
		
		ore_affinity[affinity.ore] = affinity.stats
	
	dir.list_dir_end()

# EFFECTS
func load_all_effects():
	var path = "res://_resources/effects/"

	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No data folder")
		return

	dir.list_dir_begin()

	var files = ResourceLoader.list_directory(path)

	for file in files:
		var effect = load(path + file)

		effects[effect.name] = effect

	dir.list_dir_end()


# ITEMS
func load_all_item_descriptions():
	item_descriptions.clear()
	
	var path = "res://_resources/items/descriptions/"
	var dir = DirAccess.open(path)
	if dir == null:
		return

	dir.list_dir_begin()

	var files = ResourceLoader.list_directory(path)
	
	for i in files.size():
		var res = load(path + files[i])
			
		item_descriptions[res.id] = res

	dir.list_dir_end()


func load_all_artefacts():
	artefacts.clear()
	
	var path = "res://_resources/items/artefacts/"
	var dir = DirAccess.open(path)
	if dir == null:
		return

	dir.list_dir_begin()

	var files = ResourceLoader.list_directory(path)
	var index = 0
	
	for i in files.size():
		var res = load(path + files[i])
			
		artefacts[index] = res
		GameManager.update_items(res.hash)
			
		index += 1

	dir.list_dir_end()


# SKILLS
func load_all_skills():
	var path = "res://_resources/skills/"
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No data folder")
		return
	
	dir.list_dir_begin()
	
	var files = ResourceLoader.list_directory(path)
	
	for i in files.size():
		var skill = load(path + files[i]) as Skill
		
		if skills.get(skill.id) != null:
			continue
		
		skills[skill.id] = {
			"name": skill.name,
			"description": skill.description,
			"primary_icon": skill.primary_icon,
			"secondary_icon": skill.secondary_icon,
			"stat": skill.stat,
			"bonus": skill.bonus,
			"max_level": skill.max_level,
			"cost": skill.cost
		}
		
		if not stats.has(skill.stat.id):
			stats[skill.stat.id] = {
				"name": skill.stat.name,
				"description": skill.stat.description,
				"primary_icon": skill.primary_icon,
				"secondary_icon": skill.secondary_icon,
				"rarity": skill.stat.rarity,
				"tags": skill.stat.tags,
				"mode": skill.stat.mode,
				"bonus_min": skill.stat.bonus_min,
				"bonus_max": skill.stat.bonus_max,
				"item_affinity": skill.stat.item_affinity,
				"ore_affinity": skill.stat.ore_affinity,
			}


# TASKS
func load_all_tasks():
	var path = "res://_resources/tasks/"
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("No data folder")
		return
	
	dir.list_dir_begin()
	
	var files = ResourceLoader.list_directory(path)
	
	for i in files.size():
		var task = load(path + files[i]) as Task
		
		if tasks.get(task.id) != null:
			continue
		
		tasks[task.id] = {
			"type": task.type,
			"description": task.description,
			"base_required_amount": task.base_required_amount,
			"required_exponent": task.required_exponent,
			"base_rewards": task.base_rewards,
			"reward_exponent": task.reward_exponent,
			"max_level": task.max_level,
			"icon": task.icon,
		}


# ORE
func load_ore_atlas() -> void:
	ore_icons = []
	
	var atlas = load("res://assets/atlas/ore_atlas_128.png")
	
	for x in range(8):
		var icon = AtlasTexture.new()
		icon.atlas = atlas
		icon.region = Rect2(x * 128, 0, 128, 128)
		
		ore_icons.append(icon)


func load_symbol_atlas() -> void:
	symbol_icons = []
	
	var atlas = load("res://assets/atlas/symbol_atlas_256.png")
	
	for y in range(6):
		for x in range(5):
			var icon = AtlasTexture.new()
			icon.atlas = atlas
			icon.region = Rect2(x * 256, y * 256, 256, 256)
			
			symbol_icons.append(icon)


func load_artefact_atlas() -> void:
	artefact_icons = []
	
	var atlas = load("res://assets/atlas/artefacts_atlas.png")
	
	for x in range(10):
		var icon = AtlasTexture.new()
		icon.atlas = atlas
		icon.region = Rect2(x * 128, 0, 128, 128)
		
		artefact_icons.append(icon)
