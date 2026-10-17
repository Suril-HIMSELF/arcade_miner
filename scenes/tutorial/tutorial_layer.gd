extends CanvasLayer

signal tutorial_finished

@onready var tutorial_root: Control = $TutorialRoot
@onready var bubble_root: Control = $TutorialRoot/TutorialBubbleRoot
@onready var tutorial_bubble: PanelContainer = $TutorialRoot/TutorialBubbleRoot/TutorialBubble
@onready var arrow: TextureRect = $TutorialRoot/TutorialBubbleRoot/Arrow

var tutorial_steps: Array = []
var current_step_index := -1

var current_target: Control
var tutorial_active := false


func _ready() -> void:
	arrow.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)


func start_tutorial(steps: Array) -> void:
	if steps.is_empty():
		return

	tutorial_steps = steps
	current_step_index = 0
	tutorial_active = true

	show_current_step()


func show_current_step() -> void:
	if current_step_index < 0 or current_step_index >= tutorial_steps.size():
		close_tutorial()
		return

	var step: Dictionary = tutorial_steps[current_step_index]

	var target: Control = step.get("target", null)
	var text: String = step["text"]

	start_step(target, text)


func next_step() -> void:
	current_step_index += 1

	if current_step_index >= tutorial_steps.size():
		close_tutorial()
		tutorial_finished.emit()
	else:
		show_current_step()


func start_step(target: Control, text: String) -> void:
	current_target = target
	tutorial_active = true

	show_for_target(target, text)


func show_for_target(target: Control, text: String) -> void:
	var label: Label = tutorial_bubble.get_node("MarginContainer/Label")

	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = text

	tutorial_bubble.custom_minimum_size = Vector2(700, 0)

	tutorial_bubble.show()

	await get_tree().process_frame
	await get_tree().process_frame

	tutorial_bubble.size.x = 700

	var minimum_size := tutorial_bubble.get_combined_minimum_size()
	tutorial_bubble.size.y = minimum_size.y

	var screen_size := get_viewport().get_visible_rect().size
	var bubble_size := tutorial_bubble.size

	# --------------------------------------------------
	# Mode autonome : aucune cible
	# --------------------------------------------------
	if target == null:
		arrow.hide()

		var centered_x := (screen_size.x - bubble_size.x) / 2.0
		var centered_y := (screen_size.y - bubble_size.y) / 2.0

		bubble_root.position = Vector2(
			centered_x,
			centered_y
		)

		return

	# --------------------------------------------------
	# Mode attaché : positionnement par rapport à la cible
	# --------------------------------------------------

	arrow.show()

	var target_rect := target.get_global_rect()

	var margin := 16.0
	var arrow_gap := 8.0
	var arrow_size := arrow.size

	var target_center_x := target_rect.position.x + target_rect.size.x / 2.0

	var x := target_center_x - bubble_size.x / 2.0

	# --------------------------------------------------
	# Position initiale :
	# Bubble au-dessus de la cible
	# --------------------------------------------------

	var y := target_rect.position.y \
		- bubble_size.y \
		- arrow_size.y \
		- arrow_gap * 2.0 \
		- margin

	var arrow_points_down := true

	# --------------------------------------------------
	# Pas assez de place au-dessus :
	# Bubble sous la cible
	# --------------------------------------------------

	if y < 0.0:
		y = target_rect.end.y \
			+ arrow_size.y \
			+ arrow_gap * 2.0 \
			+ margin

		arrow_points_down = false

	# --------------------------------------------------
	# Maintenir la bubble dans les limites de l'écran
	# --------------------------------------------------

	x = clampf(
		x,
		margin,
		screen_size.x - bubble_size.x - margin
	)

	bubble_root.position = Vector2(x, y)

	# --------------------------------------------------
	# Positionnement horizontal de la flèche
	# --------------------------------------------------

	var target_center_local_x := target_center_x - bubble_root.global_position.x

	var arrow_x := target_center_local_x - arrow_size.x / 2.0

	arrow_x = clampf(
		arrow_x,
		4.0,
		tutorial_bubble.size.x - arrow_size.x - 4.0
	)

	# --------------------------------------------------
	# Positionnement vertical de la flèche
	# --------------------------------------------------

	if arrow_points_down:
		# --------------------------------------------------
		# Bubble AU-DESSUS de la cible
		#
		#       TARGET
		#          ↓
		#        ARROW
		#          ↓
		#        BUBBLE
		# --------------------------------------------------

		arrow.flip_v = false

		arrow.position = Vector2(
			arrow_x,
			tutorial_bubble.size.y + arrow_gap
		)

	else:
		# --------------------------------------------------
		# Bubble SOUS la cible
		#
		#        BUBBLE
		#           ↓
		#         ARROW
		#           ↓
		#         TARGET
		# --------------------------------------------------

		arrow.flip_v = true

		arrow.position = Vector2(
			arrow_x,
			-arrow_size.y - arrow_gap
		)


func close_tutorial() -> void:
	tutorial_active = false
	current_target = null

	tutorial_bubble.hide()
	arrow.hide()

	tutorial_steps.clear()
	current_step_index = -1


func _input(event: InputEvent) -> void:
	if not tutorial_active:
		return

	# --------------------------------------------------
	# Touchscreen
	# --------------------------------------------------

	if event is InputEventScreenTouch:
		if event.pressed:
			next_step()

	# --------------------------------------------------
	# Souris
	# --------------------------------------------------

	elif event is InputEventMouseButton:
		# Sur un appareil tactile, Godot génère également
		# un MouseButton pour le même appui.
		# On utilise donc uniquement ScreenTouch.
		if DisplayServer.is_touchscreen_available():
			return

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			next_step()
