class_name PickaxeEffect
extends Node2D

signal hit

@onready var pickaxe_sprite: Sprite2D = $PickaxeSprite


func _ready() -> void:
	pickaxe_sprite.visible = false


func play() -> void:
	pickaxe_sprite.visible = true

	pickaxe_sprite.position = Vector2(0, -80)
	pickaxe_sprite.rotation = 0.0
	pickaxe_sprite.modulate.a = 1.0

	var tween := create_tween()

	# Coup de pioche
	tween.tween_property(
		pickaxe_sprite,
		"rotation",
		deg_to_rad(45.0),
		0.20
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Impact
	tween.tween_callback(func():
		hit.emit()
	)
	
	tween.tween_interval(0.20)

	# Cette instance disparaît uniquement quand SON animation est terminée
	tween.tween_callback(queue_free)
