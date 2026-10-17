class_name OrePopEffect
extends Node2D

@onready var ore_sprite: Sprite2D = $OreSprite


func _ready() -> void:
	ore_sprite.visible = false


func play(ore: Enums.ORE) -> void:
	var ore_texture = Utils.get_ore_icon(ore)
	
	ore_sprite.texture = ore_texture
	ore_sprite.visible = true

	ore_sprite.position = Vector2.ZERO
	ore_sprite.rotation = 0.0
	ore_sprite.scale = Vector2(0.5, 0.5)
	ore_sprite.modulate.a = 1.0

	var tween := create_tween()

	# Projection en diagonale vers le haut-droite
	tween.tween_property(
		ore_sprite,
		"position",
		Vector2(120, -100),
		0.35
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Rotation
	tween.parallel().tween_property(
		ore_sprite,
		"rotation",
		deg_to_rad(30.0),
		0.35
	)

	# Grossissement
	tween.parallel().tween_property(
		ore_sprite,
		"scale",
		Vector2(0.85, 0.85),
		0.20
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Disparition
	tween.parallel().tween_property(
		ore_sprite,
		"modulate:a",
		0.0,
		0.50
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Cette instance est détruite uniquement quand SON animation est terminée
	tween.tween_callback(queue_free)
