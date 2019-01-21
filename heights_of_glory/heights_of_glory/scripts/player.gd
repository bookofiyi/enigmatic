extends KinematicBody2D

class_name Battler

signal died(battler)


export var stats : Resource
onready var drops : = $Drops
onready var skin = $Skin
onready var actions = $Actions
onready var bars = $Bars
onready var skills = $Skills
onready var ai = $AI


const ACCEL =500
const MAX_SPEED = 300
const FRICTION = -50000
const GRAVITY = 9.81
const JUMP_HEIGHT =-400

var acceleration = Vector2()

onready var ground_ray = get_node("ground_ray")
onready var player_bullet_container = get_node("player_bullet_container")
onready var player_bullet = preload("res://scenes/player_bullet.tscn")


var display_name : String

export var party_member = false
export var turn_order_icon : Texture

	
func initialize():
	
	skin.initialize()
	actions.initialize(skills.get_children())
	stats = stats.copy()
	stats.connect("health_depleted", self, "_on_health_depleted")
	
	
func _ready() -> void:
	var object = player_skills.new()
	object.print_letter()
	
	
	OS.screen_orientation = OS.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
	
	set_physics_process(true)
	
	pass

func _physics_process(delta):
	
	
	
	acceleration.y += GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		acceleration.x -= ACCEL *delta
		
		
	elif Input.is_action_pressed("ui_right"):
		acceleration.x += ACCEL *delta
		
	elif Input.is_action_pressed("ui_accept"):
		shoot()
		
	#slowing down with linear interpolation
	else:
		acceleration.x = lerp(acceleration.x, 0, 0.2)
	
	
	if is_on_floor() and ground_ray.is_colliding():
		print("is on floor")
		if Input.is_action_just_pressed("ui_up"):
			acceleration.y = JUMP_HEIGHT
	
	#clamping the velocity to a max speed in both negative and positive x direction
	acceleration.x = clamp(acceleration.x,-MAX_SPEED,MAX_SPEED)
	
	#move and slide the velocity and detect the floor
	acceleration = move_and_slide(acceleration,Vector2(0,-1))
	pass
	
	# shooting bullet 
func shoot():
	var b= player_bullet.instance()
	player_bullet_container.add_child(b)
	b.start(rotation,get_node("bullet_spawn_pos").global_position)
		
		
		
		
func is_able_to_play() -> bool:
	"""
	Returns true if the battler can perform an action
	"""
	return stats.health > 0

func take_damage(hit):
	stats.take_damage(hit)
	# prevent playing both stagger and death animation if health <= 0
	if stats.health > 0:
		skin.play_stagger()

func _on_health_depleted():
	yield(skin.play_death(), "completed")
	emit_signal("died", self)




class player_skills:
	
	func print_letter():
		
		print("player is ready")
		
		pass