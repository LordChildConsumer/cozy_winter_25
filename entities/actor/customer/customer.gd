class_name Customer extends Actor;

signal exited_park(node: Customer);

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")
@onready var money_sound = $MoneySound


var park_entrance: Vector2;
var park_exit: Vector2;

var in_park: bool = false;

var visited_attractions: Array[int] = [];
var busy: bool = false;




# --------------------------------- #
# ---- Attraction Interactions ---- #
# --------------------------------- #

func can_visit(attraction: Attraction) -> bool:
	return !visited_attractions.has(attraction.get_instance_id());


func visit_attraction(attraction: Attraction, global_pos: Vector2) -> void:
	busy = true;
	moving = true;
	wandering = false;
	nav_agent.target_position = global_pos;
	
	visited_attractions.push_back(attraction.get_instance_id());


func leave_attraction() -> void:
	busy = false;
	moving = true
	wandering = true
	nav_agent.target_position = get_random_wander_point();




# ------------------------- #
# ---- Enter/Exit Park ---- #
# ------------------------- #

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug_3"):
		#print_debug("Debug 4: 6x Time Scale");
		#Engine.time_scale = 6.0;

func exit_park() -> void:
	wander_timer.stop();
	nav_agent.target_position = park_exit;
	busy = true;
	moving = true
	wandering = false
	
	await nav_agent.navigation_finished;
	
	exited_park.emit(self);


func spawn_entrance_fee_money():
	var floating_money = FLOATING_MONEY_SCENE.instantiate()
	#floating_money.text = "$2.f" % ParkData.get_entrance_fee()
	floating_money.set_text("$%d" % ParkData.get_entrance_fee());
	add_child(floating_money)
	floating_money.global_position = global_position
	floating_money.move_to_target(position + Vector2(0.0, -50))
	money_sound.play()
