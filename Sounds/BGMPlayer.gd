extends AudioStreamPlayer

var ingame = preload("res://Sounds/Assets/backsound game(bensound-jazzcomedy) (online-audio-converter.com).ogg")
var main_menu = preload("res://Sounds/Assets/Intro (online-audio-converter.com).ogg")

enum{MAIN_MENU,INGAME}
var state = null
var is_muted = true

func set_bgm(state):
	if self.state == state or is_muted:
		return
		
	stop()
	if state == MAIN_MENU:
		set_stream(main_menu)
		play()
	elif state == INGAME:
		set_stream(ingame)
		play()
	self.state = state
