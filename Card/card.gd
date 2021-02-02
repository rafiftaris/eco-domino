extends Node2D
class_name Card

export var level = 0

func _onready():
	$Top.set_frame(level)
	$Bot.set_frame(level)
	print($Top.frame)
