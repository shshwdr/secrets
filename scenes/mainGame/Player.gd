extends Node2D


onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func move_path(player_path_to_tile):
	for path_position in player_path_to_tile:
		timer.start()
		yield(timer, "timeout")
		Utils.position_move(self,path_position)
func index_positioin():
	return Utils.position_to_index(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
