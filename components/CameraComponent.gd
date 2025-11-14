extends Resource
class_name CameraComponent

func ready_camera_settings(cam : Camera2D):
	# Enable smoothing for gentle camera movement  res://scenes/player/player_chr.
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 5.0  # Higher = faster catch-up, lower = smoother delay
	
	# Lock camera boundaries (testing)
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = 3840  # example world width in pixels
	cam.limit_bottom = 2160  # example world height in pixels 
	
	# Pixel-perfect settings # ensures pixel-perfect movement
	cam.offset = Vector2.ZERO  # keeps camera centered on player
	return cam
