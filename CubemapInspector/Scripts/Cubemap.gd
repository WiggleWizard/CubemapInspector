extends Spatial

signal fov_changed;
signal cubemap_side_button_clicked;

var _cubemap_side_paths = {
	"Down":  {"texture_path": ""},
	"Up":    {"texture_path": ""},
	"Right": {"texture_path": ""},
	"Left":  {"texture_path": ""},
	"Front": {"texture_path": ""},
	"Back":  {"texture_path": ""},
};
var _state_file_path = "state";


func _ready():
	$FakeCubemap/CubemapSideButtons.spawn_cubemap_side_buttons();
	$FakeCubemap/CubemapSideButtons.fade_to(1);
	
	_restore_state();
	
	
func show_bounds(show_hide):
	if show_hide:
		$Bounds.draw_bounds();
	else:
		$Bounds.clear_bounds();
	
func set_labels_visibility(toggle):
	$FakeCubemap/CubemapSideButtons.visible = toggle;
	
	
func _on_fov_changed(new_fov):
	emit_signal("fov_changed", new_fov);

func set_cubemap_side_texture(side_name, texture_path):
	var node = get_node("FakeCubemap/" + side_name);
	if node:
		var texture = ImageTexture.new();
		var img = Image.new();
		img.load(texture_path);
		texture.create_from_image(img, Texture.FLAG_MIRRORED_REPEAT);
		
		var mat = node.material_override;
		mat.set_shader_param("tex", texture);
		
		_cubemap_side_paths[side_name].texture_path = texture_path;
		
		_store_state();

func _on_cubemap_side_button_clicked(node):
	emit_signal("cubemap_side_button_clicked", node);

func _on_enabled_camera_rotation(enabled):
	if enabled:
		$FakeCubemap/CubemapSideButtons.fade_to(0.0);
	else:
		$FakeCubemap/CubemapSideButtons.fade_to(1);
		
func _store_state():
	var file = File.new();
	if file.open(_state_file_path, File.WRITE) != 0:
		print("Error opening state file");
		return;
		
	file.store_line(JSON.print(_cubemap_side_paths, "\t"));
	file.close();

func _restore_state():
	var file = File.new();
	if file.open(_state_file_path, File.READ) != 0:
		print("Error opening state file");
		return;
		
	var file_data = file.get_as_text();
	var json_result = JSON.parse(file_data);
	if json_result.result:
		_cubemap_side_paths = json_result.result;
		
		for side in _cubemap_side_paths:
			var texture_path = _cubemap_side_paths[side].texture_path;
			if texture_path != "":
				set_cubemap_side_texture(side, texture_path);
		