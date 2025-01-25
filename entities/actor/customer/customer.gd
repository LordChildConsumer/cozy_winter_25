class_name Customer extends Actor;

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")
@onready var money_sound = $MoneySound



var visited_attractions: Array[int] = [];
var busy: bool = false :
	set(value):
		busy = value;
		
		if OS.is_debug_build():
			modulate = Color.BLUE_VIOLET if busy else Color.WHITE;

func spawn_entrance_fee_money():
	var floating_money = FLOATING_MONEY_SCENE.instantiate()
	floating_money.text = "$%.2f" % ParkData.get_entrance_fee()
	add_child(floating_money)
	floating_money.global_position = global_position
	floating_money.move_to_target(position + Vector2(0.0, -50))
	money_sound.play()


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
