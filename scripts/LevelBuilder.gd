extends Node

onready var obj_player = preload("res://objects/Player.tscn")
onready var obj_door = preload("res://objects/Door.tscn")
onready var obj_switch = preload("res://objects/Switch.tscn")
onready var obj_flamethrower = preload("res://objects/Flamethrower.tscn")
onready var obj_roses = preload("res://objects/Roses.tscn")
onready var obj_sweetheart = preload("res://objects/Sweetheart.tscn")
onready var obj_mover = preload("res://objects/Mover.tscn")
onready var obj_teleporter = preload("res://objects/Teleporter.tscn")
onready var obj_teleport_target = preload("res://objects/TeleportTarget.tscn")

const BLOCKS = {
	0: {"label": "wall", "remove_tile": false},
	1: {"label": "player", "remove_tile": true},
	2: {"label": "sweetheart", "remove_tile": true},
	3: {"label": "roses", "remove_tile": true},
	4: {"label": "door", "id": 0, "pos": "h", "open": false, "remove_tile": true},
	5: {"label": "door", "id": 0, "pos": "h", "open": true, "remove_tile": true},
	6: {"label": "door", "id": 0, "pos": "v", "open": false, "remove_tile": true},
	7: {"label": "door", "id": 0, "pos": "v", "open": true, "remove_tile": true},
	8: {"label": "door", "id": 1, "pos": "h", "open": false, "remove_tile": true},
	9: {"label": "door", "id": 1, "pos": "h", "open": true, "remove_tile": true},
	10: {"label": "door", "id": 1, "pos": "v", "open": false, "remove_tile": true},
	11: {"label": "door", "id": 1, "pos": "v", "open": true, "remove_tile": true},
	12: {"label": "door", "id": 2, "pos": "h", "open": false, "remove_tile": true},
	13: {"label": "door", "id": 2, "pos": "h", "open": true, "remove_tile": true},
	14: {"label": "door", "id": 2, "pos": "v", "open": false, "remove_tile": true},
	15: {"label": "door", "id": 2, "pos": "v", "open": true, "remove_tile": true},
	16: {"label": "door", "id": 3, "pos": "h", "open": false, "remove_tile": true},
	17: {"label": "door", "id": 3, "pos": "h", "open": true, "remove_tile": true},
	18: {"label": "door", "id": 3, "pos": "v", "open": false, "remove_tile": true},
	19: {"label": "door", "id": 3, "pos": "v", "open": true, "remove_tile": true},
	20: {"label": "switch", "id": 0, "remove_tile": true},
	21: {"label": "switch", "id": 1, "remove_tile": true},
	22: {"label": "switch", "id": 2, "remove_tile": true},
	23: {"label": "switch", "id": 3, "remove_tile": true},
	24: {"label": "flamethrower", "id": 0, "remove_tile": true},
	25: {"label": "flamethrower", "id": 1, "remove_tile": true},
	26: {"label": "flamethrower", "id": 2, "remove_tile": true},
	27: {"label": "flamethrower", "id": 3, "remove_tile": true},
	28: {"label": "mover", "direction": "left", "remove_tile": true},
	29: {"label": "mover", "direction": "right", "remove_tile": true},
	30: {"label": "mover", "direction": "up", "remove_tile": true},
	31: {"label": "mover", "direction": "down", "remove_tile": true},
	32: {"label": "teleporter", "id": 0, "remove_tile": true},
	33: {"label": "teleporter", "id": 1, "remove_tile": true},
	34: {"label": "teleporter", "id": 2, "remove_tile": true},
	35: {"label": "teleporter", "id": 3, "remove_tile": true},
	36: {"label": "teleport_target", "id": 0, "remove_tile": true},
	37: {"label": "teleport_target", "id": 1, "remove_tile": true},
	38: {"label": "teleport_target", "id": 2, "remove_tile": true},
	39: {"label": "teleport_target", "id": 3, "remove_tile": true}
}

var tilemap
var board

