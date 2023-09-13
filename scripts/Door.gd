extends Node2D

onready var sprite = $AnimatedSprite

const COLOURS = {
	0: Color(0.8, 0.2, 0.2),
	1: Color(0.6, 0.6, 0.2),
	2: Color(0.2, 0.8, 0.2),
	3: Color(0.2, 0.8, 1)
}

var coords
var colour
var pos
var is_open

var board

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	sprite.modulate = COLOURS[colour]
	if is_open: sprite.animation = pos + "_" + "open"
	else: sprite.animation = pos + "_" + "closed"

func toggle():
	is_open = !is_open
	if is_open:
		sprite.animation = pos + "_" + "open"
		$AudioStreamPlayer_Open.play()
	else:
		sprite.animation = pos + "_" + "closed"
		$AudioStreamPlayer_Close.play()