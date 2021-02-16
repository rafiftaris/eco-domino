extends Node2D

signal finish_game
signal give_hint

var card_levels = []
var hint_coord = []
var x_marks_coord = []
var x_marks_idx = 0
var hint_step = 0
var card_idx = -1
var current_row = -1
var current_column = -1
var scores = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	x_marks_coord = []
	x_marks_idx = 0
	scores = 0
	$FinishButton.connect("finish_game",self,"_on_finish_game")
	$HintButton.connect("give_hint",self,"_on_give_hint")
	$TimerText.init_timer()
	$GameTimer.start()

func show_x_marks():
	print('showing x marks....')
	scores = $TilesManager.count_score()
	$"X-MarkTimer".start()

func show_popup():
	$GameOverPopup.show_score(scores, $TimerText.is_penalty)
	var final_score = scores.score - scores.penalty
	if $TimerText.is_penalty:
		final_score -= Global.time_penalty
	Global.save_game(final_score)
	
func _on_finish_game():
	Global.input_enabled = false
	$GameTimer.stop()
	show_x_marks()

func _on_give_hint():
	get_card_levels()
#	print(card_levels)
	$TilesManager.scan_highlight(false)
	var found = false
	for tile_row in range(len($TilesManager.tiles)):
		var stop = false
		for tile_column in range(len($TilesManager.tiles[tile_row])):
			var tile = $TilesManager.tiles[tile_row][tile_column]
			if not(tile is TextureButton):
				var current_level = tile.level
				card_idx = -1
				current_row = tile_row
				current_column = tile_column
				for idx in range(len(card_levels)):
					if idx/2 == 0 and idx%2 == 1: # skips invisible button
						continue
					if check_tile(tile,idx,current_level):
						hint_coord = $TilesManager.check_possible_card_placement(current_row,current_column)
						if len(hint_coord) == 2:
							card_idx = idx
							$HintTimer.start()
							found = true
							break
#				print("card_idx: %s" % card_idx)
				if card_idx != -1: 
					stop = true
					break
		if stop:
			break
	if not found:
		reset_after_hint()
		$HintButton.set_disabled(true)

func check_tile(tile,idx,current_level):
	var topi = (current_level == (card_levels[idx]+1)%Global.max_hierarchy and tile is Node2D) 
	var boti = (current_level == (card_levels[idx])%Global.max_hierarchy and tile is Global.CardBotReference)
	
#	print("(%s %s) %s %s" % [idx/2,idx%2,card_levels[idx], topi or boti])
	return (topi or boti)

func get_card_levels():
	card_levels = []
	for card_row in $CardManager.card_display:
		for card in card_row:
			card_levels.append(card.level)
			card.set_pressed(false)
	$CardManager.select_card(-1,-1,-1)

func _on_HintTimer_timeout():
	if hint_step == 0:
		$CardManager.card_display[card_idx/2][card_idx%2].hint_highlight(true)
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

func _on_GameTimer_timeout():
	$TimerText.update_timer()
	if $TimerText.countdown_seconds <= 0:
		$TimerText.set_penalty(true)

func reset_after_hint():
	Global.use_hint = true
	$CardManager.reset_all_buttons(false)
	$TilesManager.scan_highlight(false)
	$HintButton.set_pressed(false)
	Global.input_enabled = true

func deduct_hint():
	if Global.use_hint:
		$HintButton.deduct_hint()

func _on_TilesManager_x_mark_spot(position):
	x_marks_coord.append(position)
#	print('current_wrong: %s' % len(x_marks_coord))

func _on_XMarkTimer_timeout():
#	print("x_mark_id: %s" % x_marks_idx)
	if x_marks_idx == len(x_marks_coord):
		$"X-MarkTimer".stop()
		show_popup()
		return
	$"X-MarkManager".place_mark(x_marks_coord[x_marks_idx])
	x_marks_idx += 1
