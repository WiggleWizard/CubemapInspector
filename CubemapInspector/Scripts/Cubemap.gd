extends Spatial

export var bound_scale = 0.99;

var m = SpatialMaterial.new()

signal fov_changed;
signal cubemap_side_button_clicked;


func _ready():
	m.flags_unshaded = true;
	m.flags_use_point_size = true;
	m.albedo_color = Color(1.0, 1.0, 1.0, 1.0);
	
	$FakeCubemap/CubemapSideButtons.spawn_cubemap_side_buttons();
	$FakeCubemap/CubemapSideButtons.fade_to(1);

func _draw_bounds():
	# Base points that will be transformed later
	var box_points = Array();
	box_points.append(Vector3(-1.0, 1.0, 1.0));
	box_points.append(Vector3(1.0, 1.0, 1.0));
	box_points.append(Vector3(1.0, -1.0, 1.0));
	box_points.append(Vector3(-1.0, -1.0, 1.0));

	# Construct a box of points
	var p = Array();
	for i in range(4):
		var transformed_points = Array();
		for line_index in range(box_points.size()):
			var transformed_point = box_points[line_index].rotated(Vector3(0.0, 1.0, 0.0), deg2rad(i * 90));
			transformed_points.append(transformed_point);
			
		for point in _create_closed_loop_from_points(transformed_points):
			p.append(point);

	var im = $Bounds;
	im.set_material_override(m);
	
	im.clear();
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null);
	for x in p:
		im.add_vertex(x * bound_scale);
	im.end()

func _clear_bounds():
	var im = $Bounds;
	im.clear();

func _create_closed_loop_from_points(points):
	var lines = Array();
	var index = 0;
	while(true):
		lines.append(points[index]);
		var next_index = index + 1;
		if next_index >= points.size():
			next_index = 0;
		lines.append(points[next_index]);
		
		index = index + 1;
		
		if index >= points.size():
			break;
			
	return lines;
	
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
		
func set_labels_visibility(toggle):
	$FakeCubemap/CubemapSideButtons.visible = toggle;