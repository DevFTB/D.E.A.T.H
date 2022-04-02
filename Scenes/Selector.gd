extends Node2D

export (NodePath) var obstacle_map_path
export (NodePath) var floor_map_path
onready var obstacle_tile_map : TileMap = get_node(obstacle_map_path)
onready var floor_tile_map : TileMap = get_node(floor_map_path)

enum TARGET_TYPE { player, enemy, cover, tile }
export(TARGET_TYPE) var target_type = TARGET_TYPE.enemy

var selection

onready var camera = get_parent()

func _ready():
	
	pass # Replace with function body.


func _process(delta):
	if selection != null:
		if(Input.is_action_just_pressed("unselect")):
			selection = null
			camera.unfocus()
	else:
		var mouse_pos = get_global_mouse_position()
		var tile = floor_tile_map.world_to_map(mouse_pos)
		var snapped_pos = floor_tile_map.map_to_world(tile)
		
		var new_pos = Vector2(snapped_pos.x, snapped_pos.y + 8)
		$Sprite.global_position = new_pos
	
	if(Input.is_action_just_pressed("select")):
		match (target_type):
			TARGET_TYPE.player:	
				select_player()
			TARGET_TYPE.enemy:
				select_enemy()
			TARGET_TYPE.cover:
				select_cover()
			TARGET_TYPE.tile:
				select_tile()	
		
		if(selection):
			print("selected %s" % selection)
	

func select_player():
	pass
func select_enemy():
	var mouse_pos = get_global_mouse_position()
	var tile = floor_tile_map.world_to_map(mouse_pos)
	var snapped_pos = floor_tile_map.map_to_world(tile)
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	

	for enemy in enemies:
		if enemy.global_position == snapped_pos:
			selection = enemy
			camera.focusOn(enemy.global_position)
			break			
			
	
	pass
	
func select_cover():
	var mouse_pos = get_global_mouse_position()
	var map_coords = obstacle_tile_map.world_to_map(mouse_pos)
	selection = map_coords

	pass
	
func select_tile():
	var mouse_pos = get_global_mouse_position()
	var map_coords = floor_tile_map.world_to_map(mouse_pos)

	print(map_coords)
	print(floor_tile_map.map_to_world(map_coords))
	selection = floor_tile_map.get_cell(map_coords.x, map_coords.y)
	

	pass

func set_select_mode(new_type):
	target_type = new_type
	selection = null
