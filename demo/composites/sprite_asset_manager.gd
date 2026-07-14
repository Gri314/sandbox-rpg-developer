extends AssetManager

func attempt_open_file(file):
	print("Attempting to open file: " + path_ind.text + "/" + file)
	target._set_sprite(path_ind.text + "/" + file)
