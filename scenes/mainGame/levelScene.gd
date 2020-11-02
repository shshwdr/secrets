extends Node2D


var width = 6
var height = 5
var tile_map ={}
var player_instance
var player_index_position

var tile_scene = preload("res://scenes/mainGame/tile.tscn")
var player_scene = preload("res://scenes/mainGame/Player.tscn")




func generate_cover_info():
	#where player stand is always none
	var player_tile:Tile = tile_map[player_index_position]
	player_tile.cover_state = Constants.CoverState.None
	
	#start from player, search around, if next to player, set to accessible
	
	var DIR4 = [Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1)]
	for d in DIR4:
		var new_index = player_index_position+d
		if Utils.in_bound(new_index,width,height):
			var tile:Tile = tile_map[new_index]
			if tile.cover_state == Constants.CoverState.NotAccessible:
				tile.cover_state = Constants.CoverState.Accessible

func update_tiles():
	for i in width:
		for j in height:
			var index = Vector2(i,j)
			var tile:Tile = tile_map[index]
			tile.update()
	
func init_player():
	player_index_position = Utils.randomi_2d(width,height)
	player_instance = player_scene.instance()
	add_child(player_instance)
	player_instance.position = Utils.index_to_position(player_index_position)

func init_tiles():
	for i in width:
		for j in height:
			var index = Vector2(i,j)
			var tile_instance = tile_scene.instance()
			tile_instance.init({},Constants.CoverState.NotAccessible)
			add_child(tile_instance)
			tile_instance.position = Utils.index_to_position(index)
			tile_map[index] = tile_instance
	

func _ready():
	init_player()
	init_tiles()
	generate_cover_info()
	update_tiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
