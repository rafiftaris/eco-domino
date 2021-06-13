extends TextureButton

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and not disabled:
		_pressed()

func _pressed():
	SfxPlayer.play_sfx(SfxPlayer.CLICK)
	var is_muted = BgmPlayer.is_muted
	BgmPlayer.set_mute(!is_muted)
