extends Node2D

var tile_button = preload("res://Buttons/TileButton.tscn")

var offset_x = 16
var offset_y = 92
var gap_size = 0

var pos_x = 0
var pos_y = 0
var new_tile

var tiles = []
var tile_corners = []
signal tile_selected(tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_tile_corners():
	tile_corners.append(Vector2(0,0))
	tile_corners.append(Vector2(Global.tile_size,0))
	tile_corners.append(Vector2(Global.tile_size,Global.tile_size))
	tile_corners.append(Vector2(0,Global.tile_size))


func _init():
	create_tile_corners()
	
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
	print('signal caught')
	highlight_adj_tile(tile.row, tile.column)

func highlight_adj_tile(row, column):
	# Down
	if row+1<Global.board_row and tiles[row+1][column] is TextureButton:
		tiles[row+1][column].set_highlight(true)
	# Up
	if row-1>=0 and tiles[row-1][column] is TextureButton:
		tiles[row-1][column].set_highlight(true)
	# Right
	if column+1<Global.board_column and tiles[row][column+1] is TextureButton:
		tiles[row][column+1].set_highlight(true)
	# Left
	if column-1>=0 and tiles[row][column-1] is TextureButton:
		tiles[row][column-1].set_highlight(true)
