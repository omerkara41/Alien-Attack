extends Path2D

@export var enemy_spawn = 3

@onready var pathfollow = $PathFollow2D # Path Enemy, enemy'nin uzerinde gittigi path
@onready var enemy = $PathFollow2D/Enemy1 # PathFollow2d ise path uzerinde giden enemy icin

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfollow.set_progress_ratio(0) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_progress(delta)


func path_progress(delta):
	# Yani 4 sn'de path'i tamamliycak enemy, progress ratio 0 ve 1 arasinda ve her saniye 0.25 
	# progress ettirirsek 4 saniye oluyor.
	pathfollow.progress_ratio += 0.25 * delta 
	if pathfollow.progress_ratio >= 1:
		queue_free()
	
