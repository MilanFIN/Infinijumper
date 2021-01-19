shader_type canvas_item;



void fragment(){

	float time = fract(TIME*0.5);
	
	if (time >= 0.5) {
		time = 1.0 - time;
	}
	if (time <= 0.20) {
		time = 0.20;
	}
	vec4 colorModulator = vec4(1.0,1.0,1.0,time);
	COLOR = texture(TEXTURE, UV) * colorModulator;
	
}
