extends TextureButton

const hl_texture = preload("res://Buttons/Assets/Custom/TileSelectHighlight.png")
const normal_texture = preload("res://Buttons/Assets/Custom/TileSelect.png")

signal tile_selected(tile)

var row
var column
var highlight = false
var input_enabled = true

func _gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() and Global.input_enabled and input_enabled:
		_pressed()

func init(row, column):
	self.row = row
	self.column = column
	set_toggle_mode(true)

# Called when the node enters the scene tree for the first time. 
func _ready():
	set_size(Vector2(Global.tile_size,Global.tile_size))
	set_normal_texture(normal_texture)

func _pressed():
	set_pressed(true)
	emit_signal("tile_selected",self)

func set_highlight(flag):
	if flag:
		set_normal_texture(hl_texture)
	else:
		set_normal_texture(normal_texture)
	self.highlight = flag

func enable_input(enable):
	input_enabled = enable
