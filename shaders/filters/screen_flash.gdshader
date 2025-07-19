shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 sum = vec3(281.0 / 256.0, 277.0 / 256.0, 261.0 / 256.0);
	vec4 pixel = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.rgb = min(vec3(1, 1, 1), sum - pixel.rgb);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
