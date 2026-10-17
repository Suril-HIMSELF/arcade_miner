@tool

extends Node

signal item_crafted

func build_hash(item: Item) -> String:
	var parts: Array[String] = []
	
	parts.append("v1")
	parts.append(str(item.type))
	parts.append(str(item.rarity))
	parts.append(str(item.description.id))

	for stat in item.stats:
		parts.append("%s,%s,%s" % [stat.stat, stat.value, stat.mode])

	var payload = ";".join(parts)
	var signature = (payload + Constants.ITEM_SECRET).sha256_text()
	var final_data = "%s|%s" % [payload, signature]

	return Marshalls.raw_to_base64(final_data.to_utf8_buffer())


static func validate_hash(_hash: String) -> bool:
	if _hash.is_empty():
		return false

	var decoded = Marshalls.base64_to_raw(_hash).get_string_from_utf8()

	var split = decoded.split("|")

	if split.size() != 2:
		return false

	var payload = split[0]
	var signature = split[1]
	var expected = (payload + Constants.ITEM_SECRET).sha256_text()

	return expected == signature


func item_from_hash(_hash: String) -> Item:
	if !validate_hash(_hash):
		return null

	var decoded = Marshalls.base64_to_raw(_hash).get_string_from_utf8()
	var split = decoded.split("|")
	var payload = split[0]
	var parts = payload.split(";")

	if parts.size() < 4:
		return null

	var item := Item.new()

	item.hash = _hash

	var version = parts[0]
	item.type = int(parts[1])
	item.rarity = int(parts[2])
	item.description = Database.item_descriptions[int(parts[3])]
	
	if item.type == Enums.ITEM_TYPE.ARTEFACT:
		item.icon = Database.artefact_icons[int(parts[3])]
	else:
		item.icon = Utils.get_item_icon(item.type, item.description.id, item.rarity)
	
	item.stats = []

	for i in range(4, parts.size()):
		var stat_parts = parts[i].split(",")

		if stat_parts.size() != 3:
			
			continue

		var stat := StatValue.new()

		stat.stat = stat_parts[0]
		stat.value = float(stat_parts[1])
		stat.mode = stat_parts[2]
		
		item.stats.append(stat)

	return item


static func get_total_rarity_weight() -> int:
	var total = 0
	
	total += Constants.RARITY_WEIGHT[Enums.RARITY.BASIC]
	total += Constants.RARITY_WEIGHT[Enums.RARITY.UNCOMMON]
	total += Constants.RARITY_WEIGHT[Enums.RARITY.RARE]
	total += Constants.RARITY_WEIGHT[Enums.RARITY.EPIC]
	
	return total


func roll_item_rarity() -> int:
	var total = get_total_rarity_weight()
	var rdm = randf() * total
	var cumulative = 0
	
	for rarity in Constants.RARITY_WEIGHT:
		cumulative += Constants.RARITY_WEIGHT[rarity]
		
		if rdm <= cumulative:
			return rarity
	
	return 0


func roll_item_stat() -> StatValue:
	var stat = StatValue.new()
	var rdm_stat = randi() % Database.stat_definition.size()
	var stat_rolled = Database.stat_definitions[rdm_stat]
	var stat_value = randf_range(stat_rolled.bonus_min, stat_rolled.bonus_max)
	
	stat.stat = stat_rolled
	stat.value = snapped(stat_value, 0.01)
	stat.mode = stat_rolled.mode
	
	return stat


func roll_ore_affinity_stat(ore: Enums.ORE) -> StatValue:
	var affinity = Utils.get_stats_for_ore(ore)
	var rdm_stat = randi() % affinity.size()
	var stat_rolled = affinity[rdm_stat]
	var stat_definition = Database.stat_definitions[stat_rolled]
	
	var stat_value = randf_range(stat_definition.bonus_min, stat_definition.bonus_max)
	
	if stat_definition.mode == Enums.STAT_MODE.FLAT:
		stat_value = int(stat_value)
	
	
	var stat = StatValue.new()
	
	stat.stat = stat_rolled
	stat.value = snapped(stat_value, 0.01)
	stat.mode = stat_definition.mode
	
	return stat


func roll_item_affinity_stat(item_type: Enums.ITEM_TYPE) -> StatValue:
	var affinity = Utils.get_stats_for_item_type(item_type)
	var rdm_stat = randi() % affinity.size()
	var stat_rolled = affinity[rdm_stat]
	var stat_definition = Database.stat_definitions[stat_rolled]
	var stat_value = randf_range(stat_definition.bonus_min, stat_definition.bonus_max)
	
	var stat = StatValue.new()
	
	stat.stat = stat_rolled
	stat.value = snapped(stat_value, 0.01)
	stat.mode = stat_definition.mode
	
	return stat


func roll_item_description(item_type: Enums.ITEM_TYPE, item_rarity: Enums.RARITY) -> ItemDescription:
	var filtered_description = Database.item_descriptions.keys().filter(func(id): 
		return Database.item_descriptions[id].type == item_type and Database.item_descriptions[id].rarity == item_rarity
	)
	var rdm = filtered_description.pick_random()
	
	return Database.item_descriptions[rdm]
