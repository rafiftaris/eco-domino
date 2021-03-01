extends Node

class CardBotReference:
	var row: int
	var column: int
	var level: int
	var checked
	
	func _init(coord_reference, level):
		self.level = level
		self.row = coord_reference.row
		self.column = coord_reference.column
		self.checked = false

const TYPE_SAWAH = "sawah"
const TYPE_LAUT = "laut"
const TYPE_SUNGAI = "sungai"
const TYPE_HUTAN = "hutan"
const TYPE_PADANG_RUMPUT = "padang rumput"
const TYPE_PADANG_GURUN = "padang gurun"
const TYPE_PADANG_ES = "padang es"

const background = {
	TYPE_SAWAH: preload("res://Backgrounds/sawah.png"),
	TYPE_HUTAN: preload("res://Backgrounds/hutan.png"),
	TYPE_LAUT: preload("res://Backgrounds/laut.png"),
	TYPE_SUNGAI: preload("res://Backgrounds/sungai.png"),
	TYPE_PADANG_RUMPUT: preload("res://Backgrounds/padang rumput.png"),
	TYPE_PADANG_GURUN: preload("res://Backgrounds/padang gurun.png"),
	TYPE_PADANG_ES: preload("res://Backgrounds/padang es.png")
}

const cards = {
	TYPE_SAWAH: {
		"top": [
			[
				preload("res://Card/Asset/sawah/0_padi.png")
			],
			[
				preload("res://Card/Asset/sawah/1_bekicot.png"),
				preload("res://Card/Asset/sawah/1_burung.png"),
				preload("res://Card/Asset/sawah/1_jangkrik.png"),
				preload("res://Card/Asset/sawah/1_tikus.png")
			],
			[
				preload("res://Card/Asset/sawah/2_kodok.png"),
				preload("res://Card/Asset/sawah/2_laba-laba.png")
			],
			[
				
				preload("res://Card/Asset/sawah/3_ular.png")
			],
			[
				preload("res://Card/Asset/sawah/4_elang.png")
			]
		],
		"bot": [
			null,
			preload("res://Card/Asset/sawah/bot_1.png"),
			preload("res://Card/Asset/sawah/bot_2.png"),
			preload("res://Card/Asset/sawah/bot_3.png"),
			preload("res://Card/Asset/sawah/bot_4.png"),
		],
	},
	TYPE_HUTAN: {
		"top": [
			[
				preload("res://Card/Asset/hutan/0_ceri.png"),
				preload("res://Card/Asset/hutan/0_rumput.png")
			],
			[
				preload("res://Card/Asset/hutan/1_jangkrik.png"),
				preload("res://Card/Asset/hutan/1_kelinci.png"),
				preload("res://Card/Asset/hutan/1_tikus.png"),
				preload("res://Card/Asset/hutan/1_burung.png"),
				preload("res://Card/Asset/hutan/1_toucan.png"),
			],
			[
				preload("res://Card/Asset/hutan/2_ular.png"),
				preload("res://Card/Asset/hutan/2_laba-laba.png")
			],
			[
				preload("res://Card/Asset/hutan/3_serigala.png"),
				preload("res://Card/Asset/hutan/3_elang.png")
			]
		],
		"bot": [
			preload("res://Card/Asset/hutan/bot_0.png"),
			preload("res://Card/Asset/hutan/bot_1.png"),
			preload("res://Card/Asset/hutan/bot_2.png"),
			preload("res://Card/Asset/hutan/bot_3.png"),
			preload("res://Card/Asset/hutan/bot_4.png"),
		],
	},
	TYPE_LAUT: {
		"top": [
			[
				preload("res://Card/Asset/laut/0_alga.png"),
				preload("res://Card/Asset/laut/0_plankton.png")
			],
			[
				preload("res://Card/Asset/laut/1_ikan.png"),
				preload("res://Card/Asset/laut/1_udang.png")
			],
			[
				preload("res://Card/Asset/laut/2_flamingo.png"),
				preload("res://Card/Asset/laut/2_gurita.png"),
				preload("res://Card/Asset/laut/2_salmon.png")
			],
			[
				preload("res://Card/Asset/laut/3_anjing_laut.png"),
				preload("res://Card/Asset/laut/3_pelikan.png")
			],
			[
				preload("res://Card/Asset/laut/4_paus.png")
			]
		],
		"bot": [
			preload("res://Card/Asset/laut/bot_0.png"),
			preload("res://Card/Asset/laut/bot_1.png"),
			preload("res://Card/Asset/laut/bot_2.png"),
			preload("res://Card/Asset/laut/bot_3.png"),
			preload("res://Card/Asset/laut/bot_4.png"),
			preload("res://Card/Asset/laut/bot_5.png")
		],
	},
	TYPE_SUNGAI: {
		"top": [
			[
				preload("res://Card/Asset/sungai/0_alga.png"),
				preload("res://Card/Asset/sungai/0_lumut.png")
			],
			[
				preload("res://Card/Asset/sungai/1_ikan_kecil.png"),
				preload("res://Card/Asset/sungai/1_udang.png")
			],
			[
				preload("res://Card/Asset/sungai/2_ikan_besar.png")
			],
			[
				preload("res://Card/Asset/sungai/3_bebek.png"),
				preload("res://Card/Asset/sungai/3_otter.png"),
				preload("res://Card/Asset/sungai/3_pelikan.png")
			],
			[
				preload("res://Card/Asset/sungai/4_beruang.png")
			],
		],
		"bot": [
			preload("res://Card/Asset/sungai/bot_0.png"),
			preload("res://Card/Asset/sungai/bot_1.png"),
			preload("res://Card/Asset/sungai/bot_2.png"),
			preload("res://Card/Asset/sungai/bot_3.png"),
			preload("res://Card/Asset/sungai/bot_4.png"),
			preload("res://Card/Asset/sungai/bot_5.png")
		],
	},
	TYPE_PADANG_RUMPUT: {
		"top": [
			[
				preload("res://Card/Asset/padang rumput/0_pohon.png"),
				preload("res://Card/Asset/padang rumput/0_rumput.png")
			],
			[
				preload("res://Card/Asset/padang rumput/1_gajah.png"),
				preload("res://Card/Asset/padang rumput/1_jerapah.png"),
				preload("res://Card/Asset/padang rumput/1_kelinci.png"),
				preload("res://Card/Asset/padang rumput/1_zebra.png")
			],
			[
				preload("res://Card/Asset/padang rumput/2_ular.png")
			],
			[
				preload("res://Card/Asset/padang rumput/3_harimau.png"),
				preload("res://Card/Asset/padang rumput/3_singa.png"),
				preload("res://Card/Asset/padang rumput/3_serigala.png")
			]
		],
		"bot": [
			preload("res://Card/Asset/padang rumput/bot_0.png"),
			preload("res://Card/Asset/padang rumput/bot_1.png"),
			preload("res://Card/Asset/padang rumput/bot_2.png"),
			preload("res://Card/Asset/padang rumput/bot_3.png"),
			preload("res://Card/Asset/padang rumput/bot_4.png")
		],
	},
	TYPE_PADANG_GURUN: {
		"top": [
			[
				preload("res://Card/Asset/padang gurun/0_biji.png"),
				preload("res://Card/Asset/padang gurun/0_rumput.png")
			],
			[
				preload("res://Card/Asset/padang gurun/1_burung.png"),
				preload("res://Card/Asset/padang gurun/1_kadal.png"),
				preload("res://Card/Asset/padang gurun/1_rusa.png"),
				preload("res://Card/Asset/padang gurun/1_tikus.png"),
				preload("res://Card/Asset/padang gurun/1_unta.png")
			],
			[
				preload("res://Card/Asset/padang gurun/2_ular.png")
			],
			[
				preload("res://Card/Asset/padang gurun/3_elang.png"),
				preload("res://Card/Asset/padang gurun/3_serigala.png")
			],
		],
		"bot": [
			preload("res://Card/Asset/padang gurun/bot_0.png"),
			preload("res://Card/Asset/padang gurun/bot_1.png"),
			preload("res://Card/Asset/padang gurun/bot_2.png"),
			preload("res://Card/Asset/padang gurun/bot_3.png"),
			preload("res://Card/Asset/padang gurun/bot_4.png")
		],
	},
	TYPE_PADANG_ES: {
		"top": [
			[
				preload("res://Card/Asset/padang es/0_plankton.png"),
				preload("res://Card/Asset/padang es/0_tanaman.png")
			],
			[
				preload("res://Card/Asset/padang es/1_ikan_kecil.png"),
				preload("res://Card/Asset/padang es/1_kelinci.png")
			],
			[
				preload("res://Card/Asset/padang es/2_musang.png"),
				preload("res://Card/Asset/padang es/2_owl.png"),
				preload("res://Card/Asset/padang es/2_penguin.png")
			],
			[
				preload("res://Card/Asset/padang es/3_elang.png"),
				preload("res://Card/Asset/padang es/3_serigala.png")
			],
			[
				preload("res://Card/Asset/padang es/4_beruang.png")
			]
		],
		"bot": [
			preload("res://Card/Asset/padang es/bot_0.png"),
			preload("res://Card/Asset/padang es/bot_1.png"),
			preload("res://Card/Asset/padang es/bot_2.png"),
			preload("res://Card/Asset/padang es/bot_3.png"),
			preload("res://Card/Asset/padang es/bot_4.png")
		],
	}
}

