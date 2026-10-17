class_name Utils extends Node


func loc(key: StringName) -> String:
	return tr(key)


static func get_stats_for_item_type(item_type: Enums.ITEM_TYPE) -> Array:
	var result: Array = []

	for stat in Database.stat_definitions:
		var stat_definition = Database.stat_definitions[stat]
		
		if item_type in stat_definition.item_affinity:
			result.append(stat)

	return result


static func get_stats_for_ore(ore: Enums.ORE) -> Array:
	var result: Array = []

	for stat in Database.stat_definitions:
		var stat_definition = Database.stat_definitions[stat]
		
		if ore in stat_definition.ore_affinity:
			result.append(stat)

	return result


static func get_stat_cap(stat: Enums.STAT) -> float:
	return Database.stat_definitions[stat].cap


static func get_stat_name(stat: Enums.STAT) -> String:
	return Database.stat_definitions[stat].name


static func get_stat_description(stat: Enums.STAT) -> String:
	return Database.stat_definitions[stat].description


static func get_shape_name(shape: Enums.SHAPE) -> String:
	return Constants.SHAPE_NAME[shape]


static func get_ore_name(ore: Enums.ORE) -> String:
	return Constants.ORE_NAME[ore]


static func get_item_icon(item_type: Enums.ITEM_TYPE, item_id: int, item_rarity: Enums.RARITY) -> Texture2D:
	var texture := AtlasTexture.new()
	var item_variant = item_id % 10
	
	match item_type:
		Enums.ITEM_TYPE.PICKAXE: texture.atlas = Constants.PICKAXE_ATLAS
		Enums.ITEM_TYPE.HELMET: texture.atlas = Constants.HELMET_ATLAS
		Enums.ITEM_TYPE.LANTERN: texture.atlas = Constants.LANTERN_ATLAS
		Enums.ITEM_TYPE.JEWEL: texture.atlas = Constants.JEWEL_ATLAS
	
	texture.region = Rect2(
		item_variant * 128,
		item_rarity * 128,
		128,
		128
	)
	
	return texture



static func get_forge_item_icon(item_type: Enums.ITEM_TYPE) -> Texture2D:
	var texture := AtlasTexture.new()

	texture.atlas = Constants.ITEM_FORGE_ATLAS

	texture.region = Rect2(
		item_type * 128,
		0,
		128,
		128
	)
	
	return texture


static func get_ore_icon(ore: Enums.ORE) -> Texture2D:
	return Database.ore_icons[ore]


static func get_ore_stat_quantity(ore: Enums.ORE) -> float:
	match ore:
		Enums.ORE.STONE: return GameManager.stats[Enums.STAT.STONE_QUANTITY]
		Enums.ORE.GOLD: return GameManager.stats[Enums.STAT.GOLD_QUANTITY]
		Enums.ORE.SAPPHIRE : return GameManager.stats[Enums.STAT.SAPPHIRE_QUANTITY]
		Enums.ORE.RUBY : return GameManager.stats[Enums.STAT.RUBY_QUANTITY]
		Enums.ORE.EMERALD : return GameManager.stats[Enums.STAT.EMERALD_QUANTITY]
		Enums.ORE.DIAMOND : return GameManager.stats[Enums.STAT.DIAMOND_QUANTITY]
		_ : return 0


static func get_symbol_icon(ore: Enums.ORE, shape: Enums.SHAPE) -> Texture2D:
	return Database.symbol_icons[(ore * 5) + shape]


static func get_ore_color(ore: Enums.ORE) -> Color:
	match ore:
		Enums.ORE.STONE:
			return Color(1.0, 1.0, 1.0, 1.0)
		Enums.ORE.GOLD:
			return Color(1.0, 0.773, 0.0, 1.0)
		Enums.ORE.SAPPHIRE:
			return Color(0.0, 0.0, 1.0, 1.0)
		Enums.ORE.RUBY:
			return Color(1.0, 0.0, 0.0, 1.0)
		Enums.ORE.EMERALD:
			return Color(0.0, 1.0, 0.0, 1.0)
		Enums.ORE.DIAMOND:
			return Color(0.0, 0.773, 0.729, 1.0)
		_:
			return Color(1.0, 1.0, 1.0, 1.0)


static func get_text_color(ore: Enums.ORE) -> Color:
	match ore:
		Enums.ORE.STONE:
			return Color(0.478, 0.49, 0.663, 1.0)
		Enums.ORE.GOLD:
			return Color(0.992, 0.863, 0.745, 1.0)
		Enums.ORE.SAPPHIRE:
			return Color(1.0, 1.0, 1.0, 1.0)
		Enums.ORE.RUBY:
			return Color(1.0, 1.0, 1.0, 1.0)
		Enums.ORE.EMERALD:
			return Color(0.784, 0.957, 0.949, 1.0)
		Enums.ORE.DIAMOND:
			return Color(0.702, 0.949, 0.941, 1.0)
		_:
			return Color(1.0, 1.0, 1.0, 1.0)


static func get_rarity_color(rarity: Enums.RARITY) -> Color:
	match rarity:
		Enums.RARITY.BASIC:
			return Color(1.0, 1.0, 1.0, 1.0)
		Enums.RARITY.UNCOMMON:
			return Color(0.0, 1.0, 0.0, 1.0)
		Enums.RARITY.RARE:
			return Color(0.0, 0.0, 1.0, 1.0)
		Enums.RARITY.EPIC:
			return Color(0.696, 0.0, 0.696, 1.0)
		Enums.RARITY.LEGENDARY:
			return Color(1.0, 0.0, 0.0, 1.0)
		_:
			return Color(1.0, 1.0, 1.0, 1.0)


static func display_stat_value(value: float, mode: Enums.STAT_MODE) -> String:
	var stat_value = 0
	var stat_sign = ""
	var stat_str = ""
	var stat_final = ""
	
	if step_decimals(value) == 0:
		stat_value = int(abs(value))
	else:
		stat_value = abs(value)
	
	if value > 0:
		stat_sign = "+"
	elif value < 0:
		stat_sign = "-"
	
	stat_str = str(stat_value)
	
	if mode == Enums.STAT_MODE.PERCENT:
		stat_str = str(int(stat_value * 100)) + "%"
	
	stat_final = stat_sign + stat_str
	
	return stat_final


static func format_number(value: int) -> String:
	if value < 1_000:
		return str(value)

	var suffix := ""
	var divisor := 1.0

	if value >= 1_000_000:
		suffix = "M"
		divisor = 1_000_000.0
	else:
		suffix = "K"
		divisor = 1_000.0

	var result := "%.1f %s" % [value / divisor, suffix]

	if result.ends_with(".0 " + suffix):
		result = result.replace(".0 " + suffix, " " + suffix)

	var separator := TranslationServer.translate("UI_NUMBER_SEPARATOR")
	result = result.replace(".", separator)

	return result


static func get_level_icon(level: int) -> Texture2D:
	var level_atlas = AtlasTexture.new()
	level_atlas.atlas = load("res://assets/atlas/level_atlas.png")
	
	var icon_level = int(level / 10)
	
	level_atlas.region = Rect2(128 * icon_level, 0, 128, 128)
	
	return level_atlas


static func stat_unit(stat: Enums.STAT) -> String:
	match stat:
		Enums.STAT.TIMER_DURATION, Enums.STAT.TIMER_PENALTY: return "s"
	
	return ""
