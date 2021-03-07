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
var animal_name = ""

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
		var animal_name = Global.selected_card["animal_name"]
		level = Global.selected_card["level"]
		$Top.set_texture(Global.cards[Global.current_type]["top"][level][animal_name])
		$Bot.set_texture(
			Global.cards[Global.current_type]["bot"][
				(level+1) % Global.max_hierarchy[
					Global.current_type
				]]
		)
		self.animal_name = animal_name
	else:
		self.level = level
		var choices = Global.card_stock[level]
		var randomizer = randi() % choices.size()
		var animal_name = choices[randomizer]
		var bot_level = (level+1) % Global.max_hierarchy[Global.current_type]
		
		$Top.set_texture(Global.current_cards["top"][level][animal_name])
		$Bot.set_texture(Global.current_cards["bot"][bot_level])
		self.animal_name = animal_name
	Global.card_stock[level].erase(self.animal_name)

func get_bot_level():
	return (level+1)%Global.max_hierarchy[Global.current_type]

func rotate_card(card_rot):
	self.card_rotation = card_rot

func set_card_pos(top, bot):
	$Top.set_position(Vector2(top.x,top.y))
	$Bot.set_position(Vector2(bot.x,bot.y))

func set_reversed(flag):
	if flag:
		var bot_texture = $Bot.get_texture()
		$Bot.set_texture($Top.get_texture())
		$Top.set_texture(bot_texture)
	self.is_reversed = flag

func x_mark():
	$Top.modulate.g = 0.5
	$Top.modulate.b = 0.5
	$Bot.modulate.g = 0.5
	$Bot.modulate.b = 0.5
