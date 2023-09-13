extends CanvasLayer

const obj_levelbutton = preload("res://objects/LevelButton.tscn")

onready var level_container = $Margin/VBox/Center/LevelContainer
onready var button_back = $Margin/VBox/Button_Back
onready var label_completion = $Margin/VBox/Label_Completion

func make_button(id):
	var level = Global.LEVELS[id]
	var level_progress = Global.game_progress["levels"][id]
	var new_button = obj_levelbutton.instance()
	new_button.num = level["num"]
	new_button.title = level["title"]
	new_button.scene = level["scene"]
	new_button.unlocked = level_progress["unlocked"]
	new_button.par = level["par"]
	new_button.best = level_progress["best_time"]
	new_button.got_roses = level_progress["got_roses"]
	return new_button

func make_level_buttons():
	var previous_button = null
	for next_id in Global.LEVELS:
		var next_button = make_button(next_id)
		level_container.add_child(next_button)
		# If this is the first button, set it to be the neighbour to back button
		if previous_button == null: button_back.focus_neighbour_top = next_button.get_path()
		else: next_button.focus_neighbour_top = previous_button.get_path()
		previous_button = next_button
		
	button_back.focus_neighbour_top = level_container.get_child(level_container.get_child_count() - 1).get_child(0).get_path()
func update_completion_label():
	var completion = Global.get_completion()
	var completion_percent = round(completion * 100)
	label_completion.text = "Total completion: %s%%" % completion_percent

func _ready():
	# Make the buttons for each level
	make_level_buttons()
	# Determine how much of the game the player has completed
	update_completion_label()

func back():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