const button_blank_normal = preload("res://Buttons/Assets/CardSelect/card-select-button-template.png")
const button_blank_pressed = preload("res://Buttons/Assets/CardSelect/card-pressed-button-template.png")
const button_blank_hinted = preload("res://Buttons/Assets/CardSelect/card-highlight-button-template.png")


const x_mark = preload("res://Board/Asset/x-mark.png")

var current_type = TYPE_SAWAH
var current_card = cards[current_type]
var available_level = [1]

const tile_size = 100
const board_row = 5
const board_column = 8
const card_row = 2
const card_column = 2
const max_hierarchy = {
	TYPE_SAWAH: 5,
	TYPE_HUTAN: 4,
	TYPE_LAUT: 5,
	TYPE_SUNGAI: 5,
	TYPE_PADANG_RUMPUT: 4,
	TYPE_PADANG_GURUN: 4,
	TYPE_PADANG_ES: 5
}

enum CardPosition {UP,RIGHT,DOWN,LEFT}

const starting_position = {
	TYPE_SAWAH: {
		"row": 1,
		"column": 1,
		"position": CardPosition.DOWN
	},
	TYPE_HUTAN: {
		"row": 0,
		"column": 0,
		"position": CardPosition.DOWN
	},
	TYPE_LAUT: {
		"row": 2,
		"column": 2,
		"position": CardPosition.RIGHT
	},
	TYPE_SUNGAI: {
		"row": 0,
		"column": 0,
		"position": CardPosition.DOWN
	},
	TYPE_PADANG_RUMPUT: {
		"row": 0,
		"column": 0,
		"position": CardPosition.DOWN
	},
	TYPE_PADANG_GURUN: {
		"row": 0,
		"column": 0,
		"position": CardPosition.DOWN
	},
	TYPE_PADANG_ES: {
		"row": 0,
		"column": 0,
		"position": CardPosition.DOWN
	}
}
var selected_card = {
	"row": -1,
	"column": -1,
	"level": -1,
	"texture": null,
}

