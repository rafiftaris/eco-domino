extends TextureButton

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled and not disabled:
		_pressed()

func _pressed():
	SfxPlayer.play_sfx(SfxPlayer.CLICK)
	var kompetensi = get_parent().get_node("Kompetensi")
	kompetensi.set_visible(!kompetensi.visible)
	get_parent().disable_buttons(kompetensi.visible)
