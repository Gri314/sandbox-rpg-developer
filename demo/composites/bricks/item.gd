class_name item extends HBoxContainer

@onready var path: String
@onready var type: String

func set_text(disp_text: String, new_path: String):
	$name.text = disp_text
	path = new_path

func request_signal_connect(fn):
	$send.pressed.connect(fn.bind(path))

func request_signal_disconnect(fn):
	$send.pressed.disconnect(fn)
