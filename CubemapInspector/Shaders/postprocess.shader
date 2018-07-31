shader_type canvas_item;

uniform float lod;
uniform float bias;
uniform float scale;

uniform int ghost_count; // number of ghost samples
uniform float ghost_dispersal; // dispersion factor


vec3 feature_downsample(sampler2D tex, vec2 uv)
{
	vec3 bias3 = vec3(bias, bias, bias);
	vec3 scale3 = vec3(scale, scale, scale);
	
	vec2 texCoord = -uv + vec2(1.0);
	
	return max(vec3(0.0), textureLod(tex, texCoord, lod).rgb + bias3) * scale3;
}

vec4 ghost(sampler2D tex, vec2 uv)
{
	vec2 texcoord = -uv + vec2(1.0);
	vec2 texelSize = 1.0 / vec2(textureSize(tex, 0));
 
	vec2 ghostVec = (vec2(0.5) - uv) * ghost_dispersal;
   
	// sample ghosts:  
	vec4 result = vec4(0.0);
	for (int i = 0; i < ghost_count; ++i)
	{
		vec2 offset = fract(texcoord + ghostVec * float(i));
		result += texture(tex, offset);
	}
 
	return result;
}

void fragment()
{
	COLOR.rgb = feature_downsample(SCREEN_TEXTURE, SCREEN_UV).rgb;
}
