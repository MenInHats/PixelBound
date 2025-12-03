extends CharacterBody2D

# Inhernted Resources
@export var health_component : HealthComponent = null
@export var force_knockback : ForceKnockBackCompontent = null
@export var camera_settings : CameraComponent = null
@export var plyaer_attack_dir : PlayerAttackDirComponent = null

# Player Signals
signal player_died(postition)

# Player Character Stats
@onready var current_health = 0
@export var speed = 8000

#Player Character Variables that affect placement
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var dir : Vector2
var last_facing: Vector2 = Vector2.RIGHT

#Player Character Variable Visuals
@onready var cam: Camera2D = $Camera2D
@onready var AniSpr = $AnimatedSprite2D

#refrence to weapon
@export var weapon_node_path: NodePath = NodePath("WeaponSword")  # path to child node
@onready var weapon_node: Node = null

# Auto-attack toggle
@export var auto_attack_on_start: bool = true

func _ready():
	current_health = health_component.reset_entity_health()
	camera_settings.ready_camera_settings(cam)
	
	# find weapon child (if present)
	if has_node(weapon_node_path):
		weapon_node = get_node(weapon_node_path)
	else:
		weapon_node = null
		
		
	if auto_attack_on_start and weapon_node:
		# Compute initial attack direction
		var attack_dir = plyaer_attack_dir.get_attack_direction(dir, last_facing)
		var local_offset = plyaer_attack_dir.get_local_position(attack_dir)
		var rotation_rad = plyaer_attack_dir.get_rotation_rad(attack_dir)

		# place once (if child)
		if weapon_node.get_parent() == self:
			weapon_node.position = local_offset
			weapon_node.rotation = rotation_rad
		else:
			weapon_node.global_position = global_position + attack_dir * plyaer_attack_dir.sword_offset
			weapon_node.rotation = rotation_rad

		# Make the weapon handle looping itself: call start once and let sword.loop control repeat
		if weapon_node.has_method("start"):
			await get_tree().process_frame
			weapon_node.start(attack_dir, global_position)

func _physics_process(delta: float): 
	# Apply knockback if active
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback
	else:
		velocity = dir * speed * delta
		
	move_and_slide()
	handle_animation()
	position = position.round()
		# compute attack direction/placement
	var attack_dir = plyaer_attack_dir.get_attack_direction(dir, last_facing)
	var local_offset = plyaer_attack_dir.get_local_position(attack_dir)
	var rotation_rad = plyaer_attack_dir.get_rotation_rad(attack_dir)

	# position weapon and start it; connect to attack_finished so we can clear state
	if weapon_node.get_parent() == self:
		weapon_node.position = local_offset
		weapon_node.rotation = rotation_rad
	else:
		weapon_node.global_position = global_position + attack_dir * plyaer_attack_dir.sword_offset
		weapon_node.rotation = rotation_rad


func _unhandled_input(_event: InputEvent):
	dir.x = Input.get_axis("Left", "Right")
	dir.y = Input.get_axis("Up", "Down")
	dir = dir.normalized()
	if dir.length() > 0:
		last_facing = dir
		
func handle_animation():
	if velocity:
		AniSpr.play("Walk")
	else:
		AniSpr.play("Idle")
		
func take_damage(damage: int, source_pos: Vector2 = global_position):
	current_health = health_component.damage_calculation(damage)
	if current_health <= 0:
		player_died.emit(global_position)
		
	# Calculate knockback direction
	knockback = force_knockback.calculateKnockback(global_position, source_pos)
	knockback_timer = force_knockback.knockback_duration
	
func retrieveHealthComponent():
	return health_component
	
func _start_attack() -> void:
	# guards
	if plyaer_attack_dir == null:
		push_warning("No attack_dir_component assigned")
		return
	if weapon_node == null:
		push_warning("No weapon_node found")
		return

	# compute attack direction/placement
	var attack_dir = plyaer_attack_dir.get_attack_direction(dir, last_facing)
	var local_offset = plyaer_attack_dir.get_local_position(attack_dir)
	var rotation_rad = plyaer_attack_dir.get_rotation_rad(attack_dir)

	# position weapon and start it; connect to attack_finished so we can clear state
	if weapon_node.get_parent() == self:
		weapon_node.position = local_offset
		weapon_node.rotation = rotation_rad
		# Connect the finished signal (use Callable). We rely on player_attacking to avoid duplicate connects.
		#if weapon_node.has_method("start"):
			#weapon_node.start(attack_dir, global_position)
	else:
		weapon_node.global_position = global_position + attack_dir * plyaer_attack_dir.sword_offset
		weapon_node.rotation = rotation_rad
		#if weapon_node.has_method("start"):
			#weapon_node.start(attack_dir, global_position)

	
