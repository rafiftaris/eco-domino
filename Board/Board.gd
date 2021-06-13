extends Node2D

signal finish_game
signal give_hint

var card_levels = []
var hint_coord = []
var x_marks = []
var x_marks_idx = 0
var hint_step = 0
var card_idx = {
	"row": -1,
	"col": -1
}
var current_row = -1
var current_column = -1
var scores = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	x_marks = []
	x_marks_idx = 0
	scores = 0
	$FinishButton.connect("finish_game",self,"_on_finish_game")
	$FinishButton.set_disabled(false)
	$HintButton.connect("give_hint",self,"_on_give_hint")
	$HintButton.set_disabled(false)

func show_x_marks():
	print('showing x marks....')
	scores = $TilesManager.count_score()
	$"X-MarkTimer".start()

func show_popup():
	$GameOverPopup.show_score(scores)
	var final_score = scores.score - scores.penalty
	Global.save_game(max(final_score,0))
	Global.input_enabled = true
	disable_game_inputs()

func disable_game_inputs():
	$CardManager.enable_input(false)
	$TilesManager.enable_input(false)
	$HintButton.set_disabled(true)
	
func _on_finish_game():
	$FinishButton.set_disabled(true)
	Global.input_enabled = false
	show_x_marks()

func _on_give_hint():
	get_card_levels()
	print(card_levels)
	$TilesManager.scan_highlight(false)
	var found = false
	found = search_tile(false)
	if not found:
		found = search_tile(true)
	if not found:
		reset_after_hint()
		$HintButton.set_disabled(true)

func search_tile(use_general_consume):
	var found = false
	for tile_row in range(len($TilesManager.tiles)):
		for tile_column in range(len($TilesManager.tiles[tile_row])):
			var tile = $TilesManager.tiles[tile_row][tile_column]
			if not(tile is TextureButton):
				card_idx = {
					"row": -1,
					"col": -1
				}
				current_row = tile_row
				current_column = tile_column
				found = map_card_to_tile(tile,use_general_consume)
				if found: 
					break
		if found:
			break
	return found

func map_card_to_tile(tile,use_general_consume):
	for row in range(len(card_levels)):
		for col in range(len(card_levels[row])):
			if check_tile(tile,row,col,use_general_consume):
				hint_coord = $TilesManager.check_possible_card_placement(current_row,current_column)
				if len(hint_coord) == 2:
					card_idx = {
						"row": row,
						"col": col
					}
					$HintTimer.start()
					return true
	return false

func check_tile(tile,row,col,use_general_consume):
	if card_levels[row][col] == -1:
		return false
		
	var chosen_card = $CardManager.card_display[row][col].get_node("Card")
	if not use_general_consume:
		var boti = (tile.level == (card_levels[row][col])%Global.max_hierarchy[Global.current_type] and tile is Global.CardBotReference)
		return boti and Global.can_consume(tile,chosen_card)
	else:
		return Global.can_consume(tile,chosen_card)

func get_card_levels():
	card_levels = []
	for i in range(Global.card_row):
		card_levels.append([])
		var card_row = $CardManager.card_display[i]
		for j in range(Global.card_column):
			if i == 0 and j == 1:
				continue
			card_levels[i].append(card_row[j].level)
			card_row[j].set_pressed(false)
	$CardManager.select_card(-1,-1,-1, null)

func _on_HintTimer_timeout():
	if hint_step == 0:
		$CardManager.card_display[card_idx.row][card_idx.col].hint_highlight(true)
		hint_step = 1
		$HintTimer.start()
	elif hint_step == 1:
		$TilesManager.give_hint(hint_coord)
		hint_step = 2
		hint_coord = []
		$HintTimer.start()
	elif hint_step == 2:
		reset_after_hint()
		hint_step = 0
#	print("hint_step: %s"%hint_step)

func reset_after_hint():
	Global.use_hint = true
	$CardManager.reset_all_buttons(false)
	$TilesManager.scan_highlight(false)
	$HintButton.set_pressed(false)
	Global.input_enabled = true

func deduct_hint():
	if Global.use_hint:
		$HintButton.deduct_hint()
		Global.use_hint = false

func show_undo():
	$UndoButton.set_disabled(false)
	$UndoButton.set_visible(true)

func _on_TilesManager_x_mark_spot(card):
	x_marks.append(card)
#	print('current_wrong: %s' % len(x_marks_coord))

func _on_XMarkTimer_timeout():
#	print("x_mark_id: %s" % x_marks_idx)
	if len(x_marks) == 0:
		$"X-MarkTimer".stop()
		$PopupDelayTimer.start(1)
		return
		
	if x_marks_idx == len(x_marks):
		$"X-MarkTimer".stop()
		$PopupDelayTimer.start()
		return
		
	x_marks[x_marks_idx].x_mark()
	x_marks_idx += 1

func _on_PopupDelayTimer_timeout():
	show_popup()

func _on_UndoButton_pressed():
	var animal_data = $TilesManager.undo_move()
	$CardManager.undo_move(animal_data)
