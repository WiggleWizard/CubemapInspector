extends Spatial

var cube_side_map = [
	{"Side": "Down",   "Position": Vector3(0.0, -1.0, 0.0), "Instance": null},
	{"Side": "Up",     "Position": Vector3(0.0, 1.0, 0.0),  "Instance": null},
	{"Side": "Right",  "Position": Vector3(-1.0, 0.0, 0.0), "Instance": null},
	{"Side": "Left",   "Position": Vector3(1.0, 0.0, 0.0),  "Instance": null},
	{"Side": "Front",  "Position": Vector3(0.0, 0.0, 1.0),  "Instance": null},
	{"Side": "Back",   "Position": Vector3(0.0, 0.0, -1.0), "Instance": null},
];


func fade_to(fade_opacity):
	for cube_side in cube_side_map:
		cube_side["Instance"].fade_to(fade_opacity);

func spawn_cubemap_side_buttons():
	var scene = preload("res://Scenes/CubemapSide3DButton.tscn");
	
	for cube_side in cube_side_map:
		var instance = scene.instance();
		instance.translate(cube_side["Position"]);
		instance.side = cube_side["Side"];
		var new_texture = load("res://Textures/CubemapButton" + instance.side.substr(0, 1) + ".png");
		instance.set_texture(new_texture);
		add_child(instance);

		cube_side["Instance"] = instance;