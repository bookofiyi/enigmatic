extends Node

func _ready():
	
	#setting the target to player
	get_node("enemy").target_player = get_node("player")
	
	pass
