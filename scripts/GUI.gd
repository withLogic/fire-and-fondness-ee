extends CanvasLayer

const win_lines = [
	"TRUE ROMANCE ACHIEVED",
	"You are the champion\nof all things.",
	"Rose acquired,\nsweetheart uncooked.\nMission accomplished.",
	"THIS STORY IS HAPPY END",
	"This is what we call\na 'fire flower'."
]

const roseless_win_lines = [
	"Disregarded roses;\nescaped burning building.",
	"The flowers were\nwilting, anyway."
]

const gameover_lines = [
	"How unromantic.",
	"Your insurance\nwon't cover this.",
	"Forever alone.\nAnd somewhat charred.",
	"The course of true love\nusually doesn't involve\nthird-degree burns.",
	"If you would be loved,\nremain uncauterised.",
	"Maybe being single\nisn't so bad..."
]

onready var shader = $Shader
onready var message = $NextFire
onready var roses = $Margin/Roses
onready var big_message = $BigMessage
onready var intro = $LevelIntro

func _ready():
	if Global.get_setting("use_shader"):
		shader.show()
	else:
		shader.hide()

func play_intro(title, subtitle):
	intro.play(title, subtitle)

func set_label(text):
	message.text = text

func set_message(message):
	big_message.text = message

func set_message_to_one_of(array):
	randomize()
	var message = array[rand_range(0, array.size())]
	set_message(message)

func get_win_lines(visage):
	var character = Global.CHARACTERS[visage]
	if character["has_custom_lines"] == true:
		return character["lines"]["win"]
	return win_lines

func get_roseless_win_lines(visage):
	var character = Global.CHARACTERS[visage]
	if character["has_custom_lines"] == true:
		return character["lines"]["roseless_win"]
	return roseless_win_lines

func get_gameover_lines(visage):
	var character = Global.CHARACTERS[visage]
	if character["has_custom_lines"] == true:
		return character["lines"]["game_over"]
	return gameover_lines

func got_roses():
	roses.show()

func reset():
	get_tree().reload_current_scene()

func menu():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
