extends Node2D
const MAX_MOVES = 1

onready var sprite = $AnimatedSprite

var id
var visage
var coords # coords as far as the board is concerned
var is_alive
var moving # Only applies if controlled by human player
var moves

var board # So we can look at the map and such

signal moved

func _ready():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE
	is_alive = true
	moving = false
	moves = MAX_MOVES
	visage = Global.get_setting("player_visage")
	sprite.animation = Global.CHARACTERS[visage]["name"]

func move(move_id):
	# First, make sure it's us the signal is talking about
	if move_id != id: return
	moving = true

func try_to_move(change_x, change_y, h_flip, rotate):
	var new_coord = [coords[0]+change_x, coords[1]+change_y]
	if board.space_open(new_coord):
		coords = new_coord
		moves -= 1
		$AudioStreamPlayer_Step.play()
		update_position()
		# Tell the board where we are
		board.player_at_tile(coords)
	match Global.CHARACTERS[visage]["rotation"]:
		Global.ROTATION_H:
			if h_flip != -1: sprite.flip_h = h_flip
		

func interact():
	# Are there any switches where we're standing?
	var switchy_thing = board.get_switch_at_coord(coords) # 'switch' is reserved
	if switchy_thing != null:
		print("Flippin' a switch")
		switchy_thing.flip()
		moves -= 1

func burn():
	print("Player is burning!")
	is_alive = false
	sprite.animation = "ashes"
	sprite.rotation_degrees = 0
	return true

func update_position():
	position.x = coords[0] * board.TILE_SIZE
	position.y = coords[1] * board.TILE_SIZE

func player_input():
	if Input.is_action_just_pressed("move_up"): try_to_move(0, -1, -1, -90)
	if Input.is_action_just_pressed("move_down"): try_to_move(0, 1, -1, 90)
	if Input.is_action_just_pressed("move_left"): try_to_move(-1, 0, 1, 180)
	if Input.is_action_just_pressed("move_right"): try_to_move(1, 0, 0, 0)
	if Input.is_action_just_pressed("interact"): interact()
	# Have we run out of moves?
	if moves == 0:
		moving = false
		moves = MAX_MOVES
		emit_signal("moved")

func _physics_process(delta):
	if moving:
		player_input()
