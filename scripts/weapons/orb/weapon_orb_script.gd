extends Area2D



# targeting variables
var enemies_in_range
var target_enemy

func _physics_process(delta):
	enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		target_enemy = enemies_in_range[0]
		look_at(target_enemy.global_position)
