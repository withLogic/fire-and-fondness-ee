extends Node2D

var coords
var board

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
