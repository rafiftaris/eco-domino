extends Node2D

var tile_button = preload("res://Buttons/TileButton.tscn")
var card = preload("res://Card/Card.tscn")

var offset_x = 16
var offset_y = 92
var gap_size = 0

var pos_x = 0
var pos_y = 0
var new_tile
var new_card

var current_selected_tile = {
	"row": -1,
	"column": -1
}
var tiles = []
signal tile_selected(tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func reset_select_tile():
	current_selected_tile.row = -1
	current_selected_tile.column = -1

func _init():
	for i in range(Global.board_row):
		tiles.append([])
		for j in range(Global.board_column):
			pos_x = offset_x + j*(Global.tile_size + gap_size)
			pos_y = offset_y + i*(Global.tile_size + gap_size)
			
			new_tile = tile_button.instance()
			new_tile.set_position(Vector2(pos_x,pos_y))
			new_tile.init(i,j)
			new_tile.connect("tile_selected",self,"_on_tile_selected")
			add_child(new_tile)
			
			tiles[i].append(new_tile)

func _on_tile_selected(tile):
	if not tile.highlight:
		if (tile.row == current_selected_tile.row and tile.column == current_selected_tile.column) or current_selected_tile.row == -1:
			if current_selected_tile.row != -1:  # re-pressed the tile
				reset_select_tile()
			else: # select a new tile
				current_selected_tile.row = tile.row
				current_selected_tile.column = tile.column
			highlight_adj_tile(tile.row, tile.column, tile.is_pressed())
		else: # selecting non-highlighted tile
			tile.set_pressed(false)
	else: # selecting the highlighted (second) tile
		reset_tiles(tile)
		place_card(tile)
		reset_select_tile()

func highlight_adj_tile(row, column, flag):
	# Down
	if row+1<Global.board_row and tiles[row+1][column] is TextureButton:
		tiles[row+1][column].set_highlight(flag)
	# Up
	if row-1>=0 and tiles[row-1][column] is TextureButton:
		tiles[row-1][column].set_highlight(flag)
	# Right
	if column+1<Global.board_column and tiles[row][column+1] is TextureButton:
		tiles[row][column+1].set_highlight(flag)
	# Left
	if column-1>=0 and tiles[row][column-1] is TextureButton:
		tiles[row][column-1].set_highlight(flag)

func reset_tiles(next_tile):
	tiles[next_tile.row][next_tile.column].set_pressed(false)
	tiles[current_selected_tile.row][current_selected_tile.column].set_pressed(false)
	highlight_adj_tile(current_selected_tile.row, current_selected_tile.column, false)
	
func place_card(bot_tile):
	var card_pos
	if bot_tile.row > current_selected_tile.row:
		card_pos = Global.CardPosition.DOWN
	elif bot_tile.row < current_selected_tile.row:
		card_pos = Global.CardPosition.UP
	else:
		if bot_tile.column > current_selected_tile.column:
			card_pos = Global.CardPosition.RIGHT
		elif bot_tile.column < current_selected_tile.column:
			card_pos = Global.CardPosition.LEFT
	
	var top = {
		"x": offset_x + (current_selected_tile.column+0.5)*(Global.tile_size + gap_size),
		"y": offset_y + (current_selected_tile.row+0.5)*(Global.tile_size + gap_size)
	}
	var bot = {
		"x": offset_x + (bot_tile.column+0.5)*(Global.tile_size + gap_size),
		"y": offset_y + (bot_tile.row+0.5)*(Global.tile_size + gap_size)
	}
	
	new_card = card.instance()
	new_card.init(randi()%Global.max_hierarchy,card_pos)
	new_card.set_card_pos(top,bot)
	tiles[current_selected_tile.row][current_selected_tile.column].queue_free()
	tiles[bot_tile.row][bot_tile.column].queue_free()
	tiles[current_selected_tile.row][current_selected_tile.column] = new_card
	tiles[bot_tile.row][bot_tile.column] = Global.CardBotReference.new(new_card.get_bot_level())
	
	self.add_child(new_card)
