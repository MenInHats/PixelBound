extends CharacterBody2D

# Inhernted Resources
@export var health_component : HealthComponent = null
@export var force_knockback : ForceKnockBackCompontent = null
@export var camera_settings : CameraComponent = null

# Player Character Variable Stats
@onready var current_health = 0
@export var speed = 8000

#Player Character Variables that affect placement
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var dir : Vector2

#Player Character Variable Visuals
@onready var cam: Camera2D = $Camera2D
@onready var AniSpr = $AnimatedSprite2D


func _ready():
	current_health = health_component.setHealthToMax()
	camera_settings.ready_camera_settings()

func _physics_process(delta: float): 
	# Apply knockback if active
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback
	else:
		print
		velocity = dir * speed * delta
		
	move_and_slide()
	handle_animation()
	position = position.round()

func _unhandled_input(_event: InputEvent):
	dir.x = Input.get_axis("Left", "Right")
	dir.y = Input.get_axis("Up", "Down")
	dir = dir.normalized()

	
func handle_animation():
	if velocity:
		AniSpr.play("Walk")
	else:
		AniSpr.play("Idle")
		
func take_damage(damage: int, source_pos: Vector2 = global_position):
	current_health = health_component.damageCalculation(damage)
	print("Player Health:", current_health)
	
	
	# Calculate knockback direction
	knockback = force_knockback.calculateKnockback(global_position, source_pos)
	knockback_timer = force_knockback.knockback_duration
	print(knockback, knockback_timer)
	