var player
var roses
var sweetheart
var doors = []
var switches = []
var flamethrowers = []
var movers = []
var teleport_targets = []

func make_player(x, y):
	print("Adding player @ [%s, %s]" % [x, y])
	player = obj_player.instance()
	player.coords = [x, y]
	player.board = board
	board.connect("player_move", player, "move")
	board.add_child(player)

func make_door(x, y, colour, pos, open):
	print("Adding door @ [%s, %s], pos=%s, id=%s, open=%s" % [x, y, pos, colour, open])
	var new_door = obj_door.instance()
	new_door.coords = [x, y]
	new_door.colour = colour
	new_door.pos = pos
	new_door.is_open = open
	new_door.board = board
	board.connect("toggle_doors", new_door, "toggle")
	doors.append(new_door)
	board.add_child(new_door)

func make_switch(x, y, colour):
	print("Adding switch @ [%s, %s], id=%s" % [x, y, colour])
	var new_switch = obj_switch.instance()
	new_switch.coords = [x, y]
	new_switch.colour = colour
	new_switch.board = board
	new_switch.connect("flipped", board, "switch_flipped")
	switches.append(new_switch)
	board.add_child(new_switch)

func make_flamethrower(x, y):
	print("Adding flamethrower @ [%s, %s]" % [x, y])
	var new_flamethrower = obj_flamethrower.instance()
	new_flamethrower.coords = [x, y]
	new_flamethrower.board = board
	flamethrowers.append(new_flamethrower)
	board.add_child(new_flamethrower)

func make_roses(x, y):
	print("Adding roses @ [%s, %s]" % [x, y])
	roses = obj_roses.instance()
	roses.coords = [x, y]
	roses.board = board
	board.add_child(roses)

func make_sweetheart(x, y):
	print("Adding sweetheart @ [%s, %s]" % [x, y])
	sweetheart = obj_sweetheart.instance()
	sweetheart.coords = [x, y]
	sweetheart.board = board
	board.add_child(sweetheart)

func make_mover(x, y, direction):
	print("Adding mover @ [%s, %s], dir=%s" % [x, y, direction])
	var new_mover = obj_mover.instance()
	new_mover.coords = [x, y]
	new_mover.direction = direction
	new_mover.board = board
	board.connect("refresh_movers", new_mover, "refresh")
	movers.append(new_mover)
	board.add_child(new_mover)

func make_teleporter(x, y, id):
	print("Adding teleporter @ [%s, %s], id=%s" % [x, y, id])
	var new_teleporter = obj_teleporter.instance()
	new_teleporter.coords = [x, y]
	new_teleporter.id = id
	new_teleporter.board = board
	movers.append(new_teleporter)
	board.add_child(new_teleporter)
	
func make_teleport_target(x, y, id):
	print("Adding teleport target @ [%s, %s], id=%s" % [x, y, id])
	var new_teleport_target = obj_teleport_target.instance()
	new_teleport_target.coords = [x, y]
	new_teleport_target.id = id
	new_teleport_target.board = board
	teleport_targets.append(new_teleport_target)
	board.add_child(new_teleport_target)

func set_tile(x, y):
	var tile_id = tilemap.get_cell(x, y)
	# A value of -1 indicates that this cell is empty
	if tile_id != -1:
		var block = BLOCKS[tile_id]
		match block["label"]:
			"player": make_player(x, y)
			"door": make_door(x, y, block["id"], block["pos"], block["open"])
			"switch": make_switch(x, y, block["id"])
			"flamethrower": make_flamethrower(x, y)
			"roses": make_roses(x, y)
			"sweetheart": make_sweetheart(x, y)
			"mover": make_mover(x, y, block["direction"])
			"teleporter": make_teleporter(x, y, block["id"])
			"teleport_target": make_teleport_target(x, y, block["id"])
		if block["remove_tile"]:
			tilemap.set_cell(x, y, -1)

func init_tilemap(board, tilemap):
	self.board = board
	self.tilemap = tilemap
	for y in range(0, 16):
		for x in range(0, 16):
			set_tile(x, y)