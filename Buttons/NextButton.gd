extends TextureButton

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and not disabled:
		SfxPlayer.play_sfx(SfxPlayer.CLICK)
		disabled = true
		emit_signal("pressed")
