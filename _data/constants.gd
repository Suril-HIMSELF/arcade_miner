class_name Constants extends Node


### APP ###
const HASH_VERSION: String = "v1"
const ITEM_SECRET: String = "6E9NBUI5V90NTKB"
const SAVE_VERSION: String = "v1"
const SAVE_PATH := "user://save.dat"
const CONFIG_PATH := "user://config.ini"
const SAVE_SECRET := "YUb6VIGPNgX8eYA49sol"



### ASSETS ###
const ICON_SIZE := Vector2i(150, 150)

### GAME ###
const HEAT_ENERGY_LOSS: int = 20

### ORE ###
const ORE_ATLAS := preload("res://assets/atlas/ore_atlas_128.png")

const ORE_NAME: Dictionary = {
	Enums.ORE.STONE: &"ORE_STONE",
	Enums.ORE.GOLD: &"ORE_GOLD",
	Enums.ORE.SAPPHIRE: &"ORE_SAPPHIRE",
	Enums.ORE.RUBY: &"ORE_RUBY",
	Enums.ORE.EMERALD: &"ORE_EMERALD",
	Enums.ORE.DIAMOND: &"ORE_DIAMOND",
	Enums.ORE.WOOD: &"ORE_WOOD",
	Enums.ORE.METAL: &"ORE_METAL"
}

const STAT_ORE_WEIGHT: Dictionary = {
	Enums.ORE.STONE: Enums.STAT.STONE_WEIGHT,
	Enums.ORE.GOLD: Enums.STAT.GOLD_WEIGHT,
	Enums.ORE.SAPPHIRE: Enums.STAT.SAPPHIRE_WEIGHT,
	Enums.ORE.RUBY: Enums.STAT.RUBY_WEIGHT,
	Enums.ORE.EMERALD: Enums.STAT.EMERALD_WEIGHT,
	Enums.ORE.DIAMOND: Enums.STAT.DIAMOND_WEIGHT,
}

const BASE_ORE_WEIGHT: Dictionary = {
	Enums.ORE.STONE: 0.5,
	Enums.ORE.GOLD: 0.3,
	Enums.ORE.SAPPHIRE: 0.1,
	Enums.ORE.RUBY: 0.06,
	Enums.ORE.EMERALD: 0.03,
	Enums.ORE.DIAMOND: 0.01
}

const BASE_ORE_VALUE: Dictionary = {
	Enums.ORE.STONE: 1.0,
	Enums.ORE.GOLD: 3.0,
	Enums.ORE.SAPPHIRE: 6.0,
	Enums.ORE.RUBY: 10.0,
	Enums.ORE.EMERALD: 30.0,
	Enums.ORE.DIAMOND: 60.0
}

const ORE_XP: Dictionary = {
	Enums.ORE.STONE: 1.0,
	Enums.ORE.GOLD: 2.0,
	Enums.ORE.SAPPHIRE: 3.0,
	Enums.ORE.RUBY: 4.0,
	Enums.ORE.EMERALD: 5.0,
	Enums.ORE.DIAMOND: 6.0,
}

### STAT ###
const STAT_ORE_XP = {
	Enums.ORE.STONE: Enums.STAT.STONE_XP,
	Enums.ORE.GOLD: Enums.STAT.GOLD_XP,
	Enums.ORE.SAPPHIRE: Enums.STAT.SAPPHIRE_XP,
	Enums.ORE.RUBY: Enums.STAT.RUBY_XP,
	Enums.ORE.EMERALD: Enums.STAT.EMERALD_XP,
	Enums.ORE.DIAMOND: Enums.STAT.DIAMOND_XP,
}

const STAT_ORE_QUANTITY = {
	Enums.ORE.STONE: Enums.STAT.STONE_QUANTITY,
	Enums.ORE.GOLD: Enums.STAT.GOLD_QUANTITY,
	Enums.ORE.SAPPHIRE: Enums.STAT.SAPPHIRE_QUANTITY,
	Enums.ORE.RUBY: Enums.STAT.RUBY_QUANTITY,
	Enums.ORE.EMERALD: Enums.STAT.EMERALD_QUANTITY,
	Enums.ORE.DIAMOND: Enums.STAT.DIAMOND_QUANTITY,
}

const STAT_AFFINITY_ROLL = 0.6

### SHAPE ###
const SHAPE_NAME: Dictionary = {
	Enums.SHAPE.UP: "Up",
	Enums.SHAPE.RIGHT: "Right",
	Enums.SHAPE.DOWN: "Down",
	Enums.SHAPE.LEFT: "Left",
	Enums.SHAPE.TAP: "Tap"
}

const SHAPE_WEIGHT: Dictionary = {
	Enums.SHAPE.UP: 0.2,
	Enums.SHAPE.RIGHT: 0.2,
	Enums.SHAPE.DOWN: 0.2,
	Enums.SHAPE.LEFT: 0.2,
	Enums.SHAPE.TAP: 0.2,
}

