extends Node2D

class_name Tile

onready var cover_sprite = $cover

var cover_accessible_image = preload("res://art/tile_cover_revealable.png")
var cover_not_accessible_image = preload("res://art/tile_cover_unrevealable.png")

var item
var cover_state


func update():
	
	add_cover()

func init(_item, _cover_state):
	item = _item
	cover_state = _cover_state

func add_cover():
	match cover_state:
		Constants.CoverState.None:
			cover_sprite.texture = null
		Constants.CoverState.Accessible:
			cover_sprite.texture = cover_accessible_image
		Constants.CoverState.NotAccessible:
			cover_sprite.texture = cover_not_accessible_image

func _ready():
	update()

func can_pass():
	return cover_state == Constants.CoverState.None

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
