extends AudioStreamPlayer

var ingame = preload("res://Sounds/Assets/backsound game(bensound-jazzcomedy) (online-audio-converter.com).ogg")
var main_menu = preload("res://Sounds/Assets/Intro (online-audio-converter.com).ogg")
var comic = preload("res://Sounds/Assets/bacsound komik.ogg")

enum{MAIN_MENU,INGAME,COMIC}
var state = null
var is_muted = false

func _ready():
	pass

func set_bgm(state):
	if self.state == state:
		return
		
	stop()
	if state == MAIN_MENU:
		set_stream(main_menu)
	elif state == INGAME:
		set_stream(ingame)
	elif state == COMIC:
		set_stream(comic)
	play()
	self.state = state
	

func set_mute(mute):
	self.is_muted = mute
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), self.is_muted)
