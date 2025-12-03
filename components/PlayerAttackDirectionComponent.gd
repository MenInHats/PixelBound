extends Resource
class_name PlayerAttackDirComponent

# configurations
@export var sword_node_path: NodePath = NodePath("WeaponSword")
@export var sword_offset: float = 24.0
@export var rotation_offset_degrees: float = 0.0

# Return a non-zero attack direction given movement dir and last_facing fallback.
# `dir` and `last_facing` are Vector2s from the player.
func get_attack_direction(dir: Vector2, last_facing: Vector2) -> Vector2:
	if dir.length() > 0.0001:
		return dir.normalized()
	# fallback
	if last_facing.length() > 0.0001:
		return last_facing.normalized()
	# final fallback
	return Vector2.RIGHT

# Given an attack_dir, return a local position offset for the weapon (relative to player)
func get_local_position(attack_dir: Vector2) -> Vector2:
	return attack_dir.normalized() * sword_offset

# Given an attack_dir, return a rotation in radians to apply to the weapon node.
func get_rotation_rad(attack_dir: Vector2) -> float:
	# Use deg_to_rad (Godot 4 name)
	return attack_dir.angle() + deg_to_rad(rotation_offset_degrees)
