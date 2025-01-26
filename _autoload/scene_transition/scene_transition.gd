extends CanvasLayer


@onready var anim := $AnimationPlayer as AnimationPlayer;

func fade_to_black() -> bool:
	anim.play(&"to_black");
	await anim.animation_finished;
	return true;


func fade_to_game() -> bool:
	anim.play(&"to_game");
	await anim.animation_finished;
	return true;
