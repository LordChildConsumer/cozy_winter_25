extends Node2D

@export var fade_time: float = 3.0;
@export var silence_db: float = -50.0; # -80..?

@onready var day_player := $Day as AudioStreamPlayer;
@onready var night_player := $Night as AudioStreamPlayer;

func _ready() -> void:
	day_player.volume_db = linear_to_db(0.0);
	night_player.volume_db = linear_to_db(0.0);


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug_1"):
		#print_debug("Playing Day!");
		#crossfade(day_player, night_player);
	#if event.is_action_pressed("debug_2"):
		#print_debug("Playing Night!");
		#crossfade(night_player, day_player);
	#if event.is_action_pressed("debug_3"):
		#print_debug("Stopping Music!");
		#crossfade(day_player, null);

func crossfade(a: AudioStreamPlayer, b: AudioStreamPlayer, secs: float = fade_time) -> void:
	if a:
		if a.playing:
			await a.create_tween().tween_property(
				a,
				"volume_db",
				silence_db,
				fade_time
			).finished;
			a.stop();
	
	if b:
		b.play();
		b.volume_db = -80.0;
		await b.create_tween().tween_property(
			b,
			"volume_db",
			linear_to_db(1.0),
			fade_time
		).finished;
