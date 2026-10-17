extends Node


func initialize() -> void:
	if save_exists():
		var save_data = load_game()
		load_save_data(save_data)


func save_game(game_state: Dictionary) -> bool:
	var payload := {
		"version": Constants.SAVE_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"data": game_state
	}

	# JSON signé
	var payload_json := JSON.stringify(payload)

	var save_wrapper := {
		"payload_json": payload_json,
		"signature": _compute_signature(payload_json)
	}

	var encrypted_json := JSON.stringify(save_wrapper)

	var file := FileAccess.open_encrypted_with_pass(
		Constants.SAVE_PATH,
		FileAccess.WRITE,
		Constants.SAVE_SECRET
	)

	if file == null:
		push_error("Failed to create save file")
		return false

	file.store_string(encrypted_json)
	file.close()

	return true


func load_game() -> Dictionary:
	if not FileAccess.file_exists(Constants.SAVE_PATH):
		return {}

	var file := FileAccess.open_encrypted_with_pass(Constants.SAVE_PATH, FileAccess.READ, Constants.SAVE_SECRET)

	if file == null:
		push_error("Failed to open save file")
		return {}

	var encrypted_json := file.get_as_text()
	file.close()

	var wrapper_result = JSON.parse_string(encrypted_json)

	if typeof(wrapper_result) != TYPE_DICTIONARY:
		push_error("Invalid save format")
		return {}

	var payload_json: String = wrapper_result.get("payload_json", "")
	var stored_signature: String = wrapper_result.get("signature", "")

	if payload_json.is_empty():
		push_error("Missing payload")
		return {}

	var expected_signature := _compute_signature(payload_json)

	if stored_signature != expected_signature:
		push_error("Save tampering detected")
		return {}

	var payload = JSON.parse_string(payload_json)

	if typeof(payload) != TYPE_DICTIONARY:
		push_error("Invalid payload")
		return {}

	var version = payload.get("version", 0)

	if version != Constants.SAVE_VERSION:
		payload = _migrate_save(payload)

	return payload.get("data", {})


func save_exists() -> bool:
	return FileAccess.file_exists(Constants.SAVE_PATH)


func delete_save() -> void:
	if FileAccess.file_exists(Constants.SAVE_PATH):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path(Constants.SAVE_PATH)
		)


func _compute_signature(data: String) -> String:
	return (
		data + Constants.SAVE_SECRET
	).sha256_text()


func _migrate_save(payload: Dictionary) -> Dictionary:
	var version = payload.get("version", 0)

	match version:
		Constants.SAVE_VERSION:
			return payload

		_:
			push_warning("Unknown save version: %s" % version)
			return payload


func get_save_data() -> Dictionary:
	return {
		"stats": GameManager.stats,
		"ore_inventory": GameManager.ore_inventory,
		"equipment_items": GameManager.equipment_items,
		"inventory_items": GameManager.inventory_items,
		"equipped_artefact": GameManager.equipped_artefact,
		"artefact_states": GameManager.artefact_states,
		"skill_states": GameManager.skill_states,
		"market_state": GameManager.market_state,
		"market_reload_count": GameManager.market_reload_count,
		"run_completed": GameManager.run_completed,
		"level": GameManager.level,
		"ore_level": GameManager.ore_level,
		"ore_hp": GameManager.ore_hp,
		"task_states": GameManager.task_states,
		"master_volume": GameManager.master_volume,
		"music_volume": GameManager.music_volume,
		"sfx_volume": GameManager.sfx_volume,
		"audio_muted": GameManager.audio_muted,
		"language": GameManager.language,
		"tuto_completed_main": GameManager.tuto_completed_main,
		"tuto_completed_game": GameManager.tuto_completed_game,
	}


func load_save_data(data: Dictionary) -> void:
	GameManager.stats = _restore_int_keys(data.get("stats", {}))
	GameManager.ore_inventory = _restore_int_keys(data.get("ore_inventory", {}))
	GameManager.equipment_items = data.get("equipment_items", [])
	GameManager.inventory_items = data.get("inventory_items", [])
	GameManager.equipped_artefact = data.get("equipped_artefact", "")
	GameManager.artefact_states =  _restore_int_keys(data.get("artefact_states", {}))
	GameManager.skill_states = _restore_int_keys(data.get("skill_states", {}))
	GameManager.market_state = data.get("market_state", [])
	GameManager.market_reload_count = data.get("market_reload_count", 0)
	GameManager.run_completed = data.get("run_completed", 0)
	GameManager.level = data.get("level", 0)
	GameManager.ore_level = data.get("ore_level", 1)
	GameManager.ore_hp = data.get("ore_hp", 25)
	GameManager.task_states =  _restore_int_keys(data.get("task_states", {}))
	GameManager.master_volume = data.get("master_volume", 100)
	GameManager.music_volume = data.get("music_volume", 100)
	GameManager.sfx_volume = data.get("sfx_volume", 100)
	GameManager.audio_muted = data.get("audio_muted", false)
	GameManager.language = data.get("language", "en")
	GameManager.tuto_completed_main = data.get("tuto_completed_main", false)
	GameManager.tuto_completed_game = data.get("tuto_completed_game", false)


func _restore_int_keys(dict: Dictionary) -> Dictionary:
	var result := {}

	for key in dict:
		result[int(key)] = dict[key]

	return result
