class_name Actor extends CharacterBody2D;


@export_group("Wandering")
@export var wander_time_min: float = 3.0;
@export var wander_time_max: float = 10.0;


@export_group("Movement")
@export var move_speed: float = 50.0;
@export var acceleration: float = 15.0;

@onready var wander_timer := $WanderTimer as Timer;
@onready var nav_agent := $NavAgent as NavigationAgent2D;

var nav_region_rid: RID;
var moving: bool = false;
var wandering: bool = true;

var park_entrance : Vector2


func _ready() -> void:
	nav_agent.max_speed = max(nav_agent.max_speed, move_speed);
	_on_wander_timer_timeout()
	wander_timer.start(get_new_wander_time());
	


func _physics_process(delta: float) -> void:
	velocity = get_new_velocity(delta);
	move_and_slide();


func get_new_velocity(delta: float) -> Vector2:
	var wish_velocity := Vector2.ZERO;
	
	if moving:
		var dir := global_position.direction_to(
			nav_agent.get_next_path_position()
		);
		wish_velocity = dir * move_speed;
	
	return velocity.lerp(
		wish_velocity,
		acceleration * delta
	);

func exit_park() -> void:
	print("exitign park")
	wander_timer.stop();
	nav_agent.target_position = park_entrance
	wandering = false
	moving = true

## When the wander/wait timer has stopped:
## Pick a new random point on the iceberg.
func _on_wander_timer_timeout() -> void:
	wander_timer.stop();
	
	if wandering:
		nav_agent.target_position = get_random_wander_point();
		moving = true;


## When the desired "wander point" is reached:
## Wait a random amount of time between wander_time_min and wander_time_max.
func _on_nav_agent_navigation_finished() -> void:
	moving = false;
	
	if wandering:
		wander_timer.start(get_new_wander_time());


func get_new_wander_time() -> float:
	return randf_range(wander_time_min, wander_time_max);


func get_random_wander_point() -> Vector2:
	return NavigationServer2D.region_get_random_point(
		nav_region_rid,
		nav_agent.navigation_layers,
		false
	);


func _place_randomly_on_nav_mesh() -> void:
	# Without this await the region is null and I can't find a signal
	# to wait for that to not be the case but this is fine enough.
	await get_tree().process_frame;
	global_position = get_random_wander_point();
