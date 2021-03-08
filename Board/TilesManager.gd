extends Node2D

var tile_button = preload("res://Buttons/TileButton.tscn")
var card = preload("res://Card/Card.tscn")

var offset_x = 28
var offset_y = 166
var gap_size = 0

var pos_x = 0
var pos_y = 0
var new_tile
var new_card
var is_enabled = false

signal x_mark_spot(position)

var current_selected_tile = {
	"row": -1,
	"column": -1,
	"adj_level": -1 
}
var tiles = []
signal tile_selected(tile)

func coord_to_vec(row,col):
	var x = offset_x + (col)*(Global.tile_size + gap_size)
	var y = offset_y + (row)*(Global.tile_size + gap_size)
	
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
	var starting_position = Global.starting_position[Global.current_type]
	new_card.init(
		0,
		starting_position.position,
		starting_position.row,
		starting_position.column
	)
	# Define bot position
	var bot_row = starting_position.row
	var bot_col = starting_position.column
	if starting_position.position == Global.CardPosition.DOWN:
		bot_row += 1
	elif starting_position.position == Global.CardPosition.UP:
		bot_row -= 1
	elif starting_position.position == Global.CardPosition.LEFT:
		bot_col -= 1
	elif starting_position.position == Global.CardPosition.RIGHT:
		bot_col += 1
	new_card.set_card_pos(
		coord_to_vec(starting_position.row,starting_position.column),
		coord_to_vec(bot_row,bot_col)
	)
	tiles[starting_position.row][starting_position.column].queue_free()
	tiles[bot_row][bot_col].queue_free()
	tiles[starting_position.row][starting_position.column] = new_card
	tiles[bot_row][bot_col] = Global.CardBotReference.new(starting_position, new_card.get_bot_level(), new_card.animal_name)
#	print("init_ref: %s %s" % [start.row+1,start.column])
	
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
		Global.add_availability(level)  # add more card choices
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
		"x": offset_x + (current_selected_tile.column)*(Global.tile_size + gap_size),
		"y": offset_y + (current_selected_tile.row)*(Global.tile_size + gap_size)
	}
	var bot = {
		"x": offset_x + (bot_tile.column)*(Global.tile_size + gap_size),
		"y": offset_y + (bot_tile.row)*(Global.tile_size + gap_size)
	}
	
	new_card = card.instance()
	new_card.init(null,card_pos,current_selected_tile.row,current_selected_tile.column)
	new_card.level = level
	new_card.set_card_pos(top,bot)
	
	tiles[current_selected_tile.row][current_selected_tile.column].queue_free()
	tiles[bot_tile.row][bot_tile.column].queue_free()
	
	var reversed = false

	for adj_level in current_selected_tile.adj_level:
#		print("%s %s" % [current_selected_tile.row, current_selected_tile.column])
#		print(tiles[adj_level.row][adj_level.column].get_class())
#		print(tiles[adj_level.row][adj_level.column] is Node2D)
		if tiles[adj_level.row][adj_level.column] is Node2D:
			reversed = true
			break
#	print(reversed)
	if reversed:
#		print("ref_tile: %s %s" % [current_selected_tile.row,current_selected_tile.column])
		new_card.set_reversed(true)
		new_card.row = bot_tile.row
		new_card.column = bot_tile.column
		tiles[bot_tile.row][bot_tile.column] = new_card
		tiles[current_selected_tile.row][current_selected_tile.column] = Global.CardBotReference.new(bot_tile, new_card.get_bot_level(),new_card.animal_name)
	else:
#		print("ref_tile: %s %s" % [bot_tile.row,bot_tile.column])
		tiles[current_selected_tile.row][current_selected_tile.column] = new_card
		tiles[bot_tile.row][bot_tile.column] = Global.CardBotReference.new(current_selected_tile, new_card.get_bot_level(),new_card.animal_name)
	
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
			elif tiles[i][j] is Global.CardBotReference:
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
	var score = 0
	var penalty = 0
	var i = 0
	var j = 0
	
	for tile_row in tiles:
		j = 0
		for tile in tile_row:
			if (not tile is Global.CardBotReference) or tile.checked:
				j += 1
				continue
			score += 10
				
			print('coord: %s %s' % [i,j])
			# Right
			if j+1<Global.board_column:
				var right = tiles[i][j+1]
				if not right is TextureButton and not (tile.row == right.row and tile.column == right.column):
					if tile.get_class() != right.get_class() and Global.can_consume(tile,right):
						if right.level == 0 and Global.enable_bonus:
							print('bonus right')
							score += 10
					else: 
						# Adj tile is not the real reference
						print('penalty right')
						print(right)
						print("%s %s" % [right.row,right.column])
						print(right.level)
						penalty += Global.wrong_penalty
						emit_signal("x_mark_spot",right)
			# Up
			if i-1>=0:
				var up = tiles[i-1][j]
				if not up is TextureButton and not (tile.row == up.row and tile.column == up.column):
					if tile.get_class() != up.get_class() and Global.can_consume(tile,up):
						if up.level == 0 and Global.enable_bonus:
							print('bonus up')
							score += 10
					else: 
						# Adj tile is not the real reference
						print('penalty up')
						print(up)
						print("%s %s" % [tile.row,tile.column])
						print("%s %s" % [up.row,up.column])
						print(up.level)
						penalty += Global.wrong_penalty
						emit_signal("x_mark_spot",up)
			# Down
			if i+1<Global.board_row:
				var down = tiles[i+1][j]
				if not down is TextureButton and not (tile.row == down.row and tile.column == down.column):
					if tile.get_class() != down.get_class() and Global.can_consume(tile,down):
						if down.level == 0 and Global.enable_bonus:
							print('bonus down')
							score += 10
					else: 
						# Adj tile is not the real reference
						print('penalty down')
						print(down)
						print("%s %s" % [down.row,down.column])
						print(down.level)
						penalty += Global.wrong_penalty
						emit_signal("x_mark_spot",down)
			# Left
			if j-1>=0:
				var left = tiles[i][j-1]
				if not left is TextureButton and not (tile.row == left.row and tile.column == left.column):
					if tile.get_class() != left.get_class() and Global.can_consume(tile,left):
						if left.level == 0 and Global.enable_bonus:
							print('bonus left')
							score += 10
					else: 
						# Adj tile is not the real reference
						print('penalty left')
						print(left)
						print("%s %s" % [left.row,left.column])
						print(left.level)
						penalty += Global.wrong_penalty
						emit_signal("x_mark_spot",left)
						
			tile.checked = true
			j += 1
		i += 1
	
	if Global.current_type == Global.TYPE_SAWAH:
		score = int(float(score*10)/9)
	
	return {
		"score": score,
		"penalty": penalty
	}

func enable_input(enable):
	for i in range(Global.board_row):
		for j in range(Global.board_column):
			if tiles[i][j] is TextureButton:
				tiles[i][j].enable_input(enable)
