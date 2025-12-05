shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float flashvalue : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = mix(pixelColor, flash_color, flashvalue);
	COLOR.a = pixelColor.a;
	}