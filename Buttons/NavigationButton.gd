extends TextureButton

export var path_to_new_scene = ""
export var change_bgm = false

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled and not disabled:
		_pressed()

func _pressed():
	Transit.change_scene(path_to_new_scene)
	SfxPlayer.play_sfx(SfxPlayer.CLICK)
	if change_bgm:
		BgmPlayer.set_bgm(BgmPlayer.MAIN_MENU)
