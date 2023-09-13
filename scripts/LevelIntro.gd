extends Node

onready var label_title = $Title
onready var label_subtitle = $Subtitle
onready var anim_player = $AnimationPlayer

func play(title, subtitle):
	label_title.text = title
	label_subtitle.text = subtitle
	label_title.show()
	label_subtitle.show()
	anim_player.play("Intro")
