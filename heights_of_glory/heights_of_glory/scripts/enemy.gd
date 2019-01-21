extends KinematicBody2D

var target_player

onready var bullet = preload("res://scenes/enemy_bullet.tscn")
onready var enemy_bullet_container = get_node("enemy_bullet_container")

func _ready():
	
	set_physics_process(true)

	pass


func _physics_process(delta):
	
	print("enemy_position: ", position)
	#direction towards player
	var direction_x = position.x - target_player.position.x
	var direction_y = position.y - target_player.position.y
	translate(Vector2(-direction_x,-direction_y) * delta)
	
	#changing the flip position and raycast with respect to the position
	if position.x > 540:
		get_node("area/sprite").flip_h=false
		get_node("bullet_ray").cast_to.x = 200
		
	if position.x <540:
		print("position is less than 540 ")
		get_node("area/sprite").flip_h =true
		get_node("bullet_ray").cast_to.x = -200
		
		
		
	if get_node("bullet_ray").is_colliding():
		
		print("timer left: ", get_node("bullet_ray/timer").time_left)
		get_node("bullet_ray/timer").start()
		get_node("bullet_ray/timer").wait_time = 0.5
		
		
		
	
	
	pass
	
		#enemy shoot function
func shoot():
	var dir = position - target_player.position
	var b = bullet.instance()
	enemy_bullet_container.add_child(b)
	b.start(dir.angle(),get_node("bullet_spawn_pos").global_position)

	
#on ray timer timeout,shoot at player
func _on_timer_timeout():
	shoot()
	#pass # Replace with function body.
