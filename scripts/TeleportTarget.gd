extends Node2D

const COLOURS = {
	0: Color(0.8, 0.2, 0.2),
	1: Color(0.6, 0.6, 0.2),
	2: Color(0.2, 0.8, 0.2),
	3: Color(0.2, 0.8, 1)
}

onready var sprite = $Sprite

var coords
var id
var board

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	sprite.modulate = COLOURS[id]