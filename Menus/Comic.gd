extends Control

onready var tween = get_node("Tween")
onready var comic = [
	get_node("ComicSlide1"),
	get_node("ComicSlide2"),
	get_node("ComicSlide3")
]
onready var timer = get_node("Timer")
var current_slide = 0

func _ready():
	Global.input_enabled = true
	BgmPlayer.set_bgm(BgmPlayer.COMIC)

func _on_NextButton_pressed():
	if current_slide < 2:
		next_slide()
		timer.start()
	else:
		Transit.change_scene("res://Menus/MainMenu2.tscn")

func next_slide():
	tween.interpolate_property(
		comic[0],"position",
		comic[0].position,
		comic[0].position - Vector2(2220,0),
		1
	)
	tween.interpolate_property(
		comic[1],"position",
		comic[1].position,
		comic[1].position - Vector2(2220,0),
		1
	)
	tween.interpolate_property(
		comic[2],"position",
		comic[2].position,
		comic[2].position - Vector2(2220,0),
		1
	)
	tween.start()
	current_slide += 1


func _on_Timer_timeout():
	$NextButton.set_disabled(false)
