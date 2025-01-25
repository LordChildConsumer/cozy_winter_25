class_name Attraction extends Node2D;

enum SIDES_OF_ZOO {TOP, RIGHT, BOTTOM, LEFT};

const BUILDING_SIZE: float = 256.0;


# TODO: Unload AttractionData (maybe refund % of cost?)
#		Could be the remainder of the build cost not made back yet?


@export var side_of_zoo: SIDES_OF_ZOO;


@onready var building_sprite := $Building/Sprite;
@onready var attract_zone := $AttractZone;
@onready var attract_zone_collider := $AttractZone/Collider as CollisionShape2D;
@onready var customer_spot := $CustomerSpot;
@onready var customer_timer := $CustomerTimer;

var _data: AttractionData;

var busy: bool = false;


func _ready() -> void:
	attract_zone.monitoring = false;
	
	# HACK: 'Enum as Int' my beloved <3
	customer_spot.position = customer_spot.position.rotated(
		deg_to_rad(90 * side_of_zoo)
	);
	attract_zone_collider.position = attract_zone_collider.position.rotated(
		deg_to_rad(90 * side_of_zoo)
	);


# ------------------------- #
# ---- Attraction Data ---- #
# ------------------------- #

func has_attraction() -> bool:
	return _data != null;


func load_attraction(dat: AttractionData) -> void:
	_data = dat;
	
	# ---- Sprite / Texture ---- #
	building_sprite.set_texture(_data.texture);
	
	# ---- Enable AttractZone ---- #
	attract_zone.monitoring = true;


func remove_attraction() -> void:
	pass;




# -------------------------------- #
# ---- Customers Interactions ---- #
# -------------------------------- #

func _on_attract_zone_body_entered(body: Node2D) -> void:
	if _data && !busy:
		var customer := body as Customer;
		if customer:
			if customer.can_visit(self) && should_attract_customer():
				busy = true;
				customer.visit_attraction(self, customer_spot.global_position);
				await customer.nav_agent.navigation_finished;
				
				customer_timer.start(_data.get_customer_time());
				await customer_timer.timeout;
				
				var income := _data.get_customer_spending();
				ParkData.add_money(income);
				ParkData.customer_spent_money.emit(income, customer.global_position);
				
				customer.leave_attraction();


func should_attract_customer() -> bool:
	return randf() < _data.attractiveness;



# --------------------- #
# ---- Debug Stuff ---- #
# --------------------- #

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		load_attraction(load("res://resources/attractions/hot_cocoa.tres"));
		print_debug("Debug 1: Loading Attraction %s" % _data.name);


func _process(_delta: float) -> void:
	if OS.is_debug_build():
		queue_redraw();


func _draw() -> void:
	if OS.is_debug_build():
		draw_circle(
			customer_spot.position,
			4.0,
			Color.BLUE
		);


