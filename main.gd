class_name Main extends Node2D;

const CUSTOMER_SCENE: PackedScene = preload("res://entities/actor/customer/customer.tscn")

@onready var park_entrance = $Park/ParkEntrance

const ATTRACTION_DATA := {
	0: preload("res://resources/attractions/hot_cocoa.tres"),
	1: preload("res://resources/attractions/not_hot_cocoa.tres"),
};

var selected_attraction_id: int = -1 :
	set(value):
		selected_attraction_id = value;
		
		if value > -1:
			set_plot_visibilities(true);
		else:
			set_plot_visibilities(false);


@onready var game_gui := $CanvasLayer/GameGUI as GameGUI;
@onready var attraction_parent := $Park/Attractions;

func _ready() -> void:
	game_gui.building_button_clicked.connect(_on_gui_building_button_clicked);
	game_gui.building_menu_visibility_changed.connect(
		_on_gui_build_menu_visibility_changed
	);
	
	for c: Node in attraction_parent.get_children():
		var a := c as Attraction;
		if a:
			a.build_attempted.connect(_on_attraction_build_attempted);


func _on_gui_building_button_clicked(idx: int) -> void:
	selected_attraction_id = idx;


func _on_gui_build_menu_visibility_changed(shown: bool) -> void:
	selected_attraction_id = -1;
	
	if shown:
		ParkData.build_state = ParkData.BUILD_STATE.BUILD;
	else:
		ParkData.build_state = ParkData.BUILD_STATE.NONE;


func set_plot_visibilities(value: bool) -> void:
	print(value);
	for c: Node in attraction_parent.get_children():
		var a := c as Attraction;
		if a:
			a.set_plot_visible(value);


func _on_attraction_build_attempted(node: Attraction) -> void:
	node.load_attraction(ATTRACTION_DATA[selected_attraction_id]);
