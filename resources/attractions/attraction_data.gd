class_name AttractionData extends Resource;

@export var name: StringName = &"";
@export var texture: Texture2D;
@export var cost_to_build: int = 100;
@export_range(0.0, 1.0, 0.01) var attractiveness: float = 0.5;
@export var effective_range: float = 300.0;


@export_category("Customer Stats")
@export_range(0, 6, 1) var max_customers: int = 3;

@export_group("Spending")
@export var spending_min: int = 5;
@export var spending_max: int = 25;
@export var spending_curve: Curve;

@export_group("Timing")
@export var time_min: int = 1;
@export var time_max: int = 5;




func get_customer_spending() -> int:
	var spending := lerpf(
		spending_min,
		spending_max,
		spending_curve.sample(randf())
	);
	
	return int(roundi(spending));


func get_customer_time() -> float:
	return randf_range(time_min, time_max);
