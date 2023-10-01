class_name Player
extends CharacterBody2D

signal rocked_launced(rocket)
signal player_is_dead

@export var SPEED = 300.0
@export var player_life = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # Suan 0
var rocket_scene = preload("res://Scenes/rocket.tscn")

@onready var hud_scene = %IU/HUD # Player'dan farklı bir layer'da olan node'a ulastik
@onready var rocket_Container = get_node("RocketContainer") # Start func icinde cagirmak ile ayni


func _ready():
	hud_scene.set_player_life_label(player_life)

"""
_process ve _physics_process arasindaki onemli fark sudur. Physic motorunun yapacagi ve frame rate'in sabit
olmasi gerektigi yerlerde _physics_process kullancaz. Mesela velocity bir physic ozelligi veya
characterin position'i. Process ise daha frame rate free islemlerin yapilmasi gerekilen yerdir.
Bu multiplayer oyunlarda her iki tarafinda stable bir oyun oynamasi icin engeldir. Cunku taraflarin
FPS degerleri farli olabilir ve process bu fps degerine cagrilir. Bu yuzden bu process icinde 
position degistirme veya velocity olaylarinin yapilmamasi gerekir. Eger yapilirsa da delta faktoru isin icine
katilmalidir. Fakat oyunu dogrudan etkilemeyen seyler process icinde yapilabilir. 
"""
func _process(delta):
	isPlayerAlive()
	
	# Rocket herhangi bir physic' sahip olmadigindan process icinde yapicaz. is_action_just_pressed
	# fonksiyonu shooting'i bir kere cagiricak, sadece action pressed yaparsak delta time kadar cagiriyor.
	if Input.is_action_just_pressed("Shooting"):
		shooting()

# Gene bunu update fonksiyonu gibi dusun ama _physic işlemleri icin sabit frame rate kullanir.
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	# Input girildigi surece o yonde ilerle, Herhangi bir input yok ise dur
	if direction_x: 
		velocity.x = direction_x * SPEED
	else: 			 
		velocity.x = move_toward(velocity.x, 0, SPEED) # bu move_towards'i anlamadim.

	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Dikkat edilirse burada hiz atamasinda delta kullanmadim. Move and slide bunu goz onune aliyor.
	move_and_slide()
	
	# Ekranin size degerlerini cektik. Bunu dinamik olarak yaptik cunku, oyuncu ayni resolution'da
	# oynamak istemesse bizim verecegimiz 1280'e 720 degerleri ise yaramayacakti.
	var CANVAS_X = get_viewport_rect().size.x 
	var CANVAS_Y = get_viewport_rect().size.y
	
	# Player screen disina cikmamasi icin screen boyutlarinda position'ini sinirliyoruz.
	"""
	if global_position.x < 0:
		global_position.x = 0
	elif global_position.y < 0:
		global_position.y = 0
	elif global_position.x > CANVAS_X:
		global_position.x = CANVAS_X
	elif global_position.y > CANVAS_Y:
		global_position.y = CANVAS_Y	
	"""
	
	# Diger yontem clamptf fonksiyonunu kullanmak, bu fonksiyon verilen min ve max araliklar disina cikilmadan
	# o deger araliginda olan sayiyi dondurmek. Araliklar disina cikilirsa min veya max degeri donduruyor.
	global_position.x = clampf(global_position.x , 0, CANVAS_X)
	global_position.y = clampf(global_position.y , 0, CANVAS_Y)
	
func shooting():
	var rocket_instance = rocket_scene.instantiate()
	emit_signal("rocked_launced",rocket_instance)
	# rocket'i RocketContainer'in child'i olarak ekliyoruz cunku player'in transform'u oldugundan
	# rocket bu transformu referans olarak gidiyor. Yani bizim player hareketi ile yönü degisiyor 
	# biz bunu istemiyoruz. O yuzden transformu olmayan RocketContainer'in child'i olarak ekliycez.
	# Gene Player script'i kullandigimiz icin bu Container'in player'in altinda olmasi lazim.
	rocket_Container.add_child(rocket_instance)
	rocket_instance.global_position = global_position # rocket will be spawn from player position

func player_taken_damage():
	player_life -= 1 
	print(player_life)

func isPlayerAlive():
	hud_scene.set_player_life_label(player_life)
	if player_life <= 0:
		playerDie()

func playerDie():
	queue_free()
	emit_signal("player_is_dead")
	
