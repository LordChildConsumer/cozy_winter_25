extends RigidBody2D

@export var grab_velocity_expo: float = 1.5;

var has_mouse: bool = false;
var grabbed: bool = false;

func _on_mouse_entered() -> void:  has_mouse = true;
func _on_mouse_exited() -> void:  has_mouse = false;


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
		linear_velocity = get_force_to_mouse(get_global_mouse_position());


func get_force_to_mouse(mouse_pos: Vector2) -> Vector2:
	var d := global_position.direction_to(mouse_pos);
	var f := global_position.distance_to(mouse_pos);
	
	return d * pow(f, grab_velocity_expo);
