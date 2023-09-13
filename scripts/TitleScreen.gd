extends CanvasLayer

const SUBTITLES = [
	"A game about finding true love in a burning building.",
	"Not based on a true story (we sincerely hope).",
	"Soon to be a major motion picture!"
]

onready var play_button = $MarginContainer/Center/VBox/HBox/VBox/PlayButton
onready var shader = $Shader

func _ready():
	randomize()
	play_button.grab_focus()

func play():
	get_tree().change_scene("res://scenes/LevelSelect.tscn")

func instructions():
	get_tree().change_scene("res://scenes/Instructions.tscn")

func options():
	get_tree().change_scene("res://scenes/Options.tscn")

func quit():
	get_tree().quit()
