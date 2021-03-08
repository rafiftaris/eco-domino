extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.input_enabled = true
	BgmPlayer.set_bgm(BgmPlayer.MAIN_MENU)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
