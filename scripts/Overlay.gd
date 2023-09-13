extends Polygon2D

onready var mat = self.get_material()
onready var cursor = $Cursor

var wipe

func _ready():
	wipe = 1
	cursor.visible = false
	set_shader(Global.get_setting("use_shader"))
	mat.set_shader_param("scanlines", Global.get_setting("scanlines"))
	mat.set_shader_param("screen_warp", Global.get_setting("screen_warp"))
	mat.set_shader_param("glow", Global.get_setting("glow"))
	mat.set_shader_param("transition", Global.get_setting("transition"))

func _process(delta):
	if wipe > 0: wipe -= delta/2
	mat.set_shader_param("wipe", wipe)
	cursor.position = get_viewport().get_mouse_position()

func set_shader(on):
	mat.set_shader_param("apply_shader", on)
	#cursor.visible = on
	if on: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
