shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D tex;


void fragment()
{
	ALBEDO.rgb = texture(tex, UV).rgb;
}