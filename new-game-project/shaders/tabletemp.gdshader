shader_type canvas_item;

uniform sampler2D tex:
	repeat_enable;
uniform float horizon = 0.3;

void fragment() {
	vec2 uv = UV;

	float z = mix(1.0,1.0 / horizon, 1.0 - uv.y);
	vec2 warped;
	warped.x = (uv.x - 0.5) / z + 0.5;
	warped.y = (uv.y) / z;
	uv = warped;
	
	vec4 tex_to_vec = texture(tex, uv);
	COLOR = tex_to_vec + vec4(.4,0.02,0.02,0);
}
