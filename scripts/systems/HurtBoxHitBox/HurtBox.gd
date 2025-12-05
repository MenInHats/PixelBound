class_name HurtBoxes
extends Area2D

@export var col_layer := 0
@export var col_mask := 0

func _ready() -> void:
	# Set layers/masks directly
	collision_layer = col_layer
	collision_mask = col_mask

	# Connect signal
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# Check if what we collided with is a HitBox
	if area == null:
		return

	if area is HitBoxes:
		var hitbox = area as HitBoxes
		if owner and owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage, hitbox.global_position)
			
