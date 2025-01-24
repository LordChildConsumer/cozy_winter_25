class_name Mortar extends StaticBody2D;

# Drop from spawn:		~500
# Fast Mash:			~4.7k
# Relaxed Mash: 		~1.5k
@export var mash_effecacy_curve: Curve;
@export var mash_strength: float = 20.0;


@onready var mash_progress_bar := $MashProgress;


func _on_stuff_body_entered(body: Node2D) -> void:
	if body is Pestle:
		var efficacy := get_pestle_efficacy(body as Pestle);
		mash_progress_bar.value += efficacy;
		
		## HACK: Scale stuff polygon just for funzies
		var aprog := inverse_lerp(
			mash_progress_bar.max_value,
			mash_progress_bar.min_value,
			mash_progress_bar.value
		);
		$Stuff/StuffSprite.scale = Vector2(aprog, aprog);
		


func get_pestle_efficacy(pestle: Pestle) -> float:
	var pestle_speed := pestle.linear_velocity.y;
	var offset := clampf(
		inverse_lerp(500, 4_500, pestle_speed),
		0.0,
		1.0
	);
	
	var efficacy := mash_effecacy_curve.sample(offset);
	return efficacy * mash_strength;
