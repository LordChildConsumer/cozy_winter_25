class_name Main extends Node2D;

const CUSTOMER_SCENE: PackedScene = preload("res://entities/actor/customer/customer.tscn")

@onready var park_entrance = $Park/ParkEntrance
@onready var build_sfx = $BuildSFX

const ATTRACTION_DATA := {
	0: preload("res://resources/attractions/coffee.tres"),
	1: preload("res://resources/attractions/food.tres"),
	2: preload("res://resources/attractions/gift.tres"),
	3: preload("res://resources/attractions/decor/bush.tres"),
	4: preload("res://resources/attractions/decor/lamp.tres"),
	5: preload("res://resources/attractions/decor/tree.tres"),
	6: preload("res://resources/attractions/decor/bench.tres"),
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
@onready var environment := $WorldEnvironment.environment as Environment;
@onready var color_correction := (environment.adjustment_color_correction as GradientTexture1D).gradient;

func _ready() -> void:
	SceneTransition.fade_to_game();
	
	game_gui.building_button_clicked.connect(_on_gui_building_button_clicked);
	game_gui.building_menu_visibility_changed.connect(
		_on_gui_build_menu_visibility_changed
	);
	
	for c: Node in attraction_parent.get_children():
		var a := c as Attraction;
		if a:
			a.build_attempted.connect(_on_attraction_build_attempted);


func _process(delta: float) -> void:
	adjust_adjustments(TimeTracker.get_day_progress());


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
			if value:
				if a.valid_buildings.has(selected_attraction_id):
					a.set_plot_visible(true);
					continue;
			a.set_plot_visible(false);
			


func _on_attraction_build_attempted(node: Attraction) -> void:
	if selected_attraction_id <= -1:
		return;
	
	if ParkData.get_money() >= ATTRACTION_DATA[selected_attraction_id].cost_to_build:
		node.load_attraction(ATTRACTION_DATA[selected_attraction_id]);
		ParkData.sub_money(ATTRACTION_DATA[selected_attraction_id].cost_to_build)
		build_sfx.play()
	else:
		pass


# ---- Night ---- #
# Brightness: 0.7
# Contrast: 1.15
# Saturation: 1.1
# Color Correction: 000000 -> d8c8f3

func adjust_adjustments(weight: float) -> void:
	environment.adjustment_brightness = lerpf(
		1.0,
		0.7,
		weight
	);
	
	color_correction.set_color(
		1,
		Color(1.0, 1.0, 1.0).lerp(Color(0.846, 0.786, 0.953), weight)
	);
