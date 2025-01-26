extends Node2D

@onready var button_sound = $ButtonSound
@onready var play_game_sound = $PlayGameSound


func _on_texture_button_pressed() -> void:
	$TextureButton.disabled = true;
	
	play_game_sound.play()
	var _wait := await SceneTransition.fade_to_black();
	get_tree().change_scene_to_file("res://interface/GUI.tscn");


func _on_texture_button_mouse_entered() -> void:
	button_sound.play()
