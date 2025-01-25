class_name Customer extends Actor;



var visited_attractions: Array[int] = [];
var busy: bool = false :
	set(value):
		busy = value;
		
		if OS.is_debug_build():
			modulate = Color.BLUE_VIOLET if busy else Color.WHITE;





func _on_customer_spent_money(new_value: int, customer_position: Vector2):
	var floating_money = FLOATING_MONEY_SCENE.instantiate()
	floating_money.text = "$" + str(new_value)
	add_child(floating_money)
	floating_money.position = position
	floating_money.move_to_target(position + Vector2(0, -50))


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
