extends Node

class CardBotReference:
	var row: int
	var column: int
	var level: int
	
	func _init(level):
		self.level = level

const button_blank_normal = preload("res://Buttons/Assets/CardSelect/card-select-button-template.png")
const button_normal = [
	preload("res://Buttons/Assets/CardSelect/button-0-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-1-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-2-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-3-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-4-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-5-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-6-normal.png")
]

const button_blank_pressed = preload("res://Buttons/Assets/CardSelect/card-pressed-button-template.png")
const button_pressed = [
	preload("res://Buttons/Assets/CardSelect/button-0-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-1-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-2-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-3-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-4-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-5-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-6-pressed.png")
]

const button_blank_hinted = preload("res://Buttons/Assets/CardSelect/card-highlight-button-template.png")
const button_hinted = [
	preload("res://Buttons/Assets/CardSelect/button-0-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-1-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-2-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-3-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-4-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-5-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-6-highlight.png")
]

var tile_size = 99
var board_row = 5
var board_column = 8
var card_row = 2
var card_column = 2
var max_hierarchy = 7
var input_enabled = true
var use_hint = false
enum CardPosition {UP,RIGHT,DOWN,LEFT}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
