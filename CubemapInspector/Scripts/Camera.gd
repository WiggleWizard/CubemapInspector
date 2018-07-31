extends Camera

export var camera_speed = 5.0;
export var fov_scroll_speed = 5;

var enable_camera_rot = false;

signal fov_changed;
signal enabled_camera_rotation;
signal cubemap_side_button_clicked;


func _input(event):
	# Player is moving mouse
	if event is InputEventMouseMotion && enable_camera_rot:
		rotate(Vector3(0.0, 1.0, 0.0), event.relative.x / -1000.0 * camera_speed);
		
		var local_rotation = get_rotation();
		local_rotation.x = clamp(local_rotation.x + event.relative.y / -1000.0 * camera_speed, deg2rad(-89.9), deg2rad(90));
		set_rotation(local_rotation);

	elif event is InputEventMouseButton:
		# Player left clicks in the world
		if event.button_index == 1 && !event.is_pressed():
			var from = project_ray_origin(event.position);
			var to   = from + project_ray_normal(event.position) * 10.0;
			
			var space_state = get_world().direct_space_state;
			var hit_result  = space_state.intersect_ray(from, to);
			if hit_result.size() > 0:
				var parent = hit_result.collider.get_owner();
				emit_signal("cubemap_side_button_clicked", parent);
			
		# Player holds right click then enable camera rotation
		if event.button_index == 2:
			if event.is_pressed():
				enable_camera_rot = true;
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
			else:
				enable_camera_rot = false;
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			
			#emit_signal("enabled_camera_rotation", enable_camera_rot);
				
		# Scroll up and down
		if event.button_index == 4 && event.is_pressed():
			fov -= fov_scroll_speed;
			fov = clamp(fov, 30, 120);
			emit_signal("fov_changed", fov);
		if event.button_index == 5 && event.is_pressed():
			fov += fov_scroll_speed;
			fov = clamp(fov, 30, 120);
			emit_signal("fov_changed", fov);
				
	elif event is InputEventKey:
		# Player let go of the ESC key
		if !event.is_pressed() && event.scancode == KEY_ESCAPE:
			get_tree().quit();
