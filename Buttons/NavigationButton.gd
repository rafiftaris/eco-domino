extends TextureButton

export var path_to_new_scene = ""

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled:
		_pressed()

func _pressed():
	get_tree().change_scene(path_to_new_scene)
