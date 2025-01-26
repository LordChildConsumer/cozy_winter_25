extends Node2D

func _on_texture_button_pressed() -> void:
	var _wait := await SceneTransition.fade_to_black();
	get_tree().change_scene_to_file("res://interface/GUI.tscn");
