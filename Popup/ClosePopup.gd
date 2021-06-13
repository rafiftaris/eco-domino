extends TextureButton

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and not disabled:
		_pressed()
		
func _pressed():
	SfxPlayer.play_sfx(SfxPlayer.CLICK)
	emit_signal("pressed")
