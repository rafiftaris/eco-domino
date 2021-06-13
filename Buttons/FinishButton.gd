extends TextureButton

signal finish_game

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and not disabled:
		_pressed()
		
func _pressed():
	set_pressed(true)
	SfxPlayer.play_sfx(SfxPlayer.CLICK)
	emit_signal("finish_game")
