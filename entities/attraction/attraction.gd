class_name Attraction extends Node2D;

enum SIDES_OF_ZOO {TOP, RIGHT, BOTTOM, LEFT};

const BUILDING_SIZE: float = 256.0;


# TODO: Unload AttractionData (maybe refund % of cost?)
#		Could be the remainder of the build cost not made back yet?

signal build_attempted(node: Attraction);

@export var side_of_zoo: SIDES_OF_ZOO;


@onready var building_sprite := $Building/Sprite;
@onready var attract_zone := $AttractZone;
@onready var attract_zone_collider := $AttractZone/Collider as CollisionShape2D;
@onready var customer_spot := $CustomerSpot;
@onready var customer_timer := $CustomerTimer;
@onready var money_sound := $MoneySound;
@onready var plot := $Plot;

var _data: AttractionData;

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")

var busy: bool = false;

func _ready() -> void:
	plot.hide();
	#ParkData.build_state_changed.connect(_on_park_data_build_state_changed);
	
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
				
				var floating_money = FLOATING_MONEY_SCENE.instantiate()
				floating_money.text = "$" + str(income)
				add_child(floating_money)
				floating_money.position = position
				floating_money.move_to_target(position + Vector2(0.0, -50))
				money_sound.play()
				
				if is_instance_valid(customer):
					customer.leave_attraction();


func should_attract_customer() -> bool:
	return randf() < _data.attractiveness;




func set_plot_visible(value: bool) -> void:
	plot.set_visible(value);


func _on_plot_mouse_entered() -> void:
	if ParkData.build_state == ParkData.BUILD_STATE.BUILD && plot.visible:
		MouseCursor.build();


func _on_plot_mouse_exited() -> void:
	MouseCursor.default();


func _on_plot_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ParkData.build_state == ParkData.BUILD_STATE.BUILD:
		var m := event as InputEventMouseButton;
		if m:
			if m.button_index == MOUSE_BUTTON_LEFT && m.is_released():
				build_attempted.emit(self);
