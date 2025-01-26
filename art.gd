extends CanvasLayer

@onready var iceberg_animation_player = $AnimationPlayer
@onready var day_iceberg = $Iceberg
@onready var night_iceberg = $Iceberg2

var is_night_iceberg = false

func _ready() -> void:
	ParkData.park_emptied.connect(flip_day_iceberg)
	TimeTracker.park_opened.connect(flip_night_iceberg)

func flip_day_iceberg():
	
	is_night_iceberg = true
	iceberg_animation_player.play("flip_iceberg_to_night")
	await iceberg_animation_player.animation_finished
	day_iceberg.hide()
	night_iceberg.show()
	
func flip_night_iceberg():
	if(!is_night_iceberg):
		return
	is_night_iceberg = false
	iceberg_animation_player.play("flip_iceberg_to-day")
	await iceberg_animation_player.animation_finished
	night_iceberg.hide()
	day_iceberg.show()
	iceberg_animation_player.play("RESET");
