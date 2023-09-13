extends VBoxContainer

onready var label_title = $Label_YourVisage
onready var texture_visage = $HBox/SelectedVisage
onready var label_visage = $Label_VisageName

export (String) var title
export (String) var setting_label
var index

func _ready():
	index = Global.get_setting(setting_label)
	label_title.text = title
	set_visage_display(index)

func set_visage_display(visage):
	var texture = Global.CHARACTERS[visage]["texture"]
	texture_visage.texture = load(texture)
	label_visage.text = Global.CHARACTERS[visage]["name"]
	Global.set_setting(setting_label, visage)

func change_index(change):
	var good = false
	while !good:
		index += change
		# Wrap around
		if index >= len(Global.CHARACTERS):
			index = 0
		elif index == -1:
			index = len(Global.CHARACTERS) - 1
		# Check if the character is unlocked
		var unlocked = Global.game_progress["characters"][index]
		if unlocked: good = true
	# Set the texture/label
	set_visage_display(index)

func next():
	change_index(1)

func previous():
	change_index(-1)
