extends Node2D


var width = 6
var height = 5
var index_to_tile_map ={}
var tile_to_index_map ={}
var player_instance
var player_index_position

var tile_scene = preload("res://scenes/mainGame/tile.tscn")
var player_scene = preload("res://scenes/mainGame/Player.tscn")




func generate_cover_info():
	#where player stand is always none
	var player_tile:Tile = index_to_tile_map[player_index_position]
	player_tile.cover_state = Constants.CoverState.None
	
	#start from player, search around, if next to player, set to accessible
	
	var DIR4 = [Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1)]
	for d in DIR4:
		var new_index = player_index_position+d
		if Utils.in_bound(new_index,width,height):
			var tile:Tile = index_to_tile_map[new_index]
			if tile.cover_state == Constants.CoverState.NotAccessible:
				tile.cover_state = Constants.CoverState.Accessible

func update_tiles():
	for i in width:
		for j in height:
			var index = Vector2(i,j)
			var tile:Tile = index_to_tile_map[index]
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
			index_to_tile_map[index] = tile_instance
			tile_to_index_map[tile_instance] = index
	
func on_touched_tile(index):
	if not index_to_tile_map.has(index):
		return
	var tile = index_to_tile_map[index]
	#if not have cover, move player there, consume item on it if exist
	#if accessible, hide cover
	tile.cover_state = Constants.CoverState.None
	tile.update()
	
	pass


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		var touch = event.position
		var index = Utils.position_to_index(touch)
		on_touched_tile(index)

func _ready():
	init_player()
	init_tiles()
	generate_cover_info()
	update_tiles()
	Events.connect("touched_tile",self,"on_touched_tile")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
