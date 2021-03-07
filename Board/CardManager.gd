extends Node2D

var card = preload("res://Buttons/CardSelectButton.tscn")

var card_display = []
var offset_x = 875
var offset_y = 50
var gap_x = 75
var gap_y = 125

var pos_x = 0
var pos_y = 0
var new_card
var selected_card = {
	"row": -1,
	"column": -1,
	"level": -1,
	"animal_name": null,
}
var levels = [
	[1],
	[2,1]
]
signal card_selected(card)

func _init():
	for i in range(Global.card_row):
		card_display.append([])
		for j in range(Global.card_column):
			if i == 0 and j == 1:
				continue
			pos_x = offset_x + j*(Global.tile_size + gap_x)
			pos_y = offset_y + i*(Global.tile_size + gap_y)
			if i == 0:
				pos_x = offset_x + (j + 0.5)*(Global.tile_size + gap_x)

			new_card = card.instance()
			new_card.init(levels[i][j],i,j)
			new_card.set_position(Vector2(pos_x,pos_y))
			new_card.connect("card_selected",self,"_on_card_selected")
			add_child(new_card)

			card_display[i].append(new_card)

func _on_card_selected(card):
	if selected_card.row != -1:
		card_display[selected_card.row][selected_card.column].set_pressed(false)
		if card.row != selected_card.row or card.column != selected_card.column:
			select_card(card.row,card.column,card.level,card.get_node("Card").animal_name)
		else:
			select_card(-1,-1,-1,null)
	else:
		select_card(card.row,card.column,card.level,card.get_node("Card").animal_name)
	get_parent().get_node("TilesManager").set_enable(card.is_pressed())

func select_card(row,column,level,animal_name):
	selected_card.row = row
	selected_card.column = column
	selected_card.level = level
	selected_card.animal_name = animal_name
	if row == -1:
		Global.selected_card = null
	else:
		Global.selected_card = selected_card

func reset_all_buttons(replace):
	for card_row in card_display:
		for card in card_row:
			card.set_pressed(false)
			card.hint_highlight(false)

func reset_button(replace):
	card_display[selected_card.row][selected_card.column].set_pressed(false)
	card_display[selected_card.row][selected_card.column].hint_highlight(false)
	if replace:
		# Get random level
		var available_level = Global.available_level
		var new_level = available_level[randi() % available_level.size()]
		var card_choices = Global.card_stock[new_level]
		while card_choices.size() == 0 and available_level.size() > 0:
			available_level.erase(new_level)
			if available_level.size() == 0:
				continue
			new_level = available_level[randi() % available_level.size()]
			card_choices = Global.card_stock[new_level]
		
		if available_level.size() == 0 and card_choices.size() == 0:
			new_level = -1
		
		card_display[selected_card.row][selected_card.column].set_level(new_level)
#		print("new card level: %s" % new_level)
	select_card(-1,-1,-1,null)
