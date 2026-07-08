class_name AssetManager extends Window

## When called, the thing which requested the resource
@export var target: Node

## Implementation of a history system
## also used for navigating file structure
@onready var hist = {
	"time" = 0,
	"list" = ["res://"]
}

## Necessary for simple logic
@onready var path_ind = $vbox/bott_hbox/path
@onready var error_disp = $vbox/scroller/list/error_disp
@onready var listy = $vbox/scroller/list

## must be loaded to be instantiated as list items
const item_inst = preload("res://demo/composites/bricks/item.tscn")

## When you press the "X"
func _on_close_requested():
	self.visible = false



## History data structure operations
func new_hist(path):
	hist["list"].append(path)
	hist["time"] = len(hist["list"])
func pop_hist():
	hist.pop()
func load_from_hist():
	pass



## Basic error demonstration
func show_error(text: String):
	listy.visible = false
	error_disp.visible = true
	error_disp.text = text

## Folders get opened and searched
func attempt_open_directory(dir):
	print(dir)
## Files are sent back to the target (like an upload)
func attempt_open_file(file):
	print(file)

## Populate the list with item instances of the things found in the folder
func populate_list(dirs = PackedStringArray([]), files = PackedStringArray([])):
	for dir in dirs:
		var current = item_inst.instantiate()
		current.set_text("📁 " + dir, dir)
		current.type = "dir"
		listy.add_child(current)
		current.request_signal_connect(attempt_open_directory)
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
	for child in listy.get_children().slice(1):
		if child.type == "dir":
			child.request_signal_disconnect(attempt_open_directory)
		else:
			child.request_signal_disconnect(attempt_open_file) 
		child.queue_free() ## delete from queue


## Macro function to refresh for the user
func _on_repopulate_pressed():
	## ensure error messager is not visible
	error_disp.visible = false
	
	depopulate_list()
	
	## determine if the path is valid
	if path_ind.text == "":
		show_error("No filepath given.")
		return null
	
	## summarize files & directories at a given path
	var dirs  = DirAccess.get_directories_at(path_ind.text)
	var files = DirAccess.get_files_at(path_ind.text)
	
	if files == PackedStringArray([]) && dirs == PackedStringArray([]):
		show_error("Filepath empty.")
	
	populate_list(dirs, files)
	
	
