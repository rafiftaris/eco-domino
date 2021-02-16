extends Node2D
class_name Card

var level = 0
var card_scale = Vector2(1.7,1.7)
var card_base_vector = Vector2(Global.tile_size,Global.tile_size)
var card_rotation
var row = -1
var column = -1
var is_reversed = false
var checked = false

func _ready():
	pass

func init(level,card_pos,row,column):
	$Top.set_scale(card_scale)
#	$Top.set_position(card_base_vector*Vector2(0,-1))
	$Bot.set_scale(card_scale)
#	$Bot.set_position(card_base_vector*Vector2(0,1))
	set_level(level)
	rotate_card(card_pos)
	self.row = row
	self.column = column
	
func set_level(level):
	self.level = level
	$Top.set_frame(level%(Global.max_hierarchy))
	$Bot.set_frame((level+1)%(Global.max_hierarchy))

func get_bot_level():
	return (level+1)%Global.max_hierarchy

func rotate_card(card_rot):
	self.card_rotation = card_rot

func set_card_pos(top, bot):
	$Top.set_position(Vector2(top.x,top.y))
	$Bot.set_position(Vector2(bot.x,bot.y))

func set_reversed(flag):
	if flag:
		$Top.set_frame((level+1)%(Global.max_hierarchy))
	$Bot.set_frame((level)%(Global.max_hierarchy))
	self.is_reversed = flag
