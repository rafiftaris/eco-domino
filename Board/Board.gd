extends Node2D

signal finish_game
signal give_hint

var card_levels = []
var hint_coord = []
var hint_step = 0
var card_idx = -1
var current_row = -1
var current_column = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$FinishButton.connect("finish_game",self,"_on_finish_game")
	$HintButton.connect("give_hint",self,"_on_give_hint")

func _on_finish_game():
	pass
#	$GameOverPopup.set_visible(true)

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
#	print("level: %s" % card_levels[idx])
	var topi = (current_level == (card_levels[idx]+1)%Global.max_hierarchy and tile is Node2D) 
	var boti = (current_level == (card_levels[idx])%Global.max_hierarchy and tile is Global.CardBotReference)

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

func reset_after_hint():
	Global.use_hint = true
	$CardManager.reset_all_buttons(false)
	$TilesManager.scan_highlight(false)
	$HintButton.set_pressed(false)
	Global.input_enabled = true

func deduct_hint():
	if Global.use_hint:
		$HintButton.deduct_hint()
