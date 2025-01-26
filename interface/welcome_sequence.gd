extends Control

#signal start_game(park_name: String)

@onready var park_name = "Penguin Park"

@onready var welcome_page_1 := $WelcomePage1;
@onready var welcome_page_2 := $WelcomePage2;
@onready var welcome_page_3 := $WelcomePage3;
@onready var enter_park_name := $EnterParkName;

func _on_next_button_1_pressed() -> void:
	welcome_page_1.hide()
	welcome_page_2.show()


func _on_next_button_2_pressed() -> void:
	welcome_page_2.hide()
	welcome_page_3.show()


func _on_next_button_3_pressed() -> void:
	welcome_page_3.hide()
	enter_park_name.show()


func _on_line_edit_text_submitted(new_text: String) -> void:
	if(new_text != ""):
		park_name = new_text
	ParkData.park_name = park_name
	var wait := await SceneTransition.fade_to_black();
	get_tree().change_scene_to_file("res://main.tscn");


func _on_start_day_1_button_pressed() -> void:
	park_name = $EnterParkName/EnterParkNameContainer/VBoxContainer/LineEdit.text
	ParkData.park_name = park_name
	#$"..".queue_free()
	
	var _wait := await SceneTransition.fade_to_black();
	get_tree().change_scene_to_file("res://main.tscn");
