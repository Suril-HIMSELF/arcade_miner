class_name EffectManager
extends Node


signal effect_added(active_effect)
signal effect_removed(active_effect)
signal effect_triggered(active_effect)


enum ConsumeMode {
	NONE,
	INPUT,
	SUCCESS,
	FAILURE
}


class ActiveEffect:
	var effect: Effect
	var remaining_duration: float
	var remaining_charges: int
	var consume_mode: ConsumeMode
	var trigger_callback: Callable

	func _init(
		_effect: Effect,
		_duration: float = -1.0,
		_charges: int = -1,
		_consume_mode: ConsumeMode = ConsumeMode.NONE,
		_callback: Callable = Callable()
	):
		effect = _effect
		remaining_duration = _duration
		remaining_charges = _charges
		consume_mode = _consume_mode
		trigger_callback = _callback


var active_effects: Array[ActiveEffect] = []


func add_effect(
	effect: Effect,
	duration: float = -1.0,
	charges: int = -1,
	consume_mode: ConsumeMode = ConsumeMode.NONE,
	trigger_callback: Callable = Callable()
) -> ActiveEffect:

	var existing = get_effect(effect.name)

	if existing:
		return existing

	var active_effect = ActiveEffect.new(
		effect,
		duration,
		charges,
		consume_mode,
		trigger_callback
	)

	active_effects.append(active_effect)
	effect_added.emit(active_effect)

	return active_effect


func remove_effect(effect_name: String) -> void:
	var active_effect = get_effect(effect_name)

	if active_effect == null:
		return

	active_effects.erase(active_effect)
	effect_removed.emit(active_effect)


func has_effect(effect_name: String) -> bool:
	return get_effect(effect_name) != null


func get_effect(effect_name: String) -> ActiveEffect:
	for active_effect in active_effects:
		if active_effect.effect.name == effect_name:
			return active_effect

	return null


func process_effects(delta: float) -> void:
	for active_effect in active_effects.duplicate():

		if active_effect.remaining_duration < 0:
			continue

		active_effect.remaining_duration -= delta

		if active_effect.remaining_duration <= 0:
			remove_effect(active_effect.effect.name)


func consume_input(success: bool) -> void:
	for active_effect in active_effects.duplicate():

		var should_consume := false

		match active_effect.consume_mode:
			ConsumeMode.INPUT:
				should_consume = true

			ConsumeMode.SUCCESS:
				should_consume = success

			ConsumeMode.FAILURE:
				should_consume = not success

			ConsumeMode.NONE:
				should_consume = false

		if not should_consume:
			continue

		if active_effect.remaining_charges < 0:
			continue

		active_effect.remaining_charges -= 1

		effect_triggered.emit(active_effect)

		if active_effect.trigger_callback.is_valid():
			active_effect.trigger_callback.call(active_effect)

		if active_effect.remaining_charges <= 0:
			remove_effect(active_effect.effect.name)


func clear() -> void:
	for active_effect in active_effects.duplicate():
		remove_effect(active_effect.effect.name)
