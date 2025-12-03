extends Area2D

# Optional sound call, when button press
@export var sfx_button_press = Node2D
@export var particle_button_press = Node2D
#@onready var sprite = $
# Load the two textures
var normal_texture = preload("res://assets/ui/QuitMenuUI.png")
var hover_texture = preload("res://assets/ui/StartGameMenu Alt.png")

#func _ready():
	## Connect button signals
	#sprite.mouse_entered.connect(_on_mouse_entered)
	#sprite.mouse_exited.connect(_on_mouse_exited)

func _input_event(viewport: Viewport, event: 	InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed:
		SceneManager.change_scene("res://scenes/test/test_area.tscn")
