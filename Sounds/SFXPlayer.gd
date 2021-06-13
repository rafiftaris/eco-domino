extends AudioStreamPlayer

var score = preload("res://Sounds/Assets/sound score.ogg")
var button_click = preload("res://Sounds/Assets/zapsplat_multimedia_click_003_19369.ogg")
var wrong = preload("res://Sounds/Assets/suara jika salah.ogg")

enum{SCORE,CLICK,WRONG}

func _ready():
	pass

func play_sfx(type):
	if type == SCORE:
		set_stream(score)
	elif type == CLICK:
		set_stream(button_click)
	elif type == WRONG:
		set_stream(wrong)
	play()
