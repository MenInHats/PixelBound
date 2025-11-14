extends Resource
class_name ForceKnockBackCompontent

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
@export var knockback_duration: float = 0.15  # seconds
@export var knockback_strength: float = 400.0 #Forec of knockback
var dir : Vector2

func calculateKnockback(global_pos: Vector2, source_pos: Vector2):
	# Calculate knockback direction
	#Take the entity's current position then the position of the knockbacks source then include the strength into the calculation
	knockback = (global_pos - source_pos).normalized() * knockback_strength
	knockback_timer = knockback_duration
	print(knockback, knockback_timer)
	return knockback
