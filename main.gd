class_name Main extends Node2D;

const ATTRACTION_DATA := {
	0: preload("res://resources/attractions/hot_cocoa.tres"),
	1: preload("res://resources/attractions/not_hot_cocoa.tres"),
};


@onready var game_gui := $CanvasLayer/GameGUI as GameGUI;

func _ready() -> void:
	game_gui.building_button_clicked.connect(_on_gui_building_button_clicked);


func _on_gui_building_button_clicked(idx: int) -> void:
	print("Selected: %s" % (ATTRACTION_DATA[idx] as AttractionData).name);
