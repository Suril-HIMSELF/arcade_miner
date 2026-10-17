extends Node

signal tap(position)
signal swipe(direction, velocity)
signal hold(position, duration)
signal release(position)
signal drag_start(position)
signal drag(position)

enum SwipeDirection {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

const TAP_THRESHOLD := 20.0
const HOLD_TIME := 0.25
const DRAG_START_DISTANCE := 35.0
const SWIPE_MIN_DISTANCE := 50.0

var pressed := false
var hold_emitted := false
var press_position := Vector2.ZERO


func _input(event):
	var debug = true
	
	# TOUCH
	if event is InputEventScreenTouch:
		_handle_touch(event.index, event.position, event.pressed)

	elif event is InputEventScreenDrag:
		_handle_drag(event.position)

	# MOUSE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not debug:
		_handle_touch(0, event.position, event.pressed)
	
	elif event is InputEventKey and debug:
		_handle_key(event)


func _handle_drag(position: Vector2):
	if !pressed:
		return

	emit_signal("drag", position)


func _handle_key(event: InputEvent):
	if event.is_action_pressed("ui_up"):
		emit_signal("swipe",0 ,-1)
	
	if event.is_action_pressed("ui_right"):
		emit_signal("swipe",1 ,-1)
	
	if event.is_action_pressed("ui_down"):
		emit_signal("swipe",2 ,-1)
	
	if event.is_action_pressed("ui_left"):
		emit_signal("swipe",3 ,-1)
	
	if event.is_action_pressed("ui_accept"):
		emit_signal("tap",4)


func _handle_touch(index: int, position: Vector2, is_pressed: bool):
	# PRESS
	if is_pressed:
		pressed = true
		hold_emitted = false
		press_position = position

		_detect_hold()

		return

	# RELEASE
	if !pressed:
		return

	pressed = false

	emit_signal("release", position)

	# SI UN HOLD A DÉJÀ ÉTÉ ÉMIS
	# ON NE FAIT NI TAP NI SWIPE
	if hold_emitted:
		return

	var distance = position.distance_to(press_position)

	# TAP
	if distance <= TAP_THRESHOLD:
		emit_signal("tap", position)

		return

	# SWIPE
	if distance >= SWIPE_MIN_DISTANCE:
		var delta = position - press_position
		var direction = _get_swipe_direction(delta)
		var duration = HOLD_TIME
		var velocity = distance / max(duration, 0.001)

		emit_signal("swipe", direction, velocity)

	if distance >= DRAG_START_DISTANCE:
		hold_emitted = true

		emit_signal("hold", press_position, HOLD_TIME)


func _detect_hold():
	await get_tree().create_timer(HOLD_TIME).timeout

	if !pressed:
		return

	hold_emitted = true

	emit_signal("hold", press_position, HOLD_TIME)


func _get_swipe_direction(delta: Vector2) -> int:
	if abs(delta.x) > abs(delta.y):
		return SwipeDirection.RIGHT if delta.x > 0 else SwipeDirection.LEFT
	else:
		return SwipeDirection.DOWN if delta.y > 0 else SwipeDirection.UP


func _on_press(position: Vector2):
	pressed = true
	hold_emitted = false

	press_position = position

	_detect_hold()


func _on_release(position: Vector2):
	if !pressed:
		return

	pressed = false

	emit_signal("release", position)

	if hold_emitted:
		return

	var distance =	position.distance_to(press_position)

	if distance <= TAP_THRESHOLD:
		emit_signal("tap", position)
