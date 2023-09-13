extends Node2D

const COLOURS = {
	0: Color(0.8, 0.2, 0.2),
	1: Color(0.6, 0.6, 0.2),
	2: Color(0.2, 0.8, 0.2),
	3: Color(0.2, 0.8, 1)
}

onready var sprite = $Sprite
onready var audio = $Audio
onready var timer = $Timer

var coords
var id
var board

signal finished

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	sprite.modulate = COLOURS[id]

func anything_to_move():
	var player = board.player
	if board.coords_equal(coords, player.coords):
		return true
	else:
		return false

# Returns true if it's going to shunt something, so the board knows to wait
func check_for_moveable():
	var player = board.player
	# If the player is steppin', they need to step off
	if board.coords_equal(coords, player.coords):
		# We want there to be a slight delay, so the player can actually see that they've moved
		print("Teleporter @ [%s, %s] is teleporting" % [coords[0], coords[1]])
		timer.start()
		audio.play()
		return true
	else:
		return false

func move_player():
	# Make sure it isn't trying to send the player into a wall
	var player = board.player
	var target = board.get_teleport_target(id)
	player.coords = target.coords
	player.update_position()
	emit_signal("finished")