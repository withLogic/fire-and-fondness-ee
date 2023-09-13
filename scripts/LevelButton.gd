extends HBoxContainer

onready var button = $Button
onready var label_title = $VBox/Title
onready var label_status = $VBox/Status
onready var label_roses = $VBox/Roses

var num
var title
var par
var best
var unlocked
var scene
var got_roses

func _ready():
	button.text = num
	label_title.text = title
	if !unlocked:
		label_status.text = "Locked"
		button.disabled = true
	elif best == -1:
		label_status.text = "New!"
		button.grab_focus()
	else:
		label_status.text = "Par: %s    Best: %s" % [par, best]
		button.grab_focus();
		if got_roses:
			label_roses.show()

func pressed():
	get_tree().change_scene(scene)
