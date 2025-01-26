extends Node;

signal park_closed;
signal park_opened;


# Park will be open for TIME_OPEN_MAX seconds
const TIME_OPEN_MAX: float = 100.0; # 100
var time_open: float = TIME_OPEN_MAX;
var _open: bool = false;

var days_open: int = 0;


func _process(delta: float) -> void:
	if _open:
		time_open += delta;
		
		if time_open >= TIME_OPEN_MAX:
			close();


func get_day_progress() -> float:
	return inverse_lerp(0.0, TIME_OPEN_MAX, time_open);


func is_open() -> bool: 	return _open;

func open() -> void:
	MusicManager.crossfade(MusicManager.night_player, MusicManager.day_player);
	
	#time_open = 0.0;
	var current_time_scale := Engine.time_scale;
	Engine.time_scale = 1.0;
	var tween := create_tween().tween_property(self, "time_open", 0.0, 5.0);
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished;
	if current_time_scale != 1.0:
		Engine.time_scale = current_time_scale;
	print("Open!")
	
	_open = true;
	park_opened.emit();

func close() -> void:
	_open = false;
	park_closed.emit();
	MusicManager.crossfade(MusicManager.day_player, MusicManager.night_player, 5.0);
