extends Node2D

onready var sprite = $AnimatedSprite

const COLOURS = {
	0: Color(0.8, 0.2, 0.2),
	1: Color(0.6, 0.6, 0.2),
	2: Color(0.2, 0.8, 0.2),
	3: Color(0.2, 0.8, 1)
}

var colour
var pos_left
var coords

var board

signal flipped(colour)

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	sprite.modulate = COLOURS[colour]
	pos_left = true

func flip():
	emit_signal("flipped", colour)
	pos_left = !pos_left
	if pos_left: sprite.animation = "left"
	else: sprite.animation = "right"