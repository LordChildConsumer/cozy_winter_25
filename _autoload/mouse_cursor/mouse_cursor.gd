extends CanvasLayer;

enum TEXTURE {
	DEFAULT,
	SELECT,
	BUILD,
	DEMOLISH,
}
const TEXTURE_DATA: Dictionary = {
	TEXTURE.DEFAULT: {
		"texture": preload("res://_autoload/mouse_cursor/cursors/pointer_toon_a.png"),
		"offset": Vector2(11.0, 11.0),
	},
	TEXTURE.SELECT: {
		"texture": preload("res://_autoload/mouse_cursor/cursors/hand_point.png"),
		"offset": Vector2(8.0, 11.0),
	},
	TEXTURE.BUILD: {
		"texture": preload("res://_autoload/mouse_cursor/cursors/tool_hammer.png"),
		"offset": Vector2(7.0, 7.0),
	},
	TEXTURE.DEMOLISH: {
		"texture": preload("res://_autoload/mouse_cursor/cursors/tool_bomb.png"),
		"offset": Vector2(7.0, 7.0),
	},
};


@onready var sprite := $Sprite;


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	_set_texture(TEXTURE.DEFAULT);


func _process(delta: float) -> void:
	sprite.rotation_degrees = -7.5 if Input.is_mouse_button_pressed(
			MOUSE_BUTTON_LEFT  ) else 0.0;
	
	sprite.global_position = sprite.get_global_mouse_position();


func _set_texture(id: TEXTURE) -> void:
	sprite.set_texture(TEXTURE_DATA[id]["texture"]);
	sprite.set_offset(TEXTURE_DATA[id]["offset"]);


func default() -> void: 	_set_texture(TEXTURE.DEFAULT);
func select() -> void:		_set_texture(TEXTURE.SELECT);
func build() -> void:		_set_texture(TEXTURE.BUILD);
func demolish() -> void:	_set_texture(TEXTURE.DEMOLISH);
