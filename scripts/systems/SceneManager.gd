extends Node

# This variable references a UI element (ColorRect) that covers the screen. It will be used to fade in/out by changing its alpha transparency.
@onready var fade_rect = $FadeRect

# Main function to change scenes with a fade transition
func change_scene(scene_path: String):
	await fade_out()
	var new_scene = load(scene_path).instantiate() #Load and create (instantiate) the new scene from the given file path
	get_tree().root.add_child(new_scene)#Add the new scene as a child of the root node (so it becomes visible)
	get_tree().current_scene.queue_free() #Free the current scene to remove it from memory
	get_tree().current_scene = new_scene #Set the new scene as the current active scene
	await fade_in()

# This function fades the screen to black
func fade_out():
	var tween = create_tween()     # Create a Tween object to smoothly animate properties over time
	tween.tween_property(fade_rect, "modulate:a", 1.0, 0.5) # Animate the alpha (transparency) of the fade_rect's color, "modulate:a" means the alpha component of the modulate, color 1.0 = fully opaque (black screen), 0.5 seconds = duration of fade
	await tween.finished     # Wait for the tween animation to complete before continuing

# This function fades the screen back to clear
func fade_in():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.5) # Animate the alpha from fully opaque (1.0) to transparent (0.0),  over 0.5 seconds — this makes the new scene appear smoothly
	await tween.finished
