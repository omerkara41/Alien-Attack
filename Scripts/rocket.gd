class_name Rocket
extends Area2D

signal enemy_died
signal rocked_hit

# We select root node Area2D because we dont want left any effect on collided object. Rocket
# will hit him and trigger collision. Destroy enemy. We dont have any physical job.

@onready var visibleOnScreenNotifier = get_node("VisibleOnScreenNotifier2D")
@export var SPEED = 500 # Unity'daki public iste, inspector'dan degistirebilcez speed degerini

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signal'i Node'a connect ettik. Rocket screen'den cikinca destroy_rocket'i tetikleyecek.
	visibleOnScreenNotifier.connect("screen_exited", destroy_rocket) 

# Delta time = 1/60 suan yani 1 frame icin gecen saniye. Roketin hiz atamasini yaparken delta time
# kullanicaz. Cunku her bilgisayarda FPS ayni degil ama biz oynanis hissinin ayni olmasini istiyoruz.
# _process delta kadar cagrildigi icin yani 60 frame. Speed'i delta ile yani 1/60 ile carparak
# kaydirilan pixel sayisini FPS'lerin farkli oldugu bilgisayarlar icin bile ayni yapmis oluyoruz.
# Mesela baska bilgisayar 300 FPS aliyorsa bu oyundan _physics_process saniye de 300 defa 
# cagrilcak ve biz Speed'i delta time ile carptigimizdan yani 1/300, Roket her pc de sabit pixel kayacak.
# Buradaki ornekte SPEED 500 oldugundan saniyede 500 pixel kaydirmis olacagiz.
func _process(delta):
	# velocity'i kullanamiyorum cunku CharacterBody2D ye ozgu biz Area2D kullaniyoz.
	global_position.x = global_position.x + SPEED*delta
			
func _on_body_entered(body):
	if body is Enemy1:
		destroy_rocketAndEnemy(body)
	
func destroy_rocket():
	queue_free() # Node deletion icin kullanilir.
	
func destroy_rocketAndEnemy(enemy):
	queue_free() # Node deletion icin kullanilir.
	enemy.destroyEnemy() # enemy'i destroy icin
	emit_signal("enemy_died")
	emit_signal("rocked_hit")
