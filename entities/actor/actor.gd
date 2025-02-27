class_name Actor extends CharacterBody2D;

@export_group("Sprites")
@export var is_penguin: bool = false;

@export_group("Wandering")
@export var wander_time_min: float = 3.0;
@export var wander_time_max: float = 10.0;


@export_group("Movement")
@export var move_speed: float = 50.0;
@export var acceleration: float = 15.0;

@onready var wander_timer := $WanderTimer as Timer;
@onready var nav_agent := $NavAgent as NavigationAgent2D;
@onready var sprite := $Sprite as Sprite2D;
@onready var anim := $AnimationPlayer as AnimationPlayer;

var nav_region_rid: RID;
var moving: bool = false :
	set(value):
		moving = value;
		anim.play(&"move" if value else &"idle");
var wandering: bool = true;



func _ready() -> void:
	nav_agent.max_speed = max(nav_agent.max_speed, move_speed);
	_on_wander_timer_timeout()
	wander_timer.start(get_new_wander_time());
	
	set_sprite();


func _physics_process(delta: float) -> void:
	velocity = get_new_velocity(delta);
	
	if sign(velocity.x) < 0:
		sprite.flip_h = true;
	elif sign(velocity.x) > 0:
		sprite.flip_h = false;
	
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


## When the wander/wait timer has stopped:
## Pick a new random point on the iceberg.
func _on_wander_timer_timeout() -> void:
	wander_timer.stop();
	
	if wandering:
		await get_tree().process_frame;
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


func set_sprite() -> void:
	if is_penguin:
		sprite.frame_coords.x = 5;
	else:
		sprite.frame_coords.x = randi_range(0, 4);
