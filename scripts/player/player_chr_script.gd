extends CharacterBody2D

@export var speed = 8000
@onready var cam: Camera2D = $Camera2D
@onready var AniSpr = $AnimatedSprite2D
var dir : Vector2

func _ready():
	ready_camera_settings()

func _physics_process(delta: float):
	velocity = dir * speed * delta
	move_and_slide()
	handle_animation()
	position = position.round()

func _unhandled_input(_event: InputEvent):
	dir.x = Input.get_axis("Left", "Right")
	dir.y = Input.get_axis("Up", "Down")
	dir = dir.normalized()

	# --- CAMERA SETTINGS ---
func ready_camera_settings():
	# Enable smoothing for gentle camera movement
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 5.0  # Higher = faster catch-up, lower = smoother delay
	
	# Lock camera boundaries (testing)
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = 3840  # example world width in pixels
	cam.limit_bottom = 2160  # example world height in pixels
	
	# Pixel-perfect settings # ensures pixel-perfect movement
	cam.offset = Vector2.ZERO  # keeps camera centered on player
	
func handle_animation():
	if velocity:
		AniSpr.play("Walk")
	else:
		AniSpr.play("Idle")
