class_name FloatingText extends Label


@export var move_distance: float
@export var duration: float = 1.0

var tween: Tween
var base_position: Vector2

func _ready() -> void:
	visible = false
	position = base_position


func show_text(value: String, dir: int) -> void:
	if tween:
		tween.kill()
	
	position = base_position
	
	match dir:
		1: move_distance = 60
		0: move_distance = 0
		-1: move_distance = -60
		_: move_distance = 0
	
	text = value
	visible = true
	modulate.a = 1.0

	tween = create_tween()
	tween.parallel().tween_property(self, "position:y", base_position.y + move_distance, duration)
	tween.parallel().tween_property(self, "modulate:a", 0.0, duration)

	await tween.finished

	position = base_position
	visible = false
