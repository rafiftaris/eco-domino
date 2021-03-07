extends Node2D

func place_mark(position):
	var new_mark = Sprite.new()
	new_mark.set_texture(Global.x_mark)
	new_mark.set_position(position)
	new_mark.set_centered(false)
	new_mark.modulate.a = 0.5
#	add_child(new_mark)
