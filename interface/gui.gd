class_name GameGUI extends Control;

var is_menu_hidden := true :
	set(value):
		is_menu_hidden = value;
		building_menu_visibility_changed.emit(!is_menu_hidden);
#slide value is 200

@onready var money_label = $TopHUD/MoneyLabel
@onready var day_progress_bar = $TopHUD/TimerCenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var start_day_button = $TopHUD/TimerCenterContainer/VBoxContainer/StartDayButton
@onready var button_sound = $ButtonSound
@onready var park_name = $TopHUD/TimerCenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/ParkName
signal building_menu_visibility_changed(shown: bool);
signal building_button_clicked(building_index: int)
signal start_day_button_pressed()

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")

@export var build_menu_hide_offset = Vector2(0.0, 215.00)
@onready var building_menu = $BuildingHUD/hBox;
@onready var build_menu_start_pos := $BuildingHUD/hBox.get_position() as Vector2;
@onready var money_lbl := $TopHUD/MoneyLabel;

func _ready() -> void:
	ParkData.money_changed.connect(
		func(new_money: int) -> void:
			money_lbl.set_text("$%d" % new_money);
	);
	
	ParkData.park_emptied.connect(show_start_day_button)
	park_name.text = ParkData.park_name


func _process(_delta: float) -> void:
	day_progress_bar.ratio = TimeTracker.get_day_progress()


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel"):
		if(is_menu_hidden == false):
			hide_menu()

func hide_menu():
	is_menu_hidden = true
	var tween := building_menu.create_tween();
	tween.tween_property(
		building_menu,
		"position:y",
		build_menu_start_pos.y,
		0.5
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);

func _on_build_menu_button_pressed() -> void:
	if is_menu_hidden:
		is_menu_hidden = false
		var tween := building_menu.create_tween();
		tween.tween_property(
			building_menu,
			"position:y",
			build_menu_start_pos.y - build_menu_hide_offset.y,
			0.5
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		#await tween.finished;
	else:
		var tween := building_menu.create_tween();
		tween.tween_property(
			building_menu,
			"position:y",
			build_menu_start_pos.y,
			0.5
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		#await tween.finished;
		is_menu_hidden = true


func _on_building_button_pressed(building_index: int) -> void:
	button_sound.play()
	building_button_clicked.emit(building_index)


func _on_fast_forward_button_pressed() -> void:
	button_sound.play()
	Engine.time_scale = 3


func _on_play_button_pressed() -> void:
	button_sound.play()
	Engine.time_scale = 1


func _on_button_pressed() -> void:
	TimeTracker.open();
	button_sound.play()
	start_day_button.hide()

func show_start_day_button():
	start_day_button.show()
