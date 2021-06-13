extends Node

export var loading_time = 4
var dots = ""

func _ready():
	$Timer.start()
	$LoadingHint.set_text("MEMUAT")

func _on_Timer_timeout():
	$ProgressBar.set_value($ProgressBar.get_value() + (100/5)/10)
	if int($ProgressBar.get_value()) % 10 == 0:
		dots += "."
		if len(dots) >= 4:
			dots = ""
		$LoadingHint.set_text("MEMUAT" + dots)
	if $ProgressBar.get_value() == 100:
		$Timer.stop()
		get_tree().change_scene("res://Menus/Comic.tscn")
