class_name HitBoxes
extends Area2D

@export var damage := 10
@export var col_layer := 0
@export var col_mask := 0
var node_owner: Node = null

func _ready():
	collision_layer = col_layer
	collision_mask = col_mask
	print(collision_layer)
	print(collision_mask)
	
	node_owner = owner
	print(node_owner)
	if node_owner.base_damage:
		print(node_owner.base_damage)
		damage = node_owner.base_damage
		
