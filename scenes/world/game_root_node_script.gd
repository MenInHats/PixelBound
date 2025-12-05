extends Node2D

var total_number_of_enemies_spawned : int = 0
var number_of_enemies_spawned : int = 0
@export var wave_number : int = 1


func _ready():
	var player_character = get_node("PlayerChr")
	player_character.player_died.connect(_on_player_chr_died)
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.EIGHT_BIT_GAME_MUSIC)
	
func spawn_mob():
	var bat_enemy = preload("res://scenes/enemies/bat_enemy.tscn").instantiate()
	var skull_enemy = preload("res://scenes/enemies/skull_enemy.tscn").instantiate()
	var crawler_enemy = preload("res://scenes/enemies/crawler_enemy.tscn").instantiate()
	$%PathFollow2D.progress_ratio = randf()
	bat_enemy.global_position = $%PathFollow2D.global_position
	skull_enemy.global_position = $%PathFollow2D.global_position
	crawler_enemy.global_position = $%PathFollow2D.global_position
	#add_child(crawler_enemy)
	if number_of_enemies_spawned < 25:
		total_number_of_enemies_spawned += 1
		if (number_of_enemies_spawned % 10) == 0:
			if wave_number > 3:
				number_of_enemies_spawned += wave_number
				print("crawler spawned")
				add_child(crawler_enemy)
			else:
				number_of_enemies_spawned += wave_number
				print("skull spawned")
				add_child(skull_enemy)
		else:
			number_of_enemies_spawned += wave_number
			print("bat spawned ", number_of_enemies_spawned)
			add_child(bat_enemy)
			print("total enemies: ", total_number_of_enemies_spawned)
	else:
		wave_number += 1
		print("wave ", wave_number)
		number_of_enemies_spawned = 0
	
func _on_timer_timeout():
		spawn_mob()
	
func _on_player_chr_died():
	print("Player Has Died")
	var game_over = $PlayerChr/GameOver
	game_over.visible = true

	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.GAME_OVER_SOUND_EFFECT, true)
	get_tree().paused = true
