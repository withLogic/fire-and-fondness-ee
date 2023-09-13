extends Node

const SAVE_PATH = "user://fire_and_fondness.sav"

const ROTATION_NONE = 0
const ROTATION_H = 1
const ROTATION_DIR = 2

const LEVELS = {
	"original1": {
		"num": "1",
		"id": "original1",
		"title": "Where There's Smoke",
		"subtitle": "(there may also be romance)",
		"par": 11,
		"next_level": "original2",
		"scene": "res://scenes/Level1.tscn",
		"unlocked_at_start": true
	},
	"original2": {
		"num": "2",
		"id": "original2",
		"title": "The Corridor",
		"subtitle": "...of periodic fire",
		"par": 17,
		"next_level": "original3",
		"scene": "res://scenes/Level2.tscn",
		"unlocked_at_start": false
	},
	"original3": {
		"num": "3",
		"id": "original3",
		"title": "Mo' Fires, Mo' Problems",
		"subtitle": "what do you want it's hard coming up with so many of these",
		"par": 27,
		"next_level": "new1",
		"scene": "res://scenes/Level3.tscn",
		"unlocked_at_start": false
	},
	"new1": {
		"num": "4",
		"id": "new1",
		"title": "Teleportation",
		"subtitle": "and other factors of love",
		"par": 53,
		"next_level": "new2",
		"scene": "res://scenes/Level4.tscn",
		"unlocked_at_start": false
	},
	"new2": {
		"num": "5",
		"id": "new2",
		"title": "Moved by Love",
		"subtitle": "(and also movers)",
		"par": 34,
		"next_level": null,
		"scene": "res://scenes/Level5.tscn",
		"unlocked_at_start": false
	}
}

const CHARACTERS = [
	{
		"id": 0,
		"name": "Gallant",
		"texture": "res://sprites/player.png",
		"rotation": ROTATION_NONE,
		"unlocked_at_start": true,
		"has_custom_lines": false
	},
	{
		"id": 1,
		"name": "Fair",
		"texture": "res://sprites/lady.png",
		"rotation": ROTATION_NONE,
		"unlocked_at_start": true,
		"has_custom_lines": false
	},
	{
		"id": 2,
		"name": "Frog",
		"texture": "res://sprites/frog.png",
		"rotation": ROTATION_NONE,
		"unlocked_at_start": true,
		"has_custom_lines": true,
		"lines": {
			"win": ["ribbit"],
			"roseless_win": ["ribbit"],
			"game_over": ["ribbit"]
		}
	},
	{
		"id": 3,
		"name": "Zombie",
		"texture": "res://sprites/zombie.png",
		"rotation": ROTATION_H,
		"unlocked_at_start": true,
		"has_custom_lines": true,
		"lines": {
			"win": ["BRAAAAINS\n(and also flowers)"],
			"roseless_win": ["brains", "BRAAAINS"],
			"game_over": ["BRRRaaaiiinnnsss"]
		}
	}
]

# Because the final level's rose is unattainable, the player can only get three points in it
const BEST_SCORE_POSSIBLE = 15
const MINIMUM_WIN_SCORE = 6

var game_progress

static func make_level_record(level_id):
	var level = LEVELS[level_id]
	var new_level = {
		"unlocked": level["unlocked_at_start"],
		"got_roses": false,
		"best_time": -1,
		"cleared": false
	}
	return new_level

static func new_game():
	var save = {
		"levels": {},
		"characters": [],
		"settings": {
			"player_visage": 0,
			"sweetheart_visage": 1,
			"use_shader": true,
			"scanlines": true,
			"screen_warp": true,
			"glow": true,
			"transition": true,
			"camera_shake": true
		}
	}
	var levels = save["levels"]
	var characters = save["characters"]
	# Add the levels
	for next_level in LEVELS:
		var new_level = make_level_record(next_level)
		levels[next_level] = new_level
	# Add the characters
	for next_character in CHARACTERS:
		var character_id = next_character["id"]
		characters.append(next_character["unlocked_at_start"])
	return save

static func load_game():
	print("%s: loading game" % OS.get_ticks_msec())
	var file = File.new()
	# Make sure a saved game actually exists
	var save_exists = file.file_exists(SAVE_PATH)
	# If it does, open the file, read/parse its contents, and return them
	if save_exists:
		print("%s: existing save found; loading" % OS.get_ticks_msec())
		file.open(SAVE_PATH, File.READ)
		var contents = file.get_as_text()
		var save = parse_json(contents)
		return save
	# If no saved game exists, make a new one
	else:
		print("%s: no existing save found; making fresh save" % OS.get_ticks_msec())
		return new_game()

static func save_game(save):
	print("%s: saving game" % OS.get_ticks_msec())
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_line(to_json(save))
	file.close()

static func get_next_level(level_id):
	return LEVELS[level_id]["next_level"]

static func get_scene_for_level(level_id):
	return LEVELS[level_id]["scene"]

func set_level_progress(level_id, got_roses, moves):
	var level = game_progress["levels"][level_id]
	level["cleared"] = true
	# Did we set a new best time for this level?
	if level["best_time"] > moves || level["best_time"] == -1:
		level["best_time"] = moves
	# Only bother with this bit if the player hasn't yet cleared the level with the roses
	if !level["got_roses"]:
		level["got_roses"] = got_roses
	# Unlock the next level, if it exists
	var next_level = get_next_level(level_id)
	if next_level != null:
		game_progress["levels"][next_level]["unlocked"] = true
	# Save the game
	save_game(game_progress)

func get_level_score(id):
	var level = Global.LEVELS[id]
	var level_progress = Global.game_progress["levels"][id]
	var par = level["par"]
	var best_time = level_progress["best_time"]
	var score = 0
	if level_progress["cleared"]: score += 1
	if level_progress["got_roses"]: score += 1
	if best_time <= par && best_time != -1:
		score += 1
	return score

func get_total_score():
	var total_score = 0
	for next_id in LEVELS:
		var next_score = get_level_score(next_id)
		total_score += next_score
	return total_score

func got_all_roses():
	var got_all_roses = true
	for next_id in LEVELS:
		var got_roses = Global.game_progress["levels"][next_id]["got_roses"]
		if !got_roses: got_all_roses = false
	return got_all_roses

func got_all_pars():
	var got_all_pars = true
	for next_id in LEVELS:
		var best_time = Global.game_progress["levels"][next_id]["best_time"]
		var par = Global.LEVELS[next_id]["par"]
		if best_time > par: got_all_pars = false
	return got_all_pars

func get_completion():
	var total_score = get_total_score()
	return float(total_score) / float(BEST_SCORE_POSSIBLE)

func get_setting(label):
	return game_progress["settings"][label]

func set_setting(label, value):
	game_progress["settings"][label] = value

func _ready():
	game_progress = load_game()
