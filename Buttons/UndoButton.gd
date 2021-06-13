extends TextureButton

func _ready():
	set_disabled(true)
	set_visible(false)

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled and not disabled:
		SfxPlayer.play_sfx(SfxPlayer.CLICK)
		emit_signal("pressed")
		set_disabled(true)
		set_visible(false)
