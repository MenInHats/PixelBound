extends Node2D
class_name Sword

# signals for when the weapon finishes
signal attack_finished

@export var base_damage: int = 10
@export var damage_scale: float = 1.0
@export var reach: float = 48.0        # how far from player the tip goes
@export var rotation_offset_degrees: float = 0.0  # if sprite faces a different direction

#attack timing
@export var visible_time: float = 0.12   # how long the sword is visible (seconds)
@export var hidden_time: float = 0.20    # how long the sword is hidden before reappearing at end
@export var loop: bool = true            # repeat forever
@export var start_on_ready: bool = true  # start the cycle automatically

var _is_visible_state: bool = false

@onready var weapon_pivot: Marker2D = find_child("WeaponPivot")
@onready var sprite: Sprite2D = get_node("WeaponPivot/Sprite2D")
@onready var hit_box: Area2D = get_node("WeaponPivot/HitBoxes")
@onready var timer: Timer = $CycleTimer

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	hit_box.monitorable = false
	sprite.visible = false
	_is_visible_state = false
	if start_on_ready:
		_start_cycle()
		
# existing show/hide cycle code
func _start_cycle() -> void:
	hit_box.monitorable = false
	_is_visible_state = false
	sprite.visible = false
	_set_timer(hidden_time)

func stop(hide: bool = true) -> void:
	timer.stop()
	_is_visible_state = false
	sprite.visible = not hide

# Timer callback: toggles visible/hidden and restarts timer
func _on_timer_timeout() -> void:
	if _is_visible_state:
		# visible -> hide; if not looping, emit finished
		hit_box.monitorable = false
		sprite.visible = false
		_is_visible_state = false
		if loop:
			_set_timer(hidden_time)
		else:
			emit_signal("attack_finished")
	else:
		# hidden -> show
		hit_box.monitorable = true
		sprite.visible = true
		_is_visible_state = true
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SWORD_SLASH_SOUND_EFFECT)
		_set_timer(visible_time)

# helper to set timer wait and start it
func _set_timer(wait_seconds: float) -> void:
	timer.wait_time = max(wait_seconds, 0.001)
	timer.start()
	
# direction: normalized Vector2 indicating the attack direction (world space)
# origin: global position of the player (or origin point)
func start(direction: Vector2, origin: Vector2) -> void: 
	if _is_visible_state:
		return  # already attacking, ignore

	if direction.length() == 0:
		direction = Vector2.RIGHT
	direction = direction.normalized()

	# position: if child of player, set local position; otherwise set global
	if get_parent() == get_owner() and get_parent() != null:
		position = direction * reach
	else:
		global_position = origin + direction * reach

	# rotation (degrees -> radians)
	rotation = direction.angle() + deg_to_rad(rotation_offset_degrees)

	# show immediately and start visible timer
	sprite.visible = true
	_is_visible_state = true
	hit_box.monitorable = true
	_set_timer(visible_time)

# optional helper
func is_visible_state() -> bool:
	return _is_visible_state
