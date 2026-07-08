extends Control

@export var current_scene: Node2D

@onready var window = $Window

func update_popup_position():
	window.position = 0.5*self.size

func _ready():
	## ensure window is centered
	update_popup_position()

func _on_refresh_pressed():
	current_scene.refresh()

func _on_popup_pressed():
	window.visible = not window.visible
