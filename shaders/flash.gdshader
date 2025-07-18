shader_type canvas_item;

uniform bool is_on = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	if(is_on) {
		vec4 pixel = texture(TEXTURE, UV);
		COLOR.rgb = vec3(1, 1, 1) - pixel.rgb;
	}

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
