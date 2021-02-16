extends TextureButton

export var eco_type = ""

func _ready():
	$Label.set_text(("ekosistem " + eco_type).to_upper())
	var level_score = Global.save_dict[eco_type]["score"]
	var has_been_played = Global.save_dict[eco_type]["has_been_played"]
	if not has_been_played:
		$Label.set_size(Vector2($Label.get_size().x,110))
		$ScoreBoard.set_visible(false)
		$Score.set_visible(false)
	else:
		$Score.set_text(str(level_score))

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled:
		_pressed()

func _pressed():
	Global.current_type = eco_type
	get_tree().change_scene("res://Board/Level.tscn")
