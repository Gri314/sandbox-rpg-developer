extends Control

@export var current_scene: Node2D

@onready var windows = $Windows

func _on_refresh_pressed():
	## refresh everything that needs to be refreshed
	pass

func _on_popup_pressed():
	## if windows are hidden, show them all 
	for obj in windows.get_children():
		obj.visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_QUOTELEFT:
			self.visible = not self.visible
