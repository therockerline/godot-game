shader_type canvas_item;

varying vec2 vertex_pos[2];
uniform vec2 mouse_position;
uniform float tile_size;
uniform float is_selectable;

void vertex() {
	// Called for every vertex the material is visible on.
	vertex_pos[0] = (MODEL_MATRIX * vec4(VERTEX, 0., 1.)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float isWithinY = step(vertex_pos[0].y, mouse_position.y) * step(mouse_position.y, vertex_pos[0].y + tile_size);
	float isWithinX = step(vertex_pos[0].x, mouse_position.x) * step(mouse_position.x, vertex_pos[0].x + tile_size);
	float isWithin = isWithinY * isWithinX;
	vec4 textureColor = texture(TEXTURE, UV);
	vec4 mixColor = mix(textureColor,COLOR,  1.0);
	COLOR = mix(mixColor, vec4(1.,0,1.,1.), 0.7*isWithin*is_selectable);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
