extends Node2D


var width = 6
var height = 5
var index_to_tile_map ={}
var tile_to_index_map ={}
var player_instance

var tile_scene = preload("res://scenes/mainGame/tile.tscn")
var player_scene = preload("res://scenes/mainGame/Player.tscn")




func generate_cover_info():
	#where player stand is always none
	var player_tile:Tile = index_to_tile_map[player_instance.index_positioin()]
	player_tile.cover_state = Constants.CoverState.None
	
	#start from player, search around, if next to player, set to accessible
	
	for d in Constants.DIR4:
		var new_index = player_instance.index_positioin()+d
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
	var player_index_position = Utils.randomi_2d(width,height)
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
	
func get_player_path_to(index):
	print(index,player_instance.index_positioin())
	#add player index in queue, keep looking around
	var queue = [[player_instance.index_positioin(),[]]]
	if index == player_instance.index_positioin():
		return []
	var vis = {player_instance.index_positioin():true}
	while queue.size()>0:
		#print("queue ",queue)
		var top = queue.pop_front()
		var top_position = top[0]
		for d in Constants.DIR4:
			var new_index = top_position+d
			if vis.has(new_index):
				continue
			vis[new_index]= true
			#print("new index ",new_index)
			var new_path = top[1].duplicate()
			#print("new path ",new_path)
			new_path.push_back(new_index)
			if new_index == index:
				return new_path
				
			if Utils.in_bound(new_index,width,height):
				var tile:Tile = index_to_tile_map[new_index]
				if tile.can_pass():
					var new_element = [new_index,new_path]
					queue.push_back(new_element)
					
	return null
	
func on_touched_tile(index):
	if not index_to_tile_map.has(index):
		return
	var tile = index_to_tile_map[index]
	var player_path_to_tile = get_player_path_to(index)
	if player_path_to_tile:
		#print("path ",player_path_to_tile)
		yield(player_instance.move_path(player_path_to_tile),"completed")
		#move player
		tile.cover_state = Constants.CoverState.None
		tile.update()
	else:
		print("unaccessible")
	#if not accessible, show warning
	#if accessible, and has cover, move there and hide cover
	#if is player, click player
	#if not has cover, click tile
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
