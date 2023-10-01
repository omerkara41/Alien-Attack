class_name EnemySpawner
extends Node2D

var enemy_scene = preload("res://Scenes/enemy_1.tscn")
var enemy2_scene = preload("res://Scenes/path_2d.tscn")

@onready var timer = get_node("Timer")
@onready var timer2 = get_node("TimerEnemy2")
@onready var spawnPosition = $SpawnPosition # yukaridaki get node ile ayni bu dolar isareti
@onready var spawn_positions_array = spawnPosition.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", spawnEnemy) # timeout olunca spawn enemy tetiklencek.
	timer2.connect("timeout", spawnEnemy2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnEnemy():
	var random_enemyspawn_pos = spawn_positions_array.pick_random()
	
	var enemy_instance = enemy_scene.instantiate() # Create a new enemy for us
	enemy_instance.global_position = random_enemyspawn_pos.global_position
	add_child(enemy_instance)
	
func spawnEnemy2():
	var enemy_instance = enemy2_scene.instantiate() # Create a new enemy for us
	add_child(enemy_instance)
