extends CanvasLayer

onready var back = $CenterContainer/VBoxContainer/BackButton

func _ready():
	back.grab_focus()

func back():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
