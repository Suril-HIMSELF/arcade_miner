class_name Item extends Resource

@export var hash: String
@export var description: ItemDescription
@export var icon: Texture2D
@export var type: Enums.ITEM_TYPE
@export var rarity: Enums.RARITY
@export var stats: Array[StatValue]

var initialized := false

func finalize():
	hash = ItemFactory.build_hash(self)

	initialized = true


func get_formatted_text() -> String:
	var lines: Array[String] = []
	
	for stat_value in stats:
		var stat_name = Utils.get_stat_name(stat_value.stat)
		var value_text = ""
		
		if stat_value.mode == Enums.STAT_MODE.FLAT:
			value_text = str(stat_value.value)
		else:
			value_text = "%s%%" % stat_value.value
		
		lines.append("+%s %s" % [value_text, stat_name])
	
	return "\n".join(lines)