### SKILL ###
const SKILL_GROWTH: float = 1.6

### ITEM ###
const PICKAXE_ATLAS := preload("res://assets/atlas/pickaxe_atlas_128.png")
const HELMET_ATLAS := preload("res://assets/atlas/helmet_atlas_128.png")
const LANTERN_ATLAS := preload("res://assets/atlas/lantern_atlas_128.png")
const JEWEL_ATLAS := preload("res://assets/atlas/jewel_atlas_128.png")
const ITEM_FORGE_ATLAS := preload("res://assets/atlas/forge_item_atlas.png")

const ITEM_NAME: Dictionary = {
	Enums.ITEM_TYPE.PICKAXE: &"ITEM_PICKAXE",
	Enums.ITEM_TYPE.HELMET: &"ITEM_HELMET",
	Enums.ITEM_TYPE.LANTERN: &"ITEM_LANTERN",
	Enums.ITEM_TYPE.JEWEL: &"ITEM_JEWEL",
	Enums.ITEM_TYPE.ARTEFACT: &"ITEM_ARTEFACT",
}

const ARTEFACT_CHANCE: float = 0.06 # 0.06 -> Entre 20 et 30 runs pour 1 drop

### RARITY ###
const RARITY_NAME: Dictionary = {
	Enums.RARITY.BASIC: &"RARITY_BASIC",
	Enums.RARITY.UNCOMMON: &"RARITY_UNCOMMON",
	Enums.RARITY.RARE: &"RARITY_RARE",
	Enums.RARITY.EPIC: &"RARITY_EPIC",
	Enums.RARITY.LEGENDARY: &"RARITY_LEGENDARY",
}

const RARITY_WEIGHT: Dictionary = {
	Enums.RARITY.BASIC: 0.5,
	Enums.RARITY.UNCOMMON: 0.3,
	Enums.RARITY.RARE: 0.15,
	Enums.RARITY.EPIC: 0.05,
}

const RARITY_COLOR: Dictionary = {
	Enums.RARITY.BASIC: Color.WHITE,
	Enums.RARITY.UNCOMMON: Color.GREEN,
	Enums.RARITY.RARE: Color.BLUE,
	Enums.RARITY.EPIC: Color.PURPLE,
	Enums.RARITY.LEGENDARY: Color.GOLD
}

### MARKET ###
const PRICE_FACTOR: int = 12
const QUANTITY_FACTOR = 1.2

const MARKET_MAX: Dictionary = { # Quantité max possible d'une ressource au marché hors effet wow
	Enums.ORE.STONE: 0,
	Enums.ORE.GOLD: 0,
	Enums.ORE.SAPPHIRE: 500,
	Enums.ORE.RUBY: 300,
	Enums.ORE.EMERALD: 150,
	Enums.ORE.DIAMOND: 50,
	Enums.ORE.WOOD: 750,
	Enums.ORE.METAL: 500,
}

### REWARDS ###

const ORE_REWARD_ORE = {
	Enums.ORE_REWARD.STONE:Enums.ORE.STONE,
	Enums.ORE_REWARD.GOLD: Enums.ORE.GOLD,
	Enums.ORE_REWARD.SAPPHIRE: Enums.ORE.SAPPHIRE,
	Enums.ORE_REWARD.RUBY: Enums.ORE.RUBY,
	Enums.ORE_REWARD.EMERALD: Enums.ORE.EMERALD,
	Enums.ORE_REWARD.DIAMOND: Enums.ORE.DIAMOND,
	Enums.ORE_REWARD.WOOD: Enums.ORE.WOOD,
	Enums.ORE_REWARD.METAL: Enums.ORE.METAL,
}

const ORE_REWARD_WEIGHT = {
	Enums.ORE_REWARD.STONE: 0.0,
	Enums.ORE_REWARD.GOLD: 0.2,
	Enums.ORE_REWARD.SAPPHIRE: 0.4,
	Enums.ORE_REWARD.RUBY: 0.5,
	Enums.ORE_REWARD.EMERALD: 0.5,
	Enums.ORE_REWARD.DIAMOND: 0.3,
	Enums.ORE_REWARD.WOOD: 0.5,
	Enums.ORE_REWARD.METAL: 0.5,
	Enums.ORE_REWARD.ARTEFACT: 0.01,
}

const ORE_REWARD_MULT = {
	Enums.ORE_REWARD.STONE : 20,
	Enums.ORE_REWARD.GOLD: 10,
	Enums.ORE_REWARD.SAPPHIRE: 8,
	Enums.ORE_REWARD.RUBY: 6,
	Enums.ORE_REWARD.EMERALD: 5,
	Enums.ORE_REWARD.DIAMOND: 2,
	Enums.ORE_REWARD.WOOD: 5,
	Enums.ORE_REWARD.METAL: 5,
	Enums.ORE_REWARD.ARTEFACT: 1,
}
