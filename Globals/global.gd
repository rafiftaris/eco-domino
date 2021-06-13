extends Node

class CardBotReference:
	var row: int
	var column: int
	var level: int
	var checked
	var animal_name
	
	func _init(coord_reference, level, animal_name):
		self.level = level
		self.row = coord_reference.row
		self.column = coord_reference.column
		self.checked = false
		self.animal_name = animal_name

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

const animal_categories = {
	"produsen": [
		"padi", "buah-buahan", "rumput", 
		"lumut", "pohon", "biji-bijian", "tanaman"
	],
	"produsen air": [
		"fitoplankton", "alga"
	],
	"serangga": [
		"belalang", "ulat"
	],
	"hewan air": [
		"ikan kecil", "udang", "gurita", "salmon", 
		"anjing laut", "pelikan", "paus", "ikan besar"
	],
	"hewan besar": [
		"gajah", "jerapah", "zebra", "rusa", "unta"
	]
}

const cards = {
	TYPE_SAWAH: [
		{
			"padi": preload("res://Card/Asset/sawah/0_padi.png")
		},
		{
			"ulat": preload("res://Card/Asset/sawah/1_ulat.png"),
			"belalang": preload("res://Card/Asset/sawah/1_jangkrik.png"),
			"tikus": preload("res://Card/Asset/sawah/1_tikus.png")
		},
		{
			"burung pipit": preload("res://Card/Asset/sawah/2_burung.png"),
			"katak": preload("res://Card/Asset/sawah/2_kodok.png"),
			"laba-laba": preload("res://Card/Asset/sawah/2_laba-laba.png")
		},
		{
			"ular": preload("res://Card/Asset/sawah/3_ular.png")
		},
		{
			"elang": preload("res://Card/Asset/sawah/4_elang.png")
		}
	],
	TYPE_HUTAN: [
		{
			"buah-buahan": preload("res://Card/Asset/hutan/0_ceri.png"),
			"rumput": preload("res://Card/Asset/hutan/0_rumput.png")
		},
		{
			"belalang": preload("res://Card/Asset/hutan/1_jangkrik.png"),
			"kelinci": preload("res://Card/Asset/hutan/1_kelinci.png"),
			"tikus": preload("res://Card/Asset/hutan/1_tikus.png"),
			"burung": preload("res://Card/Asset/hutan/1_burung.png")
		},
		{
			"ular": preload("res://Card/Asset/hutan/2_ular.png"),
			"laba-laba": preload("res://Card/Asset/hutan/2_laba-laba.png")
		},
		{
			"serigala": preload("res://Card/Asset/hutan/3_serigala.png"),
			"elang": preload("res://Card/Asset/hutan/3_elang.png")
		}
	],
	TYPE_LAUT: [
		{
			"alga": preload("res://Card/Asset/laut/0_alga.png"),
			"fitoplankton": preload("res://Card/Asset/laut/0_plankton.png")
		},
		{
			"ikan kecil": preload("res://Card/Asset/laut/1_ikan.png"),
			"udang": preload("res://Card/Asset/laut/1_udang.png")
		},
		{
			"flamingo": preload("res://Card/Asset/laut/2_flamingo.png"),
			"gurita": preload("res://Card/Asset/laut/2_gurita.png"),
			"salmon": preload("res://Card/Asset/laut/2_salmon.png")
		},
		{
			"anjing laut": preload("res://Card/Asset/laut/3_anjing_laut.png"),
			"pelikan": preload("res://Card/Asset/laut/3_pelikan.png")
		},
		{
			"paus": preload("res://Card/Asset/laut/4_paus.png")
		}
	],
	TYPE_SUNGAI: [
		{
			"alga": preload("res://Card/Asset/sungai/0_alga.png"),
			"lumut": preload("res://Card/Asset/sungai/0_lumut.png")
		},
		{
			"ikan kecil": preload("res://Card/Asset/sungai/1_ikan_kecil.png"),
			"udang": preload("res://Card/Asset/sungai/1_udang.png")
		},
		{
			"ikan besar": preload("res://Card/Asset/sungai/2_ikan_besar.png")
		},
		{
			"bebek": preload("res://Card/Asset/sungai/3_bebek.png"),
			"berang-berang": preload("res://Card/Asset/sungai/3_otter.png"),
			"burung pelikan": preload("res://Card/Asset/sungai/3_pelikan.png")
		},
		{
			"beruang": preload("res://Card/Asset/sungai/4_beruang.png")
		},
	],
	TYPE_PADANG_RUMPUT: [
		{
			"pohon": preload("res://Card/Asset/padang rumput/0_pohon.png"),
			"rumput": preload("res://Card/Asset/padang rumput/0_rumput.png")
		},
		{
			"gajah": preload("res://Card/Asset/padang rumput/1_gajah.png"),
			"jerapah": preload("res://Card/Asset/padang rumput/1_jerapah.png"),
			"kelinci": preload("res://Card/Asset/padang rumput/1_kelinci.png"),
			"zebra": preload("res://Card/Asset/padang rumput/1_zebra.png")
		},
		{
			"ular": preload("res://Card/Asset/padang rumput/2_ular.png")
		},
		{
			"harimau": preload("res://Card/Asset/padang rumput/3_harimau.png"),
			"singa": preload("res://Card/Asset/padang rumput/3_singa.png"),
			"serigala": preload("res://Card/Asset/padang rumput/3_serigala.png")
		}
	],
	TYPE_PADANG_GURUN: [
		{
			"biji-bijian": preload("res://Card/Asset/padang gurun/0_biji.png"),
			"rumput": preload("res://Card/Asset/padang gurun/0_rumput.png")
		},
		{
			"burung": preload("res://Card/Asset/padang gurun/1_burung.png"),
			"kadal": preload("res://Card/Asset/padang gurun/1_kadal.png"),
			"rusa": preload("res://Card/Asset/padang gurun/1_rusa.png"),
			"tikus": preload("res://Card/Asset/padang gurun/1_tikus.png"),
			"unta": preload("res://Card/Asset/padang gurun/1_unta.png")
		},
		{
			"ular": preload("res://Card/Asset/padang gurun/2_ular.png")
		},
		{
			"elang": preload("res://Card/Asset/padang gurun/3_elang.png"),
			"serigala": preload("res://Card/Asset/padang gurun/3_serigala.png")
		},
	],
	TYPE_PADANG_ES: [
		{
			"fitoplankton": preload("res://Card/Asset/padang es/0_plankton.png"),
			"tanaman": preload("res://Card/Asset/padang es/0_tanaman.png")
		},
		{
			"ikan kecil": preload("res://Card/Asset/padang es/1_ikan_kecil.png"),
			"kelinci": preload("res://Card/Asset/padang es/1_kelinci.png")
		},
		{
			"musang": preload("res://Card/Asset/padang es/2_musang.png"),
			"burung hantu": preload("res://Card/Asset/padang es/2_owl.png"),
			"penguin": preload("res://Card/Asset/padang es/2_penguin.png")
		},
		{
			"elang": preload("res://Card/Asset/padang es/3_elang.png"),
			"serigala": preload("res://Card/Asset/padang es/3_serigala.png")
		},
		{
			"beruang": preload("res://Card/Asset/padang es/4_beruang.png")
		}
	]
}

