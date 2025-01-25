extends Label

signal reached_destination(value: int)

var value : int

func move_to_target(target_position: Vector2) -> void:
	var tween := create_tween();
	tween.tween_property(
		self,
		"global_position",
		target_position,
		0.5
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	await tween.finished;
	
	reached_destination.emit(value)
	queue_free()
