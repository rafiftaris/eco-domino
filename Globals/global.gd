extends Node

class CardBotReference:
	var row: int
	var column: int
	var level: int
	
	func _init(level):
		self.level = level

var tile_size = 87
var board_row = 5
var board_column = 8
var card_row = 2
var card_column = 2
var max_hierarchy = 6
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