const card_base = {
	TYPE_SAWAH: preload("res://Card/Asset/card base/sawah.png"),
	TYPE_HUTAN: preload("res://Card/Asset/card base/hutan.png"),
	TYPE_LAUT: preload("res://Card/Asset/card base/laut.png"),
	TYPE_SUNGAI: preload("res://Card/Asset/card base/sungai.png"),
	TYPE_PADANG_RUMPUT: preload("res://Card/Asset/card base/padang rumput.png"),
	TYPE_PADANG_GURUN: preload("res://Card/Asset/card base/padang pasir.png"),
	TYPE_PADANG_ES: preload("res://Card/Asset/card base/padang es.png")
}

const button_blank_normal = preload("res://Buttons/Assets/CardSelect/card-select-button-template.png")
const button_blank_pressed = preload("res://Buttons/Assets/CardSelect/card-pressed-button-template.png")
const button_blank_hinted = preload("res://Buttons/Assets/CardSelect/card-highlight-button-template.png")

var current_type = TYPE_SAWAH
var card_stock = null
var available_level = [1]
var current_cards = null
var from_comic = true

const tile_size = 180
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
		"column": 2,
		"position": CardPosition.DOWN
	},
	TYPE_HUTAN: {
		"row": 2,
		"column": 0,
		"position": CardPosition.RIGHT
	},
	TYPE_LAUT: {
		"row": 2,
		"column": 2,
		"position": CardPosition.RIGHT
	},
	TYPE_SUNGAI: {
		"row": 1,
		"column": 2,
		"position": CardPosition.DOWN
	},
	TYPE_PADANG_RUMPUT: {
		"row": 1,
		"column": 4,
		"position": CardPosition.DOWN
	},
	TYPE_PADANG_GURUN: {
		"row": 2,
		"column": 0,
		"position": CardPosition.RIGHT
	},
	TYPE_PADANG_ES: {
		"row": 1,
		"column": 3,
		"position": CardPosition.DOWN
	}
}
var selected_card = {
	"row": -1,
	"column": -1,
	"level": -1,
	"animal_name": null,
}

