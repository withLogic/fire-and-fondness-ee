extends Node2D

const OFFSETS = {
	"up": [0, -1],
	"down": [0, 1],
	"left": [-1, 0],
	"right": [1, 0]
}

onready var sprite = $AnimatedSprite
onready var audio = $Audio
onready var timer = $Timer

var coords
var direction
var offset
var board

var can_move

signal finished

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	sprite.animation = direction
	offset = OFFSETS[direction]
	can_move = true

func anything_to_move():
	var player = board.player
	if board.coords_equal(coords, player.coords) && can_move:
		return true
	else:
		return false

# Returns true if it's going to shunt something, so the board knows to wait
func check_for_moveable():
	var player = board.player
	# If the player is steppin', they need to step off
	if board.coords_equal(coords, player.coords) && can_move:
		# We want there to be a slight delay, so the player can actually see that they've moved
		print("Mover @ [%s, %s] is moving" % [coords[0], coords[1]])
		timer.start()
		return true
	else:
		return false

func move_player():
	# Make sure it isn't trying to send the player into a wall
	var player = board.player
	var new_coords = board.add_coords(player.coords, offset)
	if board.space_open(new_coords):
		player.coords = new_coords
		player.update_position()
	audio.play()
	can_move = false
	emit_signal("finished")

func refresh():
	can_move = true