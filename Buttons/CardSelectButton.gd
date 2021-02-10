extends TextureButton

signal card_selected(card)

var level = -1
var row = -1
var column = -1

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
	set_normal_texture(Global.button_normal[level])
	set_pressed_texture(Global.button_pressed[level])
	
func set_blank():
	self.level = -1
	set_normal_texture(Global.button_blank_normal)
	set_pressed_texture(Global.button_blank_pressed)

func _pressed():
	set_pressed(true)
	if self.level == -1:
		set_pressed(false)
	else:
		emit_signal("card_selected",self)

func hint_highlight(flag):
	if flag:
		set_normal_texture(Global.button_hinted[level])
	else:
		set_normal_texture(Global.button_normal[level])

