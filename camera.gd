class_name PlayerCamera extends Camera2D;

@export var enable_zoom: bool = false;

@export_group("Movement")
@export var move_speed: float = 1500.0;
@export var max_distance: Vector2 = Vector2(496.0, 480);

@export_group("Zoom")
@export var zoom_step: float = 0.1;
@export var zoom_speed: float = 10.0;
@export var zoom_min: float = 0.75;
@export var zoom_max: float = 1.5;

@onready var start_pos := position;
@onready var start_smoothing := position_smoothing_speed;

var last_time_scale: float = 1.0;
var zoom_factor: float = 1.0;

func _physics_process(delta: float) -> void:
	if Engine.time_scale != last_time_scale:
		last_time_scale = Engine.time_scale;
		position_smoothing_speed = start_smoothing / last_time_scale;
	
	# ---- Velocity ---- #
	var wish_velocity := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	).normalized() * move_speed / zoom_factor;
	
	position += (wish_velocity / Engine.time_scale) * delta;
	position = position.clamp(-max_distance, max_distance);
	
	
	# ---- Zoom ---- #
	#zoom_factor = clampf(zoom_factor, zoom_min, zoom_max);
	#zoom.x = lerp(zoom.x, 1.0 * zoom_factor, (zoom_speed / Engine.time_scale) * delta);
	#zoom.y = lerp(zoom.y, 1.0 * zoom_factor, (zoom_speed / Engine.time_scale) * delta);


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#_handle_zoom(event as InputEventMouseButton);
#
#
#func _handle_zoom(event: InputEventMouseButton) -> void:
	#if event.is_released():
		#if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#zoom_factor += zoom_factor * zoom_step;
		#elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#zoom_factor -= zoom_factor * zoom_step;
