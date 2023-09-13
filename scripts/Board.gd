extends Node

const obj_levelbuilder = preload("res://scripts/LevelBuilder.gd")

export (NodePath) var path_tilemap
onready var tilemap = get_node(path_tilemap)

export (NodePath) var path_camera
onready var camera = get_node(path_camera)
onready var camera_position = camera.position

export (String) var level_id
onready var current_level = Global.LEVELS[level_id]

onready var firemaker = $Firemaker
onready var gui = $GUI
onready var timer_win = $Timer_Win
onready var timer_lose = $Timer_Lose
onready var audio_win = $Audio_Win
onready var audio_lose = $Audio_Lose

const TILE_SIZE = 8

var player
var roses
var sweetheart
var doors = []
var switches = []
var flamethrowers = []
var movers = []
var teleport_targets = []

var moves
var got_roses

var camera_shake

signal player_move(id)
signal toggle_doors(colour)
signal movers_finished
signal refresh_movers

func add_coords(a, b):
	return [a[0] + b[0], a[1] + b[1]]

func coords_equal(a, b):
	return a[0] == b[0] && a[1] == b[1]

func space_open(coords):
	var tile = tilemap.get_cell(coords[0], coords[1])
	print(coords, " is ", tile)
	# If it's a wall, it isn't open
	if tile == 0:
		return false
	# Is there a door here?
	for next_door in doors:
		if coords_equal(coords, next_door.coords):
			# If the door is closed, the space is closed
			if next_door.is_open == false:
				return false
	return true

func get_switch_at_coord(coords):
	for next_switch in switches:
		if coords_equal(next_switch.coords, coords):
			return next_switch
	return null

func player_at_tile(coord):
	if !got_roses:
		if coords_equal(player.coords, roses.coords):
			print("Getting the roses!")
			gui.set_label("Got the roses!")
			roses.pickup()
			got_roses = true
			gui.got_roses()

func switch_flipped(colour):
	# Toggle all the doors with the same colour as the switch that was just flipped
	for next_door in doors:
		if next_door.colour == colour:
			next_door.toggle()

func burn_tile(coord):
	# Does this burn anyone?
	for next in [player, sweetheart, roses]:
		if coords_equal(coord, next.coords):
			var burned = next.burn()
			if burned: gui.set_label("I smell burning romance.")

func get_teleport_target(id):
	for next_target in teleport_targets:
		if next_target.id == id:
			return next_target
	return null

func add_camera_shake(amount):
	camera_shake += amount
	camera_shake = clamp(camera_shake, 0, 1)

func _process(delta):
	if Global.get_setting("camera_shake") == true:
		if camera_shake > 0:
			var shake_amount = 3 * pow(camera_shake, 2)
			camera.offset.x = randf() * shake_amount
			camera.offset.y = randf() * shake_amount
			if camera_shake > delta/2: camera_shake -= delta/2
			else: camera_shake = 0

func game_over():
	var lines = gui.get_gameover_lines(player.visage)
	gui.set_message_to_one_of(lines)
	audio_lose.play()
	timer_lose.start()

func level_clear():
	# Display the win message
	if got_roses:
		var lines = gui.get_win_lines(player.visage)
		gui.set_message_to_one_of(lines)
	else:
		var lines = gui.get_roseless_win_lines(player.visage)
		gui.set_message_to_one_of(lines)
	# Save the record of this win
	Global.set_level_progress(level_id, got_roses, moves)
	# Give the user a bit of time to bask in their glory before moving on
	audio_win.play()
	timer_win.start()

func player_move():
	print("Player's move started")
	# Tell the player to move
	emit_signal("player_move", player.id)
	moves += 1

func any_movers_active():
	# Tell the movers that they can move again
	emit_signal("refresh_movers")
	var result = false
	for next_mover in movers:
		var moving = next_mover.anything_to_move()
		if moving == true: result = true
	return result

func process_movers():
	var any_moved = true
	while any_moved == true:
		any_moved = false
		for next_mover in movers:
			var moving = next_mover.check_for_moveable()
			if moving == true:
				any_moved = true
				yield(next_mover, "finished")
	emit_signal("movers_finished")

func process_firemaker():
	var firing = firemaker.check_for_fire()
	if firing:
		gui.set_label("Fire!")
		return true
	else: return false

func is_game_over():
	if !player.is_alive:
		print("The player is dead; game over")
		return true
	if !sweetheart.is_alive:
		print("The sweetheart is dead; game over")
		return true
	return false

func turn():
	var next_fire = firemaker.countdown
	gui.set_label("Next fire in: " + str(next_fire))
	print("%s: player's move" % OS.get_ticks_msec())
	player_move()
	yield(player, "moved")
	# Do the movers/teleporters need to move anything?
	print("%s: processing movers" % OS.get_ticks_msec())
	var something_to_move = any_movers_active()
	if something_to_move:
		process_movers()
		yield(self, "movers_finished")
	# Flamethrowers, go!
	print("%s: processing firemaker" % OS.get_ticks_msec())
	var firing = process_firemaker()
	if firing: yield(firemaker, "finished")
	# Has anyone important been toasted?
	var can_continue = !is_game_over()
	if !can_continue: 
		game_over()
	else:
		# Has the player just won?
		if coords_equal(player.coords, sweetheart.coords):
			level_clear()
		# Otherwise, just go onto the next turn
		else: turn()

func build_level():
	var levelbuilder = obj_levelbuilder.new()
	self.add_child(levelbuilder)
	levelbuilder.init_tilemap(self, tilemap)
	player = levelbuilder.player
	sweetheart = levelbuilder.sweetheart
	roses = levelbuilder.roses
	doors = levelbuilder.doors
	switches = levelbuilder.switches
	flamethrowers = levelbuilder.flamethrowers
	movers = levelbuilder.movers
	teleport_targets = levelbuilder.teleport_targets

func _ready():
	camera_shake = 0
	moves = 0
	got_roses = false
	# Set up firemaker
	firemaker.board = self
	# Build the level and get its contents from the builder
	build_level()
	# Shiny intro!
	gui.play_intro(current_level["title"], current_level["subtitle"])
	turn()

func restart():
	# Restart the level
	get_tree().reload_current_scene()

func next_level():
	# Either go to the win screen, or the next level
	var next_level = Global.get_next_level(level_id)
	var next_scene
	if next_level == null: next_scene = "res://scenes/YouWin.tscn"
	else: next_scene = Global.get_scene_for_level(next_level)
	get_tree().change_scene(next_scene)
