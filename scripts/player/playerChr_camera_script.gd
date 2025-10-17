extends Camera2D

@export var player: Node2D
@export var smoothing_speed := 5.0

func _process(delta):
	if player:
		# Smoothly follow the player position
		global_position = global_position.lerp(player.global_position, smoothing_speed * delta)
