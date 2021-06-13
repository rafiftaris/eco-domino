extends Node2D
class_name Card

const text_offset = 9
const card_scale = Vector2(1,1)
const max_x = 5
const min_x = -5
const preposition_vec = Vector2(0.5,0)

var current_x = 0
var going_right = true
var card_base_vector = Vector2(Global.tile_size,Global.tile_size)
var level = 0
var card_rotation
var row = -1
var column = -1
var is_reversed = false
var checked = false
var animal_name = ""

func _ready():
	pass

func init(level,card_pos,row,column):
	set_base()
	$Top.set_scale(card_scale)
	$Bot.set_scale(card_scale)
	set_level(level)
	rotate_card(card_pos)
	self.row = row
	self.column = column

func set_base():
	$BaseTop.set_texture(Global.card_base[Global.current_type])
	$BaseBot.set_texture(Global.card_base[Global.current_type])

func set_bot_text(level):
	if level == 0:
		$Bot.set_text("PRODUSEN")
	else:
		$Bot.set_text("KONSUMEN %s" % level)

func set_level(level):
	if level == null: # use selected card texture
		var animal_name = Global.selected_card["animal_name"]
		level = Global.selected_card["level"]
		$Top.set_texture(Global.cards[Global.current_type][level][animal_name])
		set_bot_text((level+1) % Global.max_hierarchy[Global.current_type])
		self.animal_name = animal_name
	else:
		self.level = level
		var choices = Global.card_stock[level]
		var randomizer = randi() % choices.size()
		var animal_name = choices[randomizer]
		var bot_level = get_bot_level()
		
		$Top.set_texture(Global.current_cards[level][animal_name])
		set_bot_text(bot_level)
		self.animal_name = animal_name
	Global.card_stock[level].erase(self.animal_name)

func get_bot_level():
	return (level+1)%Global.max_hierarchy[Global.current_type]

func rotate_card(card_rot):
	self.card_rotation = card_rot
	var texture_size = $BaseTop.get_texture().get_size()
	if card_rot == Global.CardPosition.DOWN:
		$BaseBot.set_position(Vector2(0,texture_size.y))
		$Bot.set_position(Vector2(text_offset,texture_size.y))
	elif card_rot == Global.CardPosition.UP:
		$BaseBot.set_position(Vector2(0,-texture_size.y))
		$Bot.set_position(Vector2(text_offset,-texture_size.y))
	elif card_rot == Global.CardPosition.LEFT:
		$BaseBot.set_position(Vector2(-texture_size.x,0))
		$Bot.set_position(Vector2(-texture_size.x + text_offset,0))
	elif card_rot == Global.CardPosition.RIGHT:
		$BaseBot.set_position(Vector2(texture_size.x,0))
		$Bot.set_position(Vector2(texture_size.x + text_offset,0))

func set_card_pos(top, bot):
	set_position(Vector2(top.x,top.y))

func x_mark():
	$BaseTop.modulate.g /= 2
	$BaseTop.modulate.b /= 2
	$Top.modulate.g /= 2
	$Top.modulate.b /= 2
	$BaseBot.modulate.g /= 2
	$BaseBot.modulate.b /= 2
	$Bot.modulate.g /= 2
	$Bot.modulate.b /= 2
	SfxPlayer.play_sfx(SfxPlayer.WRONG)

func set_animal(animal_data):
	self.level = animal_data.level
	self.animal_name = animal_data.animal_name
	$Top.set_texture(Global.current_cards[animal_data.level][animal_data.animal_name])
	set_bot_text(get_bot_level())
