extends Node2D

var card = preload("res://Card/Card.tscn")

var card_display = []
var offset_x = 16
var offset_y = 92
var gap_size = 0

var pos_x = 0
var pos_y = 0
var new_card

func _ready():
	pass

func _init():
	for i in range(Global.card_row):
		card_display.append([])
		for j in range(Global.card_column):
			pos_x = offset_x + j*(Global.tile_size + gap_size)
			pos_y = offset_y + i*(Global.tile_size + gap_size)
			
			new_card = card.instance()
			new_card.init(randi()%Global.max_hierarchy,Global.CardPosition.DOWN)
			new_card.set_card_pos(top,bot)
			add_child(new_tile)
			
			tiles[i].append(new_tile)
