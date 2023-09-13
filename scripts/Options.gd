extends CanvasLayer

onready var button_camera_shake = $Center/VBox/HBox/Grid/Button_CameraShake
onready var button_shader = $Center/VBox/HBox/Grid/Button_Shader
onready var button_scanlines = $Center/VBox/HBox/Grid/Button_Scanlines
onready var button_screen_warp = $Center/VBox/HBox/Grid/Button_ScreenWarp
onready var button_glow = $Center/VBox/HBox/Grid/Button_Glow
onready var button_transition = $Center/VBox/HBox/Grid/Button_Transition
onready var button_back = $Center/VBox/BackButton

onready var toggle_shader = $Center/VBox/HBox/Grid/CheckButton_Shader
onready var toggle_scanlines = $Center/VBox/HBox/Grid/CheckButton_Scanlines
onready var toggle_screen_warp = $Center/VBox/HBox/Grid/CheckButton_ScreenWarp
onready var toggle_glow = $Center/VBox/HBox/Grid/CheckButton_Glow
onready var toggle_transition = $Center/VBox/HBox/Grid/CheckButton_Transition
onready var toggle_camera_shake = $Center/VBox/HBox/Grid/CheckButton_CameraShake

onready var overlay = $Overlay

func _ready():
	var use_shader = Global.get_setting("use_shader")
	toggle_camera_shake.pressed = Global.get_setting("camera_shake")
	toggle_shader.pressed = use_shader
	toggle_scanlines.pressed = Global.get_setting("scanlines")
	toggle_screen_warp.pressed = Global.get_setting("screen_warp")
	toggle_glow.pressed = Global.get_setting("glow")
	toggle_transition.pressed = Global.get_setting("transition")
	# If shader not being used, disable shader options
	toggle_scanlines.disabled = !use_shader
	toggle_screen_warp.disabled = !use_shader
	toggle_glow.disabled = !use_shader
	# button_back.grab_focus()
	toggle_shader.grab_focus()

func set_camera_shake(button_pressed):
	Global.set_setting("camera_shake", button_pressed)

func set_shader(button_pressed):
	Global.set_setting("use_shader", button_pressed)
	overlay.set_shader(button_pressed)
	toggle_scanlines.disabled = !button_pressed
	toggle_screen_warp.disabled = !button_pressed
	toggle_glow.disabled = !button_pressed

func set_scanlines(button_pressed):
	Global.set_setting("scanlines", button_pressed)
	overlay.mat.set_shader_param("scanlines", button_pressed)

func set_screen_warp(button_pressed):
	Global.set_setting("screen_warp", button_pressed)
	overlay.mat.set_shader_param("screen_warp", button_pressed)

func set_glow(button_pressed):
	Global.set_setting("glow", button_pressed)
	overlay.mat.set_shader_param("glow", button_pressed)

func set_transition(button_pressed):
	Global.set_setting("transition", button_pressed)
	overlay.mat.set_shader_param("transition", button_pressed)

func back():
	Global.save_game(Global.game_progress)
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
