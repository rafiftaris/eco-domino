extends TextureButton

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled:
		_pressed()

func _pressed():
	Global.reset_score()
	SfxPlayer.play_sfx(SfxPlayer.CLICK)
	emit_signal("pressed")