var score_inc = 50
var wrong_penalty = 50
var time_penalty = 100

var input_enabled = true
var use_hint = false
var timer_minute = 2
var timer_seconds = 0

var save_dict = {
	TYPE_SAWAH: {
		"has_been_played": false,
		"score": 0
	},
	TYPE_HUTAN: {
		"has_been_played": false,
		"score": 0
	},
	TYPE_LAUT: {
		"has_been_played": false,
		"score": 0
	},
	TYPE_SUNGAI: {
		"has_been_played": false,
		"score": 0
	},
	TYPE_PADANG_RUMPUT: {
		"has_been_played": false,
		"score": 0
	},
	TYPE_PADANG_GURUN: {
		"has_been_played": false,
		"score": 0
	},
	TYPE_PADANG_ES: {
		"has_been_played": false,
		"score": 0
	}
}

func _ready():
	var save_game = File.new()
	if save_game.file_exists("res://savefile/savegame.save"):
		save_game.open("res://savefile/savegame.save", File.READ)
		save_dict = parse_json(save_game.get_line())
		save_game.close()

func save_game(score):
	save_dict[current_type]["score"] = score
	save_dict[current_type]["has_been_played"] = true
	var save_game = File.new()
	save_game.open("res://savefile/savegame.save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	
func add_availability(level):
	var down = (level-1)%max_hierarchy[current_type]
	var up = (level+1)%max_hierarchy[current_type]
	
	if not available_level.has(down):
		available_level.append(down)
	if not available_level.has(up):
		available_level.append(up)

func set_current_card(level):
	current_card = cards[level].duplicate(true)
