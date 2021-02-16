extends Node2D

export var level = "sawah"

func _ready():
	Global.input_enabled = true
	level = Global.current_type
	$Background.set_texture(Global.background[level])
