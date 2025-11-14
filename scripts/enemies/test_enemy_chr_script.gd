extends CharacterBody2D

# Inhernted Resources
@export var health_component : HealthComponent = null

#Player Character Variables that affect placement
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
@export var knockback_duration: float = 0.15  # seconds
@export var knockback_strength: float = 400.0 #Forec of knockback
var dir : Vector2

#Set Enemy Stats
@onready var current_health = 0
@export var speed: float = 60.0
var player: Node2D
@export var avoid_radius: float = 16.0  # how far to steer away from other enemies

func _ready() -> void:
	# Automatically find the player if not manually assigned
	if player == null:
		player = get_tree().get_root().find_child("PlayerChr", true, false)
		if not player:
			push_warning("Player not found in scene!")
			set_physics_process(false)
			return
	current_health = health_component.setHealthToMax()

func _physics_process(delta: float) -> void:
	#Note: if the enemy gets stuck to player its beacuse it see 
	if not player:
		return

	# Direction toward player
	var direction = (player.global_position - global_position).normalized()
	var dir_len = direction.length()

	## If distance is very small, random-nudge to avoid perfect overlap
	#if dir_len < 1.0:
		## small nudge so normalized() won't be zero
		#direction = Vector2(randf() - 0.5, randf() - 0.5)

	# --- Simple avoidance ---
	var avoid_force = Vector2.ZERO
	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self:
			continue
		var dist = global_position.distance_to(other.global_position)
		if dist < avoid_radius:
			avoid_force += (global_position - other.global_position).normalized() * (avoid_radius - dist)
			
	# Combine movement forces
	direction += avoid_force.normalized() * 0.4  # blend avoidance
	direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()
	
func take_damage(damage: int, source_pos: Vector2 = global_position):
	current_health = health_component.damageCalculation(damage)
	print("Player Health:", current_health)
	
	
	# Calculate knockback direction
	knockback = (global_position - source_pos).normalized() * knockback_strength
	knockback_timer = knockback_duration
	print(knockback, knockback_timer)
	
