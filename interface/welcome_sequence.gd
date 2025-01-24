extends Control

signal start_game(park_name: String)
@onready var park_name = "Penguin Park"

func _on_next_button_1_pressed() -> void:
	$WelcomePage1.hide()
	$WelcomePage2.show()


func _on_next_button_2_pressed() -> void:
	$WelcomePage2.hide()
	$WelcomePage3.show()


func _on_next_button_3_pressed() -> void:
	$WelcomePage3.hide()
	$EnterParkName.show()


func _on_line_edit_text_submitted(new_text: String) -> void:
	if(new_text != ""):
		park_name = new_text
	start_game.emit(park_name)
	$".".hide()


func _on_start_day_1_button_pressed() -> void:
	park_name = $EnterParkName/EnterParkNameContainer/VBoxContainer/LineEdit.text
	start_game.emit(park_name)
	$".".hide()
