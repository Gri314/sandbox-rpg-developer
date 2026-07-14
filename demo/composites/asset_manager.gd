class_name AssetManager extends Window

## When called, the thing which requested the resource
@export var target: Node

## Implementation of a history system
## also used for navigating file structure
@onready var hist = {
	"time" = -1,
	"list" = []
}

## Necessary for simple logic
@onready var path_ind = $vbox/bott_hbox/path
@onready var error_disp = $error_disp
@onready var listy = $vbox/scroller/list
@onready var searchbar = $vbox/top_hbox/search

## must be loaded to be instantiated as list items
const item_inst = preload("res://demo/composites/bricks/item.tscn")

## When you press the "X"
func _on_close_requested():
	self.visible = not self.visible

## History data structure operations
func new_hist(path):
	hist["list"].append(path)
	hist["time"] += 1
func load_from_hist(stage) -> String:
	return hist["list"][stage]



## Basic error demonstration
func show_error(text: String):
	listy.visible = false
	error_disp.visible = true
	error_disp.text = text

## Populate the list with item instances of the things found in the folder
func populate_list(dirs = PackedStringArray([]), files = PackedStringArray([])):
	for dir in dirs:
		var current = item_inst.instantiate()
		current.set_text("📁 " + dir, dir)
		current.type = "dir"
		listy.add_child(current)
		current.request_signal_connect(_on_opened_dir_button_pressed)
	for file in files:
		if ".import" not in file:
			var current = item_inst.instantiate()
			current.set_text("📃 " + file, file)
			listy.add_child(current)
			current.request_signal_connect(attempt_open_file)
			current.type = "file"
## Remove everything and snip the signal connections
func depopulate_list():
	## remove all from queue, except error msg (slot 0)
	for child in listy.get_children():
		if child.type == "dir":
			child.request_signal_disconnect(_on_opened_dir_button_pressed)
		else:
			child.request_signal_disconnect(attempt_open_file) 
		child.queue_free() ## delete from queue


## Macro function to refresh for the user
func _on_repopulate_pressed():
	## ensure error messager is not visible
	error_disp.visible = false
	listy.visible = true
	
	depopulate_list()
	
	## determine if the path is valid
	if path_ind.text == "":
		show_error("No filepath given.")
		return null
	if not DirAccess.dir_exists_absolute(path_ind.text): 
		show_error("No such directory exists.")
		return null
	
	## summarize files & directories at a given path
	var dirs  = DirAccess.get_directories_at(path_ind.text)
	var files = DirAccess.get_files_at(path_ind.text)
	
	## drop files not containing the search criteria
	if searchbar.text:
		var dirdrops = []
		var filedrops = []
		for i in range(0,len(dirs)):
			if not searchbar.text in dirs[i]:
				dirdrops.append(i)
		for i in range(0, len(files)):
			if not searchbar.text in files[i]:
				filedrops.append(i)
		
		for i in range(0, len(dirdrops)):
			dirs.remove_at(dirdrops[i]-i)
		for i in range(0, len(filedrops)):
			files.remove_at(filedrops[i]-i)
	
		if files == PackedStringArray([]) && dirs == PackedStringArray([]):
			show_error("Search returns no results.")
	
	## drop files not included in the filter options
	
	
	if files == PackedStringArray([]) && dirs == PackedStringArray([]):
		show_error("Filepath empty.")
	
	populate_list(dirs, files)



## Folders get opened and searched
## Called by: Submitted text field in `path` node
func attempt_open_directory(dir):
	new_hist(dir)
	path_ind.text = dir
	_on_repopulate_pressed()

## When pressing folder button, we need to get the current directory
## called by: pressing "open folder"
func _on_opened_dir_button_pressed(dir):
	var olddir = hist["list"][hist["time"]]
	var newdir: String
	if olddir[-1] == "/":
		newdir = olddir + dir
	else:
		newdir = olddir + "/" + dir
	attempt_open_directory(newdir)

## Files are sent back to the target (like an upload, not yet set up)
func attempt_open_file(file):
	print(file)

## Use the history to go backwards and forwards
func _on_back_pressed() -> void:
	attempt_open_directory(load_from_hist(hist["time"]-1))




## ready function: instantiate and begin the res folder
func _ready():
	path_ind.text = "res://"
	attempt_open_directory(path_ind.text)
