extends Label

var is_penalty = false
var countdown_seconds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_timer():
	countdown_seconds = Global.timer_minute*60 + Global.timer_seconds
	set_display()

func set_penalty(penalty):
	is_penalty = penalty
	if is_penalty:
		add_color_override("font_color",Color(1,0,0,1))

func update_timer():
	if is_penalty:
		countdown_seconds += 1
	else:
		countdown_seconds -= 1
	set_display()

func set_display():
	var text_minute = ""
	var text_second = ""
	if countdown_seconds/60 < 10:
		text_minute += "0"
	text_minute += str(countdown_seconds/60)
	if countdown_seconds%60 < 10:
		text_second += "0"
	text_second += str(countdown_seconds%60)
	set_text(text_minute + ":" + text_second)
