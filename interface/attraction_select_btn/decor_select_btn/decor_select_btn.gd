class_name DecorSelectBTN extends Button;

@onready var PRICE_PANEL_GREEN := preload("res://interface/attraction_select_btn/attraction_price_panel_green.tres") as StyleBox;
@onready var PRICE_PANEL_RED := preload("res://interface/attraction_select_btn/attraction_price_panel_red.tres") as StyleBox;


@export var decor_data: DecorationData;

@onready var sprite := $Margin/VBoxContainer/Sprite;
@onready var price := $Margin/VBoxContainer/Price;
@onready var price_panel := $Margin/VBoxContainer/Price/Panel; # TODO: Change theme for when can't afford.


func _ready() -> void:
	if !decor_data:
		push_error("No Attraction Data @ %s" % get_path());
		return;
	
	sprite.set_texture(decor_data.texture);
	price.set_text("$%d" % decor_data.cost_to_build);
	
	ParkData.money_changed.connect(_on_park_data_money_changed);


func lock() -> void:
	print("Current: %s\nWish: %s" % [price_panel.theme, PRICE_PANEL_RED]);
	disabled = true;
	price_panel.add_theme_stylebox_override("panel", PRICE_PANEL_RED);


func unlock() -> void:
	disabled = false;
	price_panel.add_theme_stylebox_override("panel", PRICE_PANEL_GREEN);


func _on_park_data_money_changed(new_money: int) -> void:
	if new_money < decor_data.cost_to_build:
		lock();
	else:
		unlock();
