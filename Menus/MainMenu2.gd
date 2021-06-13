extends Control

onready var tween = get_node("Tween")
onready var cowo = get_node("Cowo")
onready var cewe = get_node("Cewe")
onready var play_button = get_node("PlayButton")
onready var info_button = get_node("InfoButton")
onready var how_to_play_button = get_node("HowToPlayButton")
onready var sound_button = get_node("SoundButton")
onready var exit_button = get_node("ExitButton")

var tween_duration = 1

func _ready():
	BgmPlayer.set_bgm(BgmPlayer.MAIN_MENU)
	if Global.from_comic:
		Global.input_enabled = true
		disable_buttons(true)
		$InfoButton.set_disabled(true)
		$SoundButton.set_disabled(true)
		$Timer.start()
		intro_tween()
		Global.from_comic = false
	else:
		cowo.set_position(Vector2(1962,cowo.position.y))
		cewe.set_position(Vector2(366,cewe.position.y))

func intro_tween():
	tween.interpolate_property(
		cowo, "position",
		cowo.position,
		Vector2(1962,cowo.position.y),
		tween_duration
	)
	tween.interpolate_property(
		cewe, "position",
		cewe.position,
		Vector2(366,cewe.position.y),
		tween_duration
	)
	tween.interpolate_property(
		play_button, "rect_scale",
		Vector2(0,0),
		Vector2(0.25,0.25),
		tween_duration
	)
	tween.interpolate_property(
		info_button, "rect_scale",
		Vector2(0,0),
		Vector2(0.2,0.2),
		tween_duration
	)
	tween.interpolate_property(
		how_to_play_button, "rect_scale",
		Vector2(0,0),
		Vector2(0.25,0.25),
		tween_duration
	)
	tween.interpolate_property(
		sound_button, "rect_scale",
		Vector2(0,0),
		Vector2(0.2,0.2),
		tween_duration
	)
	tween.interpolate_property(
		exit_button, "rect_scale",
		Vector2(0,0),
		Vector2(0.25,0.25),
		tween_duration
	)
	tween.start()

func disable_buttons(disable):
	$PlayButton.set_disabled(disable)
	$ExitButton.set_disabled(disable)
	$HowToPlayButton.set_disabled(disable)


func _on_Timer_timeout():
	disable_buttons(false)
	$InfoButton.set_disabled(false)
	$SoundButton.set_disabled(false)
