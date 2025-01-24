extends Node;

signal park_closed;
signal park_opened;


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
			close();


func get_day_progress() -> float:
	return inverse_lerp(0.0, TIME_OPEN_MAX, time_open);


func is_open() -> bool: 	return _open;

func open() -> void:
	time_open = 0.0;
	_open = true;
	park_opened.emit();

func close() -> void:
	time_open = 0.0;
	_open = false;
	park_closed.emit();
