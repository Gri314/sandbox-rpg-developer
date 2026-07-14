class_name EditButton extends Button

@export var Name: String = "<obj: edit_button>"

func _toggle_visibility() -> void:
	self.visible = not self.visible 

func _set_state(state: String):
	if state == "edit":
		## show utils
		self.visible = true
	elif state == "play":
		## hide utils
		self.visible = false
