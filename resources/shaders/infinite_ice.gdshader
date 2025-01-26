shader_type canvas_item;

uniform vec2 camera_position = vec2(0.0);

void fragment() {
	COLOR = texture(
		TEXTURE,
		SCREEN_UV + camera_position * SCREEN_PIXEL_SIZE
	);
}