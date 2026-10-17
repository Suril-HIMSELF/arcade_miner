class_name BombEffect
extends Node2D

signal exploded

@onready var bomb_sprite: Sprite2D = $BombSprite
@onready var explosion_1: Sprite2D = $Explosion1Sprite
@onready var explosion_2: Sprite2D = $Explosion2Sprite


func _ready() -> void:
	bomb_sprite.visible = false
	explosion_1.visible = false
	explosion_2.visible = false


func play() -> void:
	bomb_sprite.visible = true
	explosion_1.visible = false
	explosion_2.visible = false

	bomb_sprite.position = Vector2.ZERO
	bomb_sprite.scale = Vector2(0.7, 0.7)
	bomb_sprite.modulate.a = 1.0

	var tween := create_tween()

	# Apparition rapide de la bombe
	tween.tween_property(
		bomb_sprite,
		"scale",
		Vector2(1.2, 1.2),
		0.30
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Petite attente
	tween.tween_interval(0.08)

	# Explosion
	tween.tween_callback(func():
		bomb_sprite.visible = false

		explosion_1.visible = true
		explosion_1.scale = Vector2(0.75, 0.75)
		explosion_1.modulate.a = 1.0

		explosion_2.visible = true
		explosion_2.scale = Vector2(0.55, 0.55)
		explosion_2.modulate.a = 0.0

		exploded.emit()
	)

	# Explosion 1
	tween.parallel().tween_property(
		explosion_1,
		"scale",
		Vector2(1.05, 1.05),
		0.18
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		explosion_1,
		"modulate:a",
		0.0,
		0.18
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Explosion 2
	tween.parallel().tween_property(
		explosion_2,
		"modulate:a",
		1.0,
		0.12
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		explosion_2,
		"scale",
		Vector2(1.0, 1.0),
		0.22
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_interval(0.10)

	# Disparition finale
	tween.parallel().tween_property(
		explosion_2,
		"scale",
		Vector2(1.15, 1.15),
		0.12
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		explosion_2,
		"modulate:a",
		0.0,
		0.12
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Détruire uniquement cette instance
	tween.tween_callback(queue_free)
