extends Node2D

var card = preload("res://Buttons/CardSelectButton.tscn")

var card_display = []
var offset_x = 875
var offset_y = 100
var gap_x = 75
var gap_y = 125

var pos_x = 0
var pos_y = 0
var new_card
var selected_card = {
	"row": -1,
	"column": -1,
	"level": -1
}
var levels = [6,-1,1,2]
signal card_selected(card)

func _ready():
	pass

func _init():
	for i in range(Global.card_row):
		card_display.append([])
		for j in range(Global.card_column):
			pos_x = offset_x + j*(Global.tile_size + gap_x)
			pos_y = offset_y + i*(Global.tile_size + gap_y)
			if i == 0:
				pos_x = offset_x + (j+0.5)*(Global.tile_size + gap_x)

			new_card = card.instance()
			new_card.init(levels[i*2+j],i,j)
			new_card.set_position(Vector2(pos_x,pos_y))
			if i == 0 and j == 1:
				new_card.set_visible(false)
			new_card.connect("card_selected",self,"_on_card_selected")
			add_child(new_card)

			card_display[i].append(new_card)

func _on_card_selected(card):
	if selected_card.row != -1:
		card_display[selected_card.row][selected_card.column].set_pressed(false)
		if card.row != selected_card.row or card.column != selected_card.column:
			select_card(card.row,card.column,card.level)
		else:
			select_card(-1,-1,-1)
	else:
		select_card(card.row,card.column,card.level)
	get_parent().get_node("TilesManager").set_enable(card.is_pressed())

func select_card(row,column,level):
	selected_card.row = row
	selected_card.column = column
	selected_card.level = level

func reset_all_buttons(replace):
	for card_row in card_display:
		for card in card_row:
			card.set_pressed(false)
			card.hint_highlight(false)

func reset_button(replace):
	card_display[selected_card.row][selected_card.column].set_pressed(false)
	card_display[selected_card.row][selected_card.column].hint_highlight(false)
	if replace:
		var new_level = randi()%Global.max_hierarchy
		card_display[selected_card.row][selected_card.column].set_level(new_level)
#		print("new card level: %s" % new_level)
	select_card(-1,-1,-1)
