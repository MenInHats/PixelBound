extends Node2D

func _ready():
	var player_character = get_node("PlayerChr")
	player_character.player_died.connect(_on_player_chr_died)

func spawn_mob():
	var test_enemy = preload("res://scenes/enemies/test_Enemy_chr.tscn").instantiate()
	$%PathFollow2D.progress_ratio = randf()
	test_enemy.global_position = $%PathFollow2D.global_position
	add_child(test_enemy)
	
func _on_timer_timeout():
	spawn_mob()
	
func _on_player_chr_died(player_position):
	print("Player Has Died")
	get_node("GameOverMarker").position = player_position
	$GameOver.visible = true
	get_tree().paused = true
	pass # Replace with function body.
