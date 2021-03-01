extends Node2D

export var level = "sawah"

func _init():
	print("initializing...")
	Global.input_enabled = true
	level = Global.current_type
	Global.set_current_card(level)
	Global.available_level = [1]

func _ready():
	$Background.set_texture(Global.background[level])
