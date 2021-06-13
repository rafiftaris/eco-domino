extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

func _on_Timer_timeout():
	$VideoPlayer.play()

func _on_VideoPlayer_finished():
	$Timer.start(3)
