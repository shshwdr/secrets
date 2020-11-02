extends Node2D


var width = 6
var height = 5
var tile_size = 160

var x_offset = tile_size/2
var y_offset = tile_size/2

var tile_scene = preload("res://scenes/mainGame/tile.tscn")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in width:
		for j in height:
			var tile_instance = tile_scene.instance()
			tile_instance.init({},Constants.CoverState.NotAccessible)
			add_child(tile_instance)
			tile_instance.position = Vector2(i*tile_size+x_offset, j*tile_size+y_offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
