shader_type canvas_item;

const vec4 main_color = vec4(0.5, 0.5, 0.5, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = main_color;
	if (mod(UV.x,  1) < 0.1 || mod(UV.y,  1) < 0.1) {
		COLOR.rgb = COLOR.rgb * 0.9;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
