extends TextureButton

signal give_hint

export var hint_count = 5

func _ready():
	update_text()

func update_text():
	$Counter.set_text(str(hint_count))
	
func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled and not disabled:
		_pressed()

func _pressed():
	Global.input_enabled = false
	set_pressed(true)
	emit_signal("give_hint")

func deduct_hint():
	hint_count -= 1
	update_text()
	set_pressed(false)
	if hint_count == 0:
		set_disabled(true)
