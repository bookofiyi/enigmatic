extends Path2D

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	#geting the path follow node
	
	get_node("pathfollow").offset += 100 *delta
	
	pass
