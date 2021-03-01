extends TextureButton

signal card_selected(card)

var level = -1
var row = -1
var column = -1
var is_hinted = false

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled:
		_pressed()

func _ready():
	pass

func init(level,row,column):
	set_toggle_mode(true)
	set_level(level)
	self.row = row
	self.column = column
	
func set_level(level):
	self.level = level
	if level == -1:
		$Card.set_visible(false)
		set_disabled(true)
	else:
		$Card.set_level(level)
	
func set_blank():
	self.level = -1
	set_normal_texture(Global.button_blank_normal)
	set_pressed_texture(Global.button_blank_pressed)

func _pressed():
	set_pressed(not is_pressed())
	if self.level != -1:
		emit_signal("card_selected",self)

func set_pressed(pressed: bool):
	if is_pressed() != pressed:
		simulate_press(pressed)
	.set_pressed(pressed)

func hint_highlight(flag):
	if flag:
		set_normal_texture(Global.button_blank_hinted)
		simulate_press(flag)
		is_hinted = true
	else:
		set_normal_texture(Global.button_blank_normal)
		if is_hinted:
			simulate_press(flag)
		is_hinted = false

func simulate_press(flag):
	var delta = Vector2(0,5)
	if not flag:
		delta *= -1
	$Card.set_position(Vector2($Card.get_position()) + delta)

