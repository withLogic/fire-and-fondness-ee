extends Node

const obj_flame = preload("res://objects/FlameParticle.tscn")

onready var audio_flames_start = $AudioStreamPlayer_FlamesStart
onready var audio_flames_spread = $AudioStreamPlayer_FlamesSpread
onready var audio_flames_end = $AudioStreamPlayer_FlamesEnd
onready var flame_timer = $FlameTimer
onready var end_timer = $EndTimer

var flames
var flame_distance

var cooldown = 9
var countdown = 9

var board

signal finished

func add_coords(a, b):
	return [a[0] + b[0], a[1] + b[1]]

func coords_equal(a, b):
	return a[0] == b[0] && a[1] == b[1]

func get_next_open(open, closed):
	var best_open = null
	var best_distance = 999
	for next_open in open:
		if next_open[1] < best_distance && !coord_closed(next_open[0], closed):
			best_open = next_open
			best_distance = next_open[1]
	return best_open

func coord_closed(coord, closed):
	for next in closed:
		if coords_equal(next[0], coord): return true
	return false

func make_open_list():
	var open = []
	for next_flamethrower in board.flamethrowers:
		var new_open = [next_flamethrower.coords, 0]
		open.append(new_open)
	return open

func search_for_fires():
	var open = make_open_list()
	var closed = []
	var done = false
	while !done:
		var next = get_next_open(open, closed)
		if next != null:
			# Get all neighbours
			var changes = [[1, 0], [-1, 0], [0, 1], [0, -1]]
			for next_change in changes:
				var point = add_coords(next[0], next_change)
				if board.space_open(point) && !coord_closed(point, closed):
					open.append([point, next[1] + 1])
			closed.append(next)
		# If the open list is empty, we're done
		else:
			done = true
	return closed

func spread_flames():
	var any_flames = false
	for next_flame in flames:
		if next_flame[1] == flame_distance:
			print("Making fire at ", next_flame[0])
			var new_flame = obj_flame.instance()
			new_flame.coords = next_flame[0]
			new_flame.board = board
			board.add_child(new_flame)
			board.burn_tile(next_flame[0])
			any_flames = true
	if any_flames:
		flame_distance += 1
		flame_timer.wait_time = 0.2
		flame_timer.start()
		audio_flames_spread.play()
		board.add_camera_shake(1)
	else:
		audio_flames_end.play()
		end_timer.start()

func fire():
	countdown = cooldown
	flames = search_for_fires()
	flame_distance = 0
	flame_timer.wait_time = 1
	flame_timer.start()
	audio_flames_start.play()

func check_for_fire():
	countdown -= 1
	if countdown == 0:
		print("%s: firemaker is firing" % OS.get_ticks_msec())
		fire()
		countdown = cooldown
		return true
	else:
		print("%s: no fire this turn" % OS.get_ticks_msec())
		return false

func finished():
	emit_signal("finished")
