class_name Game
extends Node2D

@onready var hud = $IU/HUD
@onready var iu = $IU
@onready var explode_sound_efect = $Sounds/ExplodeSound
@onready var hit_sound_efect = $Sounds/HitSound
@onready var enemy_died_sound_efect = $Sounds/EnemyDiedSound

var game_over_scene = preload("res://Scenes/game_over_screen.tscn")

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enemy_death_zone_body_entered(enemy):
	if enemy is Enemy1:
		enemy.destroyEnemy()

func _on_player_rocked_launced(rocket):
	rocket.connect("rocked_hit", enemyHasDied)
	hit_sound_efect.play()

func enemyHasDied():	
	score += 100
	enemy_died_sound_efect.play()
	hud.set_score_label(score) # IU'daki text'i guncelliyoz

# Oyuncu oldugunde game_over_panelinin tetiklenmesi icin
func _on_player_player_is_dead():
	explode_sound_efect.play()
	# timer yaratik ve 2 sn bekle dedik. game_over_paneli oldukten 2 sn sonra acilcak
	await  get_tree().create_timer(2).timeout  
	
	var game_over_instance = game_over_scene.instantiate()
	game_over_instance.set_score(score)
	iu.add_child(game_over_instance)
