extends Node2D

func place_mark(position):
	var new_mark = Sprite.new()
	new_mark.set_texture(Global.x_mark)
	new_mark.set_position(position)
	add_child(new_mark)