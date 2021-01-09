shader_type canvas_item;

uniform vec4 waterColorModulator = vec4(1.0,1.0,1.0,0.5); //0.5
uniform float speed = 0.05;


void fragment(){

	COLOR = texture(TEXTURE, UV) * waterColorModulator;
	
	float time = TIME;
	float uvMod = mod(time*speed, 3.0/4.0);
    COLOR.rgb = texture(TEXTURE, vec2(UV.x + uvMod, UV.y)).rgb;

}





