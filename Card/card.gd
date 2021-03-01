extends Node2D
class_name Card

var level = 0
var card_scale = Vector2(float(100)/64,float(100)/64)
var card_base_vector = Vector2(Global.tile_size,Global.tile_size)
var card_rotation
var row = -1
var column = -1
var is_reversed = false
var checked = false
var texture = null

func _ready():
	pass

func init(level,card_pos,row,column):
	$Top.set_scale(card_scale)
	$Bot.set_scale(card_scale)
	set_level(level)
	rotate_card(card_pos)
	self.row = row
	self.column = column

func set_level(level):
	if level == null: # use selected card texture
		$Top.set_texture(Global.selected_card["texture"])
		$Bot.set_texture(Global.current_card["bot"][(Global.selected_card["level"]+1) % Global.max_hierarchy[Global.current_type]])
		return
		
	self.level = level
#	$Top.set_frame(level%(Global.max_hierarchy[Global.current_type]))
#	$Bot.set_frame((level+1)%(Global.max_hierarchy[Global.current_type]))
	var choices = Global.current_card["top"][level]
	var randomizer = randi() % choices.size()
	$Top.set_texture(choices[randomizer])
	$Bot.set_texture(Global.current_card["bot"][(level+1) % Global.max_hierarchy[Global.current_type]])
	texture = $Top.get_texture()
	Global.current_card["top"][level].remove(randomizer)

func get_bot_level():
	return (level+1)%Global.max_hierarchy[Global.current_type]

func rotate_card(card_rot):
	self.card_rotation = card_rot

func set_card_pos(top, bot):
	$Top.set_position(Vector2(top.x,top.y))
	$Bot.set_position(Vector2(bot.x,bot.y))

func set_reversed(flag):
	if flag:
		$Top.set_frame((level+1)%(Global.max_hierarchy[Global.current_type]))
	$Bot.set_frame((level)%(Global.max_hierarchy[Global.current_type]))
	self.is_reversed = flag
