extends Control

@onready var score = $Score
@onready var player_life = $Lives/LiveTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	score.text = "SCORE: 0" 
	player_life.text = "X3" 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_score_label(total_score):
	score.text = "SCORE: " + str(total_score) 
	
func set_player_life_label(life):
	player_life.text = "X" + str(life) 
