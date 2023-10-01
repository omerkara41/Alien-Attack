class_name Enemy1
extends CharacterBody2D

@export var SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rocket_scene = preload("res://Scenes/rocket.tscn")

func _physics_process(delta):

	var direction = -1 # Enemy sadece sola dogru gidecek

	velocity.x = direction * SPEED

	move_and_slide()
	enemyCollisionDetection() 
	
	
# Bu kod bizim kinematik body'mizin yasadigi butun collisionlari getiriyor.
# Ayni anda birden fazla seyle contact'imiz olabilir o yuzden. Yalniz rigidbody'lerde bu detection
# ise yaramiyormus. Aslinda bu oyun icin bizim 1 tane collision'a ihtiyacimiz var. Ama boyle kalsin.
"""
func enemyCollisionDetection():	
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider is Player:
			collider.player_taken_damage()
			destroyEnemy()
"""
# Dogrusu bu, tek bir collision detect etmek icin galiba
func enemyCollisionDetection():	
	for index in get_slide_collision_count():
		var collision = get_last_slide_collision()
		var collider = collision.get_collider()
		if collider is Player:
			collider.player_taken_damage()
			destroyEnemy()
			
func destroyEnemy():
	queue_free() # Node deletion icin kullanilir.
