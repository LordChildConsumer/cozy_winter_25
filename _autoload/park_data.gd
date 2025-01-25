extends Node;

signal money_changed(value: int);

var park_name: String = "";

var _money: int = 100 : set = set_money, get = get_money;


func set_money(value: int) -> void:
	print("Money: %d\nNew Money %d\nDifference: %d" % [_money, value, value - _money]);
	_money = max(value, 0.0);
	money_changed.emit(_money);

func get_money() -> int: return _money;

func add_money(rhs: int) -> void: _money += rhs;
func sub_money(rhs: int) -> void: _money -= rhs;
