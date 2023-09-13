extends Control

onready var label_text = $Text
onready var timer = $Timer

export (String) var story
var chars
var type_speed

func _ready():
	label_text.text = story
	chars = 0
	timer.start()
	type_speed = 1

func tick():
	var next_char = story.substr(chars, 1)
	# Display the next character
	chars += 1
	label_text.text = story.substr(0, chars)
	# Stop if we've reached the end
	if chars >= len(story):
		timer.stop()
	# Pause based on what the last character was, for effect
	if next_char in [".", "?", "!"]: timer.wait_time = 1.0 / type_speed
	else: timer.wait_time = 0.05 / type_speed
	timer.start()

func fast_forward():
	type_speed = 10
