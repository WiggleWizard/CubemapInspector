extends Control

var side_selected = "";

onready var file_dialog = $UI/FileDialog;


func _ready():
	file_dialog.clear_filters();
	file_dialog.add_filter("*.png ; PNG Image Files");
	file_dialog.add_filter("*.jpg ; JPEG Image Files");
	file_dialog.add_filter("*.tga ; Targa Image Files");
	
func _on_cubemap_load_pressed():
	file_dialog.popup();

func _on_show_bounds_toggled(button_pressed):
	if button_pressed:
		$ViewportContainer/Viewport/Scene._draw_bounds();
	else:
		$ViewportContainer/Viewport/Scene._clear_bounds();
		
func _on_show_labels_toggled(button_pressed):
	$ViewportContainer/Viewport/Scene.set_labels_visibility(button_pressed);
	
func _on_fov_changed(new_fov):
	$UI/StatusBar/FoV.text = "FoV: " + str(new_fov);

func _on_cubemap_side_button_clicked(node):
	side_selected = node.side;
	file_dialog.mode = FileDialog.MODE_OPEN_FILE;
	file_dialog.popup();

func _on_load_cubemap_pressed():
	file_dialog.mode = FileDialog.MODE_OPEN_FILES;
	file_dialog.popup();
	
func _on_FileDialog_file_selected(path):
	print("User selected file: " + path);
	
	var texture = ImageTexture.new();
	var img = Image.new();
	img.load(path);
	texture.create_from_image(img, Texture.FLAG_MIRRORED_REPEAT);

	$ViewportContainer/Viewport/Scene.set_cubemap_side_texture(side_selected, texture);

	side_selected = "";
		
func _on_FileDialog_files_selected(paths):
	print("User selected paths: " + paths.join(", "));
	
	for path in paths:
		var cube_side = $CubemapSidePaths.side_in_path(path);
		if cube_side:
			print("Using " + path + " for " + cube_side.side);
			
			var texture = ImageTexture.new();
			var img = Image.new();
			img.load(path);
			texture.create_from_image(img, Texture.FLAG_MIRRORED_REPEAT);
		
			$ViewportContainer/Viewport/Scene.set_cubemap_side_texture(cube_side.side, texture);
