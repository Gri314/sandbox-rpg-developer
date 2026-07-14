class_name SpriteEdit extends EditButton

@export var ParentSprite: Sprite2D

@onready var aspect_locked = true
@onready var aspect_button: Button = $"configure sprite/scroller/vbox/item4/hbox/lock_aspect"

func _set_sprite(loc):
	var newtexture = load(loc)
	ParentSprite.texture = newtexture

func toggle_window_visibility():
	$"configure sprite".visible = not $"configure sprite".visible


func _on_lock_aspect_pressed():
	self.aspect_locked = not self.aspect_locked
	if aspect_locked:
		aspect_button.text = "🔒"
		$"configure sprite/scroller/vbox/gsize".visible = true
		$"configure sprite/scroller/vbox/xsize".visible = false
		$"configure sprite/scroller/vbox/ysize".visible = false
	else:
		aspect_button.text = "🔓"
		$"configure sprite/scroller/vbox/xsize".visible = true
		$"configure sprite/scroller/vbox/ysize".visible = true
		$"configure sprite/scroller/vbox/gsize".visible = false

func alter_sprite_position(_new_text):
	var xpos = float($"configure sprite/scroller/vbox/xpos/hbox/field".text)
	var ypos = float($"configure sprite/scroller/vbox/ypos/hbox/field".text)
	
	ParentSprite.position = Vector2(xpos,ypos)

func alter_gen_sprite_size(new_text):
	ParentSprite.scale = Vector2(float(new_text), float(new_text))

func alter_sprite_size(_new_text):
	var xsize = float($"configure sprite/scroller/vbox/xsize/hbox/field".text)
	var ysize = float($"configure sprite/scroller/vbox/ysize/hbox/field".text)
	
	ParentSprite.scale = Vector2(xsize, ysize)
