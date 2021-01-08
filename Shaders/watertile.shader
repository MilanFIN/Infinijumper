shader_type canvas_item;

uniform vec4 waterColorModulator = vec4(1.0,1.0,1.0,0.5);
void fragment(){
	COLOR = texture(TEXTURE, UV) * waterColorModulator;
}

