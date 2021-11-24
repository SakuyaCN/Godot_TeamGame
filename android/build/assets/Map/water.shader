shader_type canvas_item;

uniform vec2 scale;
uniform float y_zoom;

uniform vec4 water_color :hint_color;
uniform vec4 water_color_top :hint_color;
uniform sampler2D noise;
uniform float intensity;
uniform vec2 dis_scale;
uniform float speed;

uniform float wave_amplitude;
uniform float wave_speed;
uniform float wave_period;

void fragment(){
	
	float waves = UV.y * scale.y + sin(UV.x * scale.x / wave_period - TIME * wave_speed) * cos(UV.x * 0.1 * scale.x / wave_period + TIME - wave_speed)
		* wave_amplitude - wave_amplitude;
	
	float dis = texture(noise,UV*scale*dis_scale + (TIME*speed)).x;
	dis -= 0.5;
	
	float uv_height = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 ref = vec2(SCREEN_UV.x - dis * intensity * y_zoom,SCREEN_UV.y + uv_height * UV.y * scale.y * y_zoom * 2.0);
	vec4 reflectoion = texture(SCREEN_TEXTURE,ref);
	COLOR.rgb = mix(reflectoion.rgb,water_color.rgb,water_color.a);
	COLOR.a = smoothstep(0.1,0.13,waves);
	
	//vec4 color = texture(SCREEN_TEXTURE, ref);
	//COLOR = mix(color, line_color, outline - color.a);
}