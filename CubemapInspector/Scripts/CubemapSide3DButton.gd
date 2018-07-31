extends Sprite3D

var side;
var fade_speed = 0.2;

var _fade_target = 0.0;

func _ready():
	var mat = material_override;
	mat.albedo_color.a = 0.0;

func fade_to(fade_target):
	_fade_target = fade_target;
	
func set_texture(new_texture):
	texture = new_texture;
	
func _process(delta):
	var mat = material_override;
	if mat.albedo_color.a == _fade_target:
		return;
	
	var alpha = mat.albedo_color.a;
	if alpha > _fade_target:
		alpha -= delta * fade_speed;
		if alpha < _fade_target:
			alpha = _fade_target;
	elif alpha < _fade_target:
		alpha += delta * fade_speed;
		if alpha > _fade_target:
			alpha = _fade_target;
			
	mat.albedo_color.a = alpha;