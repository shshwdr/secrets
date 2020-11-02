extends Node2D


onready var cover_sprite = $cover

var cover_accessible_image = preload("res://art/tile_cover_revealable.png")
var cover_not_accessible_image = preload("res://art/tile_cover_unrevealable.png")

var item
var cover_state


func init(_item, _cover_state):
	item = _item
	cover_state = _cover_state

func add_cover():
	match cover_state:
		Constants.CoverState.None:
			pass
		Constants.CoverState.Accessible:
			cover_sprite.texture = cover_accessible_image
		Constants.CoverState.NotAccessible:
			cover_sprite.texture = cover_not_accessible_image

func _ready():
	#add item
	add_cover()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
