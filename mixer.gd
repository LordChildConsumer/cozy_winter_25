extends RigidBody2D

@export var grab_velocity_expo: float = 1.5;
@export var angular_force: float = 100_000.0;

@onready var rotation_target := $RotTarget as Marker2D;

var has_mouse: bool = false;
var grabbed: bool = false;

var mouse_limit_s: Vector2;
var mouse_limit_e: Vector2;

func _on_mouse_entered() -> void:  has_mouse = true;
func _on_mouse_exited() -> void:  has_mouse = false;


func _ready() -> void:
	var ml_start := $Limiter/MouseLimitStart as Marker2D;
	var ml_end := $Limiter/MouseLimitStart/MouseLimitEnd as Marker2D;
	mouse_limit_s = ml_start.global_position as Vector2;
	mouse_limit_e = ml_end.global_position as Vector2;


func _input(event: InputEvent) -> void:
	var me := event as InputEventMouseButton;
	if me:
		if has_mouse:
			if me.is_pressed() && me.button_index == MOUSE_BUTTON_LEFT:
				grabbed = true;
				return;
		grabbed = false;



func _physics_process(_delta: float) -> void:
	if grabbed:
		linear_velocity = get_target_velocity(get_global_mouse_position());
		#constant_torque = get_target_torque(rotation_target.global_position);
		apply_torque(get_target_torque(rotation_target.global_position));


func get_target_velocity(mouse_pos: Vector2) -> Vector2:
	mouse_pos = mouse_pos.clamp(mouse_limit_s, mouse_limit_e);
	
	var d := global_position.direction_to(mouse_pos);
	var f := global_position.distance_to(mouse_pos);
	
	return d * pow(f, grab_velocity_expo);


func get_target_torque(global_target_pos: Vector2) -> float:
	var dir := -global_transform.x.dot(global_position.direction_to(global_target_pos));
	return dir * 1.5 * angular_force;
	
	return 0;

