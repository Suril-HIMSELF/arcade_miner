class_name RelicEffect
extends Node2D

@onready var relic_sprite: Sprite2D = $RelicSprite


func _ready() -> void:
	relic_sprite.visible = false


func play() -> void:
	relic_sprite.visible = true

	relic_sprite.position = Vector2(0, -70)
	relic_sprite.scale = Vector2(0.75, 0.75)
	relic_sprite.rotation = 0.0
	relic_sprite.modulate.a = 1.0

	var tween := create_tween()

	# Apparition et léger grossissement
	tween.tween_property(
		relic_sprite,
		"scale",
		Vector2(1.0, 1.0),
		0.20
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Reste visible brièvement
	tween.tween_interval(0.20)

	# Disparition
	tween.tween_property(
		relic_sprite,
		"modulate:a",
		0.0,
		0.20
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	tween.tween_callback(queue_free)
