extends Control

@onready var scoreText = $Panel/ScoreText

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Game Restart
func _on_retry_button_pressed():
	get_tree().reload_current_scene()
	
func set_score(new_score):
	scoreText = "SCORE: " + str(new_score)
