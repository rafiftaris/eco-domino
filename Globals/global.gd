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
	TYPE_SUNGAI: "",
	TYPE_PADANG_RUMPUT: "",
	TYPE_PADANG_GURUN: "",
	TYPE_PADANG_ES: ""
}

const button_blank_normal = preload("res://Buttons/Assets/CardSelect/card-select-button-template.png")
const button_normal = [
	preload("res://Buttons/Assets/CardSelect/button-0-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-1-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-2-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-3-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-4-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-5-normal.png"),
	preload("res://Buttons/Assets/CardSelect/button-6-normal.png")
]

const button_blank_pressed = preload("res://Buttons/Assets/CardSelect/card-pressed-button-template.png")
const button_pressed = [
	preload("res://Buttons/Assets/CardSelect/button-0-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-1-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-2-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-3-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-4-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-5-pressed.png"),
	preload("res://Buttons/Assets/CardSelect/button-6-pressed.png")
]

const button_blank_hinted = preload("res://Buttons/Assets/CardSelect/card-highlight-button-template.png")
const button_hinted = [
	preload("res://Buttons/Assets/CardSelect/button-0-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-1-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-2-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-3-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-4-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-5-highlight.png"),
	preload("res://Buttons/Assets/CardSelect/button-6-highlight.png")
]

const x_mark = preload("res://Board/Asset/x-mark.png")

var current_type = TYPE_SAWAH

const tile_size = 99
const board_row = 5
const board_column = 8
const card_row = 2
const card_column = 2
const max_hierarchy = 7
var score_inc = 50
var wrong_penalty = 50
var time_penalty = 100

enum CardPosition {UP,RIGHT,DOWN,LEFT}

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
