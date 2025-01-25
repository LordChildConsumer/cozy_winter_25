class_name GameGUI extends Control;

var is_menu_hidden := true :
	set(value):
		is_menu_hidden = value;
		building_menu_visibility_changed.emit(!is_menu_hidden);
#slide value is 200

@onready var money_label = $TopHUD/MoneyLabel
@onready var day_progress_bar = $TopHUD/TimerCenterContainer/HBoxContainer/VBoxContainer/ProgressBar

signal building_menu_visibility_changed(shown: bool);
signal building_button_clicked(building_index: int)

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")

@onready var build_menu_start_pos := $BuildingHUD.position as Vector2
@export var build_menu_hide_offset = Vector2(0.0, 215.00)
@onready var building_menu = $BuildingHUD
@onready var money_lbl := $TopHUD/MoneyLabel;

func _ready() -> void:
	ParkData.money_changed.connect(
		func(new_money: int) -> void:
			money_lbl.set_text("$%d" % new_money);
	);


func _process(_delta: float) -> void:
	day_progress_bar.ratio = TimeTracker.get_day_progress()


func _on_build_menu_button_pressed() -> void:
	if is_menu_hidden:
		var tween := building_menu.create_tween();
		tween.tween_property(
			building_menu,
			"position",
			build_menu_start_pos - build_menu_hide_offset,
			0.5
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		#await tween.finished;
		is_menu_hidden = false
	else:
		var tween := building_menu.create_tween();
		tween.tween_property(
			building_menu,
			"position",
			build_menu_start_pos,
			0.5
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		#await tween.finished;
		is_menu_hidden = true


func _on_building_button_pressed(building_index: int) -> void:
	building_button_clicked.emit(building_index)


func _on_fast_forward_button_pressed() -> void:
	Engine.time_scale = 3


func _on_play_button_pressed() -> void:
	Engine.time_scale = 1
