extends Control

var is_menu_hidden := true
#slide value is 200

signal building_button_clicked(building_index: int)

@onready var build_menu_start_pos := $BuildingHUD.position as Vector2
@export var build_menu_hide_offset = Vector2(0.0, 215.00)
@onready var building_menu = $BuildingHUD

func _on_build_menu_button_pressed() -> void:
	print("pressed")
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
	print("Building: ", building_index)
	building_button_clicked.emit(building_index)
	
