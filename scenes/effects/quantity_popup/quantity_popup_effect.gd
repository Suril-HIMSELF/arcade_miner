class_name QuantityPopupEffect
extends Node2D

@onready var quantity_label: Label = $QuantityLabel


func _ready() -> void:
	quantity_label.visible = false


func play(quantity: int, ore: Enums.ORE) -> void:
	var color = Utils.get_ore_color(ore)
	
	quantity_label.visible = true
	quantity_label.text = "+%d" % quantity
	quantity_label.modulate = color
	quantity_label.modulate.a = 1.0

	quantity_label.position = Vector2.ZERO
	quantity_label.scale = Vector2(0.8, 0.8)

	var tween := create_tween()

	# Apparition rapide
	tween.tween_property(
		quantity_label,
		"scale",
		Vector2.ONE,
		0.10
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Flottement vers le haut
	tween.parallel().tween_property(
		quantity_label,
		"position",
		Vector2(0, -45),
		0.45
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Disparition progressive
	tween.parallel().tween_property(
		quantity_label,
		"modulate:a",
		0.0,
		0.45
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	tween.tween_callback(queue_free)
