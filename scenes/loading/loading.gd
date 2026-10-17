extends Control

@onready var fade = $Fade
@onready var warmup: TextureRect = $Warmup

func _ready() -> void:
	fade.modulate.a = 1.0
	await fade_to_transparent()
	await RenderingServer.frame_post_draw
	
	await get_tree().create_timer(3.0).timeout
	
	SaveManager.initialize()
	Database.initialize()
	GameManager.initialize()
	InventoryManager.initialize()
	
	await warmup_texture(Database.ore_icons)
	await warmup_texture(Database.symbol_icons)
	await warmup_texture(Database.artefact_icons)
	
	await fade_to_black()
	await RenderingServer.frame_post_draw
	
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func fade_to_transparent():
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 1.0)
	return tween.finished


func fade_to_black():
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.0)
	return tween.finished


func warmup_texture(textures: Array):
	warmup.modulate.a = 0.0

	for tex in textures:
		warmup.texture = tex
		
		await RenderingServer.frame_post_draw
