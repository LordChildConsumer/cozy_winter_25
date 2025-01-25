extends Label


func move_to_target(target_position: Vector2) -> void:
	var tween := create_tween();
	tween.tween_property(
		self,
		"global_position",
		target_position,
		1.5
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	await tween.finished;
	queue_free()
