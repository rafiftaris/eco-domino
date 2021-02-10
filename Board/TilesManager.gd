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
var is_enabled = false

var current_selected_tile = {
	"row": -1,
	"column": -1,
	"adj_level": -1 
}
var start = {
	"row": 0,
	"column": 0,
	"position": Global.CardPosition.DOWN
}
var tiles = []
signal tile_selected(tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func coord_to_vec(row,col):
	var x = offset_x + (col+0.5)*(Global.tile_size + gap_size)
	var y = offset_y + (row+0.5)*(Global.tile_size + gap_size)
	
	return Vector2(x,y)

func reset_select_tile():
	current_selected_tile.row = -1
	current_selected_tile.column = -1
	current_selected_tile.adj_level = -1

func _init():
	for i in range(Global.board_row):
		tiles.append([])
		for j in range(Global.board_column):
			pos_x = offset_x + j*(Global.tile_size + gap_size)
			pos_y = offset_y + i*(Global.tile_size + gap_size)
			
			new_tile = tile_button.instance()
			new_tile.init(i,j)
			new_tile.set_position(Vector2(pos_x,pos_y))
			new_tile.connect("tile_selected",self,"_on_tile_selected")
			add_child(new_tile)
			
			tiles[i].append(new_tile)
	
	new_card = card.instance()
	new_card.init(0,Global.CardPosition.DOWN,start.row,start.column)
	new_card.set_card_pos(coord_to_vec(start.row,start.column),coord_to_vec(start.row+1,start.column))
	tiles[start.row][start.column].queue_free()
	tiles[start.row+1][start.column].queue_free()
	tiles[start.row][start.column] = new_card
	tiles[start.row+1][start.column] = Global.CardBotReference.new(new_card.get_bot_level())
	
	self.add_child(new_card)

func _on_tile_selected(tile):
	var level = get_parent().get_node("CardManager").selected_card.level
	# Selected an empty card or choosing tile before choosing card
	# or
	if level == -1 or not is_enabled or not tile.highlight or not tile.is_pressed():
		if not tile.highlight and not (tile.row == current_selected_tile.row and tile.column == current_selected_tile.column):
			tile.set_pressed(false)
			return
		scan_highlight(false)
		scan_highlight(true)
		tile.set_pressed(false)
		reset_select_tile()
		return

	if (tile.row == current_selected_tile.row and tile.column == current_selected_tile.column) or current_selected_tile.row == -1:
		scan_highlight(false)
		# select a new tile
		current_selected_tile.row = tile.row
		current_selected_tile.column = tile.column
		highlight_adj_tile(tile.row, tile.column, tile.is_pressed())
		get_adj_level(tile.row,tile.column)
	elif current_selected_tile.row != -1: # selecting the highlighted (second) tile
		reset_tiles(tile)
		place_card(tile, level)
		reset_select_tile()
		reset_button()
		get_parent().deduct_hint()

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

func get_adj_level(row, column):
	var adj = []
	# Down
	if row+1<Global.board_row and not tiles[row+1][column] is TextureButton:
		adj.append({
			"row": row+1,
			"column": column,
			"level": tiles[row+1][column].level
		})
	# Up
	if row-1>=0 and not tiles[row-1][column] is TextureButton:
		adj.append({
			"row": row-1,
			"column": column,
			"level": tiles[row-1][column].level
		})
	# Right
	if column+1<Global.board_column and not tiles[row][column+1] is TextureButton:
		adj.append({
			"row": row,
			"column": column+1,
			"level": tiles[row][column+1].level
		})
	# Left
	if column-1>=0 and not tiles[row][column-1] is TextureButton:
		adj.append({
			"row": row,
			"column": column-1,
			"level": tiles[row][column-1].level
		})
	current_selected_tile.adj_level = adj

func reset_tiles(next_tile):
	tiles[next_tile.row][next_tile.column].set_pressed(false)
	tiles[current_selected_tile.row][current_selected_tile.column].set_pressed(false)
	highlight_adj_tile(current_selected_tile.row, current_selected_tile.column, false)
	
func place_card(bot_tile, level):
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
	new_card.init(level,card_pos,current_selected_tile.row,current_selected_tile.column)
	new_card.set_card_pos(top,bot)
	
	tiles[current_selected_tile.row][current_selected_tile.column].queue_free()
	tiles[bot_tile.row][bot_tile.column].queue_free()
	
	var reversed = false
	for adj_level in current_selected_tile.adj_level:
		if  adj_level.level == (level+1)%7:
			reversed = true
			break
	if reversed:
		new_card.set_reversed(true)
		tiles[bot_tile.row][bot_tile.column] = new_card
		tiles[current_selected_tile.row][current_selected_tile.column] = Global.CardBotReference.new(new_card.get_bot_level())
	else:
		tiles[current_selected_tile.row][current_selected_tile.column] = new_card
		tiles[bot_tile.row][bot_tile.column] = Global.CardBotReference.new(new_card.get_bot_level())
	
	self.add_child(new_card)

func reset_button():
	get_parent().get_node("CardManager").reset_button(true)
	
func set_enable(flag):
	self.is_enabled = flag
	scan_highlight(flag)

func scan_highlight(flag):
	for i in range(Global.board_row):
		for j in range(Global.board_column):
			if not flag:
				if tiles[i][j] is TextureButton:
					if not self.is_enabled:
						tiles[i][j].set_pressed(false)
					tiles[i][j].set_highlight(false)
			elif not(tiles[i][j] is TextureButton):
				highlight_adj_tile(i,j,true)

func check_possible_card_placement(row,column):
	var adjs = []
	# Right
	if column+1<Global.board_column and tiles[row][column+1] is TextureButton:
		adjs.append([row,column+1])
	# Up
	if row-1>=0 and tiles[row-1][column] is TextureButton:
		adjs.append([row-1,column])
	# Down
	if row+1<Global.board_row and tiles[row+1][column] is TextureButton:
		adjs.append([row+1,column])
	# Left
	if column-1>=0 and tiles[row][column-1] is TextureButton:
		adjs.append([row,column-1])
	
	var second_coord = []
#	print('curr_coord: %s %s' % [row,column])
#	print('adjs: %s' % [adjs])
	for coord in adjs:
		var prev_row = coord[0]
		var prev_column = coord[1]
		
		var occupied_count = 0
#		print("adjs_coord: %s %s" % [prev_row, prev_column])
		# right
		if prev_column+1<Global.board_column and not tiles[prev_row][prev_column+1] is TextureButton:
#			print('right')
			occupied_count += 1
		# Up
		if prev_row-1>=0 and not tiles[prev_row-1][prev_column] is TextureButton:
#			print('up')
			occupied_count += 1
		# Down
		if prev_row+1<Global.board_row and not tiles[prev_row+1][prev_column] is TextureButton:
#			print('down')
			occupied_count += 1
		# Left
		if prev_column-1>=0 and not tiles[prev_row][prev_column-1] is TextureButton:
#			print('left')
			occupied_count += 1
		if occupied_count > 1:
			continue
		
		second_coord = [[prev_row,prev_column]]
		# Right
		if prev_column+1<Global.board_column and tiles[prev_row][prev_column+1] is TextureButton:
			if is_adjacent_empty(prev_row,prev_column+1):
				second_coord.append([prev_row,prev_column+1])
				break
		# Up
		if prev_row-1>=0 and tiles[prev_row-1][prev_column] is TextureButton:
			if is_adjacent_empty(prev_row-1,prev_column):
				second_coord.append([prev_row-1,prev_column])
				break
		# Down
		if prev_row+1<Global.board_row and tiles[prev_row+1][prev_column] is TextureButton:
			if is_adjacent_empty(prev_row+1,prev_column):
				second_coord.append([prev_row+1,prev_column])
				break
		# Left
		if prev_column-1>=0 and tiles[prev_row][prev_column-1] is TextureButton:
			if is_adjacent_empty(prev_row,prev_column-1):
				second_coord.append([prev_row,prev_column-1])
				break
	
#	print("second_coord: %s" % [second_coord])
	if len(second_coord) > 1:
		return second_coord
	else:
		return []

func is_adjacent_empty(row,column):
	var right = true
	var top = true
	var bot = true
	var left = true
	if column+1<Global.board_column:
		right = tiles[row][column+1] is TextureButton
	if row-1>=0:
		top = tiles[row-1][column] is TextureButton
	if row+1<Global.board_row:
		bot = tiles[row+1][column] is TextureButton
	if column-1>=0:
		left = tiles[row][column-1] is TextureButton
#	print("%s %s" % [row,column])
#	print("%s %s %s %s" % [top,bot,right,left])
	return top and bot and right and left

func give_hint(coords):
	tiles[coords[0][0]][coords[0][1]].set_highlight(true)
	tiles[coords[1][0]][coords[1][1]].set_highlight(true)
	
func count_score():
	pass
