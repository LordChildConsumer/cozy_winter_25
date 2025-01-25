extends Control

var is_menu_hidden := true
#slide value is 200

@onready var money_label = $TopHUD/MoneyLabel

signal building_button_clicked(building_index: int)

const FLOATING_MONEY_SCENE: PackedScene = preload("res://interface/floating_money_text.tscn")

@onready var build_menu_start_pos := $BuildingHUD.position as Vector2
@export var build_menu_hide_offset = Vector2(0.0, 215.00)
@onready var building_menu = $BuildingHUD

func _ready() -> void:
	ParkData.customer_spent_money.connect(_on_customer_spent_money)

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


func _on_customer_spent_money(new_value: int, customer_position: Vector2):
	var floating_money : Node = FLOATING_MONEY_SCENE.instantiate()
	floating_money.value = new_value
	
	add_child(floating_money)
	floating_money.global_position = customer_position
	#floating_money.move_to_target(money_label.global_position)
	


func _on_building_button_pressed(building_index: int) -> void:
	building_button_clicked.emit(building_index)
	
