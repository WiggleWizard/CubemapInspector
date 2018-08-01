extends Spatial

signal fov_changed;
signal cubemap_side_button_clicked;


func _ready():
	$FakeCubemap/CubemapSideButtons.spawn_cubemap_side_buttons();
	$FakeCubemap/CubemapSideButtons.fade_to(1);
	
	
func show_bounds(show_hide):
	if show_hide:
		$Bounds.draw_bounds();
	else:
		$Bounds.clear_bounds();
	
func set_labels_visibility(toggle):
	$FakeCubemap/CubemapSideButtons.visible = toggle;
	
	
func _on_fov_changed(new_fov):
	emit_signal("fov_changed", new_fov);

func set_cubemap_side_texture(side_name, texture):
	var node = get_node("FakeCubemap/" + side_name);
	if node:
		var mat = node.material_override;
		mat.set_shader_param("tex", texture);

func _on_cubemap_side_button_clicked(node):
	emit_signal("cubemap_side_button_clicked", node);

func _on_enabled_camera_rotation(enabled):
	if enabled:
		$FakeCubemap/CubemapSideButtons.fade_to(0.0);
	else:
		$FakeCubemap/CubemapSideButtons.fade_to(1);
		
