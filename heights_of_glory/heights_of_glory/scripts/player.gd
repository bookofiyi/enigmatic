extends KinematicBody2D

signal damage_enemy

const ACCEL =500
const MAX_SPEED = 300
const FRICTION = -50000
const GRAVITY = 9.81
const JUMP_HEIGHT =-400

var acceleration = Vector2()

onready var ground_ray = get_node("ground_ray")
onready var player_bullet_container = get_node("player_bullet_container")
onready var player_bullet = preload("res://scenes/player_bullet.tscn")

#bullet script
onready var player_bullet_script = load("res://scripts/player_bullet.gd").new()

#export var starting_stats : Resource

#export(Array, String) var starting_skills

#export(PackedScene) var character_skill_scene : PackedScene

#export(float, 0.0, 1.0) var success_chance : float

func _ready() -> void:
	
	
	OS.screen_orientation = OS.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
	
	set_physics_process(true)
	
	pass

func _physics_process(delta):
	
	
	acceleration.y += GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		acceleration.x -= ACCEL *delta
		
		
	elif Input.is_action_pressed("ui_right"):
		acceleration.x += ACCEL *delta
		
	elif Input.is_action_pressed("ui_accept") and global.mana>0:
		shoot(true)
		
	elif Input.is_action_pressed("ui_accept") and global.mana<=0:
		shoot(false)
		
		
		
	#slowing down with linear interpolation
	else:
		acceleration.x = lerp(acceleration.x, 0, 0.2)
	
	
	if is_on_floor() and ground_ray.is_colliding():
		if Input.is_action_just_pressed("ui_up"):
			acceleration.y = JUMP_HEIGHT
	
	#clamping the velocity to a max speed in both negative and positive x direction
	acceleration.x = clamp(acceleration.x,-MAX_SPEED,MAX_SPEED)
	
	#move and slide the velocity and detect the floor
	acceleration = move_and_slide(acceleration,Vector2(0,-1))
	
	
	#using the magnum skill
	if is_able_to_use_magmum_skills():
		global.magmum_skills = 0
		
		#skill animation here and damage here
		emit_signal("damage_enemy")
		player_bullet_script.start()
		
	
	mana_delay_and_regenerate()
	
	pass
	
	# shooting bullet 
func shoot(shoot_activate):
	
	if shoot_activate==true:
		var b= player_bullet.instance()
		player_bullet_container.add_child(b)
		b.start(rotation,get_node("bullet_spawn_pos").global_position)
		
		#reduce shooting mana
		global.mana -= 10
		
	else:
		return

func is_able_to_use_magmum_skills() -> bool:
	"""
	Returns true if the battler can perform an action
	"""
	return global.magnum_skills == 500

func take_damage(hit:int):
	global.player_health -= hit
	
	if _get_player_health() > 0:
		global.player_health = min(_get_player_health() + _get_player_health_regen() * get_physics_process_delta_time()  ,5000)
	# prevent playing both stagger and death animation if health <= 0
	"""if global.player_health > 0:
		self.player_stagger_animation()
		
	else:
		self.player_death_animation()"""

func _on_health_depleted():
	if global.player_health < 0:
		set_physics_process(false)
		

func mana_delay_and_regenerate():
	if global.mana >=0:
	#	regenerate mana 
		global.mana = min(global.mana + _get_mana_regen() * get_physics_process_delta_time(),100)
		print("VALUE OF MANA",global.mana)
		
	elif global.mana <=0:
		global.mana = min(global.mana + _get_mana_regen() * get_physics_process_delta_time(),100)
		
		
func is_alive()->bool:
	return global.player_health >0
	
func _get_player_health():
	return global.player_health
func _get_mana():
	return global.mana
	
func _get_mana_regen():
	return global.mana_regen
	
func _get_player_health_regen():
	return global.player_health_regen