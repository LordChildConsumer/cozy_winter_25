class_name GameGUI extends Control;

var is_menu_hidden := true :
	set(value):
		is_menu_hidden = value;
		building_menu_visibility_changed.emit(!is_menu_hidden);

@onready var money_label = %MoneyLabel;
@onready var day_progress_bar = %DayProg;
@onready var start_day_button = %StartDayButton;
@onready var button_sound = $ButtonSound;
@onready var park_rating = $TopHUD/vb/Control/ParkRatingLabel;
@onready var milestone_progress_ring = $TopHUD/vb/Control/MilestoneProgress

signal building_menu_visibility_changed(shown: bool);
signal building_button_clicked(building_index: int)
signal start_day_button_pressed()

var unlock_milestones : Array[int] = [25, 75, 150, 225, 350, 500]

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")

@export var build_menu_hide_offset = Vector2(0.0, 296.00) #215
@onready var building_menu = $BuildingHUD/BuildMenu;
@onready var build_menu_start_pos := $BuildingHUD/BuildMenu.get_position() as Vector2;

func _ready() -> void:
	ParkData.money_changed.connect(
		func(new_money: int) -> void:
			print("New Money: %s" % new_money)
			money_label.set_text("$%d" % new_money);
	);
	
	ParkData.park_emptied.connect(show_start_day_button)
	ParkData.attraction_rating_changed.connect(_on_attraction_rating_changed)
	ParkData.money_changed.connect(_on_money_changed)


func _process(_delta: float) -> void:
	day_progress_bar.ratio = TimeTracker.get_day_progress()
	

func _on_money_changed(value: int):
	var money_earned = ParkData.money_earned
	var progress = 0.0

	# Iterate through milestones to find the current range
	for i in range(unlock_milestones.size()):
		if money_earned < unlock_milestones[i]:
			# Calculate progress relative to the current milestone range
			var lower_bound = unlock_milestones[i - 1] if i > 0 else 0
			var upper_bound = unlock_milestones[i]
			progress = float(money_earned - lower_bound) / float(upper_bound - lower_bound) * 100.0
			break
		elif money_earned >= unlock_milestones[-1]:
			# If money_earned exceeds the last milestone, set progress to 100%
			progress = 100.0

	# Update the progress bar value
	milestone_progress_ring.value = progress


func _on_attraction_rating_changed(value: int) -> void:
	park_rating.text = str(value)


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
		0.5 * Engine.time_scale
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);

func _on_build_menu_button_pressed() -> void:
	if is_menu_hidden:
		is_menu_hidden = false
		var tween := building_menu.create_tween();
		tween.tween_property(
			building_menu,
			"position:y",
			build_menu_start_pos.y - build_menu_hide_offset.y,
			0.5 * Engine.time_scale
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		#await tween.finished;
	else:
		%CoffeeBtn.button_pressed = false;
		%FoodBtn.button_pressed = false;
		%GiftBtn.button_pressed = false;
		var tween := building_menu.create_tween();
		tween.tween_property(
			building_menu,
			"position:y",
			build_menu_start_pos.y,
			0.5 * Engine.time_scale
			).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		#await tween.finished;
		is_menu_hidden = true


func _on_building_button_pressed(building_index: int) -> void:
	## HACK: This isn't used anymore.
	pass;
	#button_sound.play()
	#building_button_clicked.emit(building_index)



func _on_button_pressed() -> void:
	TimeTracker.open();
	button_sound.play()
	start_day_button.hide()

func show_start_day_button():
	start_day_button.show()


func _on_speed_btn_toggled(toggled_on: bool) -> void:
	button_sound.play();
	Engine.time_scale = 3.0 if toggled_on else 1.0;




# --------------------------------- #
# ---- Build Selection Buttons ---- #
# --------------------------------- #

var currently_selected_build_id: int = -1;
const COFFEE_ID: int = 0;
const FOOD_ID: int = 1;
const GIFT_ID: int = 2;

func _on_coffee_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = COFFEE_ID
		building_button_clicked.emit(COFFEE_ID);
		_turn_off_buttons(%CoffeeBtn);
		
	elif currently_selected_build_id == COFFEE_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);


func _on_food_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = FOOD_ID
		building_button_clicked.emit(FOOD_ID);
		_turn_off_buttons(%FoodBtn);
		
	elif currently_selected_build_id == FOOD_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);
		print(-1)


func _on_gift_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = GIFT_ID
		building_button_clicked.emit(GIFT_ID);
		_turn_off_buttons(%GiftBtn);
		
	elif currently_selected_build_id == GIFT_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);


func _on_shop_btn_pressed() -> void:
		button_sound.play();


func _on_bush_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = GIFT_ID
		building_button_clicked.emit(GIFT_ID);
		_turn_off_buttons(%BushBtn);
		
	elif currently_selected_build_id == GIFT_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);


func _on_lamp_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = GIFT_ID
		building_button_clicked.emit(GIFT_ID);
		_turn_off_buttons(%LampBtn);
		
	elif currently_selected_build_id == GIFT_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);


func _on_tree_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = GIFT_ID
		building_button_clicked.emit(GIFT_ID);
		_turn_off_buttons(%TreeBtn);
		
	elif currently_selected_build_id == GIFT_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);


func _on_bench_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currently_selected_build_id = GIFT_ID
		building_button_clicked.emit(GIFT_ID);
		_turn_off_buttons(%BenchBtn);
		
	elif currently_selected_build_id == GIFT_ID:
		currently_selected_build_id = -1;
		building_button_clicked.emit(-1);


@onready var shop_buttons: Array[Button] = [
	%CoffeeBtn, %FoodBtn, %GiftBtn,
	%BushBtn, %LampBtn, %TreeBtn, %BenchBtn
];
func _turn_off_buttons(except: Button) -> void:
	for b: Button in shop_buttons:
		if b != except:
			b.button_pressed = false;
