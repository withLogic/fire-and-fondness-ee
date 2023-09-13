extends Node2D

onready var sprite = $AnimatedSprite
onready var sound = $AudioStreamPlayer

var coords
var is_alive
var picked

var board

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	is_alive = true
	picked = false

func pickup():
	if is_alive && !picked:
		sprite.hide()
		sound.play()
		picked = true

# Returns whether or not the item burned
func burn():
	if !picked && is_alive:
		is_alive = false
		sprite.animation = "ashes"
		return true
	else: return false