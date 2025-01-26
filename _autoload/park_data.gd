extends Node;

enum BUILD_STATE {
	NONE,
	BUILD,
	DEMOLISH,
};
var build_state: BUILD_STATE = BUILD_STATE.NONE :
	set(value):
		build_state = value;
		build_state_changed.emit(build_state);

signal build_state_changed(state: BUILD_STATE);
signal park_emptied()
signal attraction_rating_changed(value: int);
signal money_changed(value: int);

var money_earned = 0;
var park_name: String = "";
var _entrance_fee: int = 3 : set = set_entrance_fee, get = get_entrance_fee
# Attracting rating scales between 5 - 100
var _attraction_rating: int = 5 : set = set_attraction_rating, get = get_attraction_rating;
var _money: int = 25 : set = set_money, get = get_money;


func _ready() -> void:
	get_tree().node_added.connect(
		func(node: Node) -> void:
			money_changed.emit(_money);
	)

func set_entrance_fee(value: int) -> void:
	_entrance_fee = value

func get_entrance_fee() -> int: return _entrance_fee

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_4"):
		set_attraction_rating(_attraction_rating + 2)

func set_attraction_rating(value: int) -> void:
	_attraction_rating = value
	attraction_rating_changed.emit(_attraction_rating)

func get_attraction_rating() -> int: return _attraction_rating

func set_money(value: int) -> void:
	#print("Money: %d\nNew Money %d\nDifference: %d" % [_money, value, value - _money]);
	money_earned += value - _money
	_money = max(value, 0.0);
	money_changed.emit(_money);

func get_money() -> int: return _money;

func add_money(rhs: int) -> void: 
	_money += rhs;
	money_earned += rhs;
func sub_money(rhs: int) -> void: _money -= rhs;
