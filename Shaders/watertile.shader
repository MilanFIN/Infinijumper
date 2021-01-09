shader_type canvas_item;

//didnt work
//uniform vec4 waterColorModulator = vec4(1.0,1.0,1.0,0.5); //0.5
uniform float speed = 0.2;


void fragment(){
	//didnt work, simpler below
	//COLOR = texture(TEXTURE, UV) * waterColorModulator;
	//make water have opacity
	COLOR.a *= 0.7;
	
	//scroll water texture to animate, 0.75 is 3/4 of the length of the image, 
	//which results in correctly scrolling through the 3 tiles
	float time = TIME;
	float uvMod = mod(time*speed, 0.75);
    COLOR.rgb = texture(TEXTURE, vec2(UV.x + uvMod, UV.y)).rgb;

}





