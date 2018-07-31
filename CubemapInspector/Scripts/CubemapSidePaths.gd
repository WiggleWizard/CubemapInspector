extends Node

var cube_side_map = [
	{"side": "Down",   "path_suffixes": [ "dn" ]},
	{"side": "Up",     "path_suffixes": [ "up" ]},
	{"side": "Right",  "path_suffixes": [ "rt" ]},
	{"side": "Left",   "path_suffixes": [ "lf" ]},
	{"side": "Front",  "path_suffixes": [ "ft" ]},
	{"side": "Back",   "path_suffixes": [ "bk" ]},
];

func side_in_path(path):
	var path_split = path.split("_");
	for cube_side in cube_side_map:
		for path_suffix in cube_side.path_suffixes:
			if path_split[path_split.size() - 1].begins_with(path_suffix):
				return cube_side;