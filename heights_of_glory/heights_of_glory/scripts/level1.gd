extends Node

func _ready():
	
	#setting the target to player
	get_node("zombie_path_follow/pathfollow/enemy").target_player = get_node("player")
	
	pass
