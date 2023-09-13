extends Node2D

onready var sprite = $AnimatedSprite

var coords
var is_alive
var visage

var board

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	is_alive = true
	visage = Global.get_setting("sweetheart_visage")
	sprite.animation = Global.CHARACTERS[visage]["name"]

func burn():
	is_alive = false
	sprite.animation = "ashes"
	return true