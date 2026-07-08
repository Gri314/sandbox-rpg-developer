extends Control

@export var current_scene: Node2D

@onready var windows = $Windows

func _on_refresh_pressed():
	## refresh everything that needs to be refreshed
	pass

func _on_popup_pressed():
	for obj in windows.get_children():
		obj.visible = true
