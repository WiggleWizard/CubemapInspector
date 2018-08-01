extends ImmediateGeometry

export var bound_scale = 0.99;

var _material = SpatialMaterial.new()


func _ready():
	_material.flags_unshaded = true;
	_material.flags_use_point_size = true;
	_material.albedo_color = Color(1.0, 1.0, 1.0, 1.0);
	
func draw_bounds():
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

	set_material_override(_material);
	
	clear();
	begin(Mesh.PRIMITIVE_LINE_STRIP, null);
	for x in p:
		add_vertex(x * bound_scale);
	end();

func clear_bounds():
	clear();

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