var wrong_penalty = 10
var enable_bonus = false
var input_enabled = true
var use_hint = false

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

const save_path = {
	"Windows": "res://savefile/savegame.save",
	"Android": "user://DORAMA_savefile.data"
}

func _ready():
	var save_game = File.new()
	var path = save_path[OS.get_name()]
	if save_game.file_exists(path):
		save_game.open(path, File.READ)
		save_dict = parse_json(save_game.get_line())
		save_game.close()

func save_game(score):
	save_dict[current_type]["score"] = score
	save_dict[current_type]["has_been_played"] = true
	var save_game = File.new()
	var path = save_path[OS.get_name()]
	save_game.open(path, File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()

func save():
	var save_game = File.new()
	var path = save_path[OS.get_name()]
	save_game.open(path, File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	
func add_availability(level):
	var up = (level+1)%max_hierarchy[current_type]
	
	if not available_level.has(up):
		available_level.append(up)
	if not available_level.has(level):
		available_level.append(level)

func set_cards(level):
	card_stock = []
	var card_set = cards[level]
	for i in range(card_set.size()):
		card_stock.append([])
		var card_map = card_set[i]
		var animals = card_map.keys()
		for j in range(animals.size()):
			card_stock[i].append(animals[j])
	
	current_cards = cards[level]

func can_consume(prey,predator):
	# Predator khusus pemakan serangga
	if predator.animal_name in ["laba-laba", "burung pipit", "katak"]:
		return prey.animal_name in Global.animal_categories["serangga"] and prey.level == 2
	# Ular gabisa makan hewan gede
	if predator.animal_name == "ular":
		if current_type == TYPE_SAWAH:
			return (
				not(prey.animal_name in Global.animal_categories["hewan besar"])
				and (prey.level <= 3 and prey.level >= 2)
			)
		else:
			return not(prey.animal_name in Global.animal_categories["hewan besar"]) and prey.level == 2
	# Penguin cuma bisa makan ikan
	if predator.animal_name == "penguin":
		return prey.animal_name in Global.animal_categories["hewan air"] and prey.level == 2
	# Produsen air cuma bisa dimakan herbivore air
	if prey.animal_name in Global.animal_categories["produsen air"]:
		return predator.animal_name in Global.animal_categories["hewan air"] and predator.level == 1
	
	# General consuming terms
	if prey.level <= 1:
		return prey.level == predator.level
	else:
		return prey.level <= predator.level

func reset_score():
	save_dict = {
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
	Global.save()
