extends Control

@onready var tooltip = $Tooltip
@onready var tooltip_label = $Tooltip/CenterBox/TooltipLabel

var follow_mouse = false

var top_right = false
	
const ATTRACTION_DATA := {
	0: preload("res://resources/attractions/coffee.tres"),
	1: preload("res://resources/attractions/food.tres"),
	2: preload("res://resources/attractions/gift.tres"),
	3: preload("res://resources/attractions/decor/bush.tres"),
	4: preload("res://resources/attractions/decor/lamp.tres"),
	5: preload("res://resources/attractions/decor/tree.tres"),
	6: preload("res://resources/attractions/decor/bench.tres"),
};

func _physics_process(_delta: float) -> void:
	if(tooltip.is_visible_in_tree() && !top_right):
		tooltip.global_position = get_global_mouse_position() + Vector2(0, -145)
	elif(tooltip.is_visible_in_tree() && top_right):
		tooltip.global_position = get_global_mouse_position() + Vector2(-250, 0)

func _on_btn_mouse_entered(index: int) -> void:
	tooltip.show()
	var attraction_name = ATTRACTION_DATA[index].name
	var attraction_rating = ATTRACTION_DATA[index].attractiveness
	if(index < 3):
		var spending_max = ATTRACTION_DATA[index].spending_max
		var spending_min =  ATTRACTION_DATA[index].spending_min
		tooltip_label.text = attraction_name + "\n" + "Income: $" + str(spending_min) + "-" + str(spending_max) + "\n" +"Park rating +" + str(attraction_rating)
	else:
		tooltip_label.text = attraction_name + "\n" + "Park rating +" + str(attraction_rating)

func _on_btn_mouse_exited() -> void:
	top_right = false
	tooltip.hide()


func show_tooltip(message: String) -> void:
	top_right = true
	tooltip.show()
	tooltip_label.text = message
	
