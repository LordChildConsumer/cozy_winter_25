extends Node;

signal park_closing;
signal park_opening;


# Park will be open for 60 seconds
const TIME_OPEN_MAX: float = 60.0;
var time_open: float = 0.0;

var _open: bool = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		print_debug("Debug 1: Opening Park!");
		open();


func _process(delta: float) -> void:
	if _open:
		time_open += delta;
		
		if time_open >= TIME_OPEN_MAX:
			_open = false;
			park_closing.emit();
			time_open = 0.0;


func get_day_progress() -> float:
	return inverse_lerp(0.0, TIME_OPEN_MAX, time_open);


func is_open() -> bool: 	return _open;
func open() -> void:		_open = true; park_opening.emit();
