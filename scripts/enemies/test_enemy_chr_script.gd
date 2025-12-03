extends CharacterBody2D

# Inhernted Resources
@export var health_component : HealthComponent = null
@export var force_knockback : ForceKnockBackCompontent = null

#Player Character Variables that affect placement
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var dir : Vector2

#Set Enemy Stats
@onready var current_health = 0
@export var speed: float = 60.0
@export var base_damage := 50
@export var avoid_radius: float = 16.0  # how far to steer away from other enemies

var player: Node2D

func _ready() -> void:
	# Automatically find the player if not manually assigned
	if player == null:
		player = get_tree().get_root().find_child("PlayerChr", true, false)
		if not player:
			push_warning("Player not found in scene!")
			set_physics_process(false)
			return
	current_health = health_component.reset_entity_health()

func _physics_process(delta: float) -> void:
	#Note: if the enemy gets stuck to player its beacuse it see 
	if not player:
		return

	# Direction toward player
	var direction = (player.global_position - global_position).normalized()
	var dir_len = direction.length()

	# --- Simple avoidance ---
	#var avoid_force = Vector2.ZERO
	#for other in get_tree().get_nodes_in_group("enemies"):
		#if other == self:
			#continue
		#var dist = global_position.distance_to(other.global_position)
		#if dist < avoid_radius:
			#avoid_force += (global_position - other.global_position).normalized() * (avoid_radius - dist)
			
	# Combine movement forces
	#direction += avoid_force.normalized() * 0.4  # blend avoidance
		# Apply knockback if active
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback
	else:
		direction = direction.normalized()
		velocity = direction * speed * delta

	move_and_slide()
	
func take_damage(damage: int, source_pos: Vector2 = global_position):
	current_health = health_component.damage_calculation(damage)
	print("Enemy Current Health:", current_health)
	if health_component.is_entity_dead(current_health):
		queue_free()
	
	# Calculate knockback direction
	knockback = force_knockback.calculateKnockback(global_position, source_pos)
	knockback_timer = force_knockback.knockback_duration
	
