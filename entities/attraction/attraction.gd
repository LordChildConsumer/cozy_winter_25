class_name Attraction extends Node2D;

enum SIDES_OF_ZOO {TOP, RIGHT, BOTTOM, LEFT};

const BUILDING_SIZE: float = 256.0;


# TODO: Manage available/reserved slots for customers

# TODO: Try to attract customers in range.

# TODO: Unload AttractionData (maybe refund % of cost?)
#		Could be the remainder of the build cost not made back yet?


@export var side_of_zoo: SIDES_OF_ZOO;


@onready var building_sprite := $Building/Sprite;
@onready var attract_zone := $AttractZone;
@onready var attract_zone_collider := $AttractZone/Collider as CollisionShape2D;
@onready var customer_slot_path := $CustomerSlots as Path2D;


var _data: AttractionData;




# ------------------------- #
# ---- Attraction Data ---- #
# ------------------------- #

func has_attraction() -> bool:
	return _data != null;


func load_attraction(dat: AttractionData) -> void:
	_data = dat;
	
	# ---- Sprite / Texture ---- #
	building_sprite.set_texture(_data.texture);
	
	# ---- Effective Range ---- #
	var _circle := attract_zone_collider.get_shape() as CircleShape2D;
	if _circle:
		_circle.radius = _data.effective_range;
	
	# ---- Customer Slots ---- #
	_clear_customer_slots()
	_spawn_customer_slots(_data.max_customers);


func remove_attraction() -> void:
	pass;




# ------------------------ #
# ---- Customer Slots ---- #
# ------------------------ #

func _clear_customer_slots() -> void:
	for c: Node in customer_slot_path.get_children():
		c.queue_free();

func _spawn_customer_slots(count: int) -> void:
	for i: int in count:
		var t := 1.0 / (count - 1);
		var slot := Marker2D.new();
		customer_slot_path.add_child(slot);
		
		# HACK: I mean just look at the curve and it's pretty obvious
		#		just how stupidly hacky this is. I'm honestly proud of myself.
		var a := customer_slot_path.curve.get_point_position(side_of_zoo * 2);
		var b := customer_slot_path.curve.get_point_position(side_of_zoo * 2 + 1);
		
		# Lerping cuz bezier interpolation fucks this up.
		slot.position = a.lerp(b, t*i);








#region DEBUG DRAW CUSTOMER POINTS
# FIXME: Remove this debug drawing stuff later.

func _process(_delta: float) -> void:
	queue_redraw();

func _draw() -> void:
	#draw_line(
		#customer_slot_path.curve.sample(side_of_zoo * 2, 0.0),
		#customer_slot_path.curve.sample(side_of_zoo * 2, 1.0),
		#Color.GREEN,
		#2.0
	#);
	
	for c: Node in customer_slot_path.get_children():
		draw_circle(c.position, 4.0, Color.RED, true);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		print_debug("Debug 1: Loading Hot Cocoa Data");
		load_attraction(load("res://resources/attractions/hot_cocoa.tres"));
#endregion